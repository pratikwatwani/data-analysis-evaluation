--Which brand has the most transactions among users who were created within the past 6 months?
WITH RecentUsers AS (
    SELECT userId
    FROM Users_Dimension
    WHERE createdDate >= CURRENT_DATE - INTERVAL '6 months'
),
UserReceipts AS (
    SELECT rf.receiptId, ril.barcode
    FROM Receipts_Fact rf
    JOIN Detailed_Receipt dr ON rf.receiptId = dr.receiptId
    JOIN Receipt_ItemList ril ON dr.receiptId = ril.receiptId
    WHERE rf.userId IN (SELECT userId FROM RecentUsers)
),
BrandTransactions AS (
    SELECT bd.brandId, COUNT(ur.receiptId) AS transactionCount
    FROM UserReceipts ur
    JOIN Brand_Dimension bd ON ur.barcode = bd.barcode
    GROUP BY bd.brandId
),
RankedBrands AS (
    SELECT bt.brandId, bt.transactionCount,
           RANK() OVER (ORDER BY bt.transactionCount DESC) AS rank
    FROM BrandTransactions bt
)
SELECT bi.brandName, rb.transactionCount
FROM RankedBrands rb
JOIN Brand_Information bi ON rb.brandId = bi.brandId
WHERE rb.rank = 1;