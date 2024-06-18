-- What are the top 5 brands by receipts scanned for most recent month?
WITH RecentMonthReceipts AS (
    SELECT receiptId
    FROM Detailed_Receipt
    WHERE dateScanned >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
      AND dateScanned < DATE_TRUNC('month', CURRENT_DATE)
),
BrandReceipts AS (
    SELECT b.brandName, COUNT(ril.receiptId) AS receiptCount
    FROM RecentMonthReceipts rm
    LEFT JOIN Receipt_ItemList ril ON rm.receiptId = ril.receiptId
    LEFT JOIN Product_Information pi ON ril.barcode = pi.barcode
    LEFT JOIN Brand_Dimension bd ON pi.barcode = bd.barcode
    LEFT JOIN Brand_Information b ON bd.brandId = b.brandId
    GROUP BY b.brandName
),
RankedBrands AS (
    SELECT brandName, receiptCount,
           RANK() OVER (ORDER BY receiptCount DESC) AS rank
    FROM BrandReceipts
)
SELECT brandName, receiptCount
FROM RankedBrands
WHERE rank <= 5
ORDER BY rank;