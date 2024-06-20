--How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?

WITH MonthlyReceipts AS (
    SELECT receiptId, DATE_TRUNC('month', purchaseDate) AS month
    FROM Detailed_Receipt
    WHERE purchaseDate >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '2 months')
      AND purchaseDate < DATE_TRUNC('month', CURRENT_DATE)
),
BrandReceipts AS (
    SELECT ril.barcode, COUNT(ril.receiptId) AS receiptCount, mr.month
    FROM MonthlyReceipts mr
    LEFT JOIN Receipt_ItemList ril ON mr.receiptId = ril.receiptId
    GROUP BY ril.barcode, mr.month
),
RankedBrands AS (
    SELECT bd.brandId, br.receiptCount, br.month,
           RANK() OVER (PARTITION BY br.month ORDER BY br.receiptCount DESC) AS rank
    FROM BrandReceipts br
    LEFT JOIN Brand_Dimension bd ON br.barcode = bd.barcode
)
SELECT bi.brandName, rb.month, rb.receiptCount, rb.rank
FROM RankedBrands rb
LEFT JOIN Brand_Information bi ON rb.brandId = bi.brandId
WHERE rb.rank <= 5
ORDER BY rb.month DESC, rb.rank;