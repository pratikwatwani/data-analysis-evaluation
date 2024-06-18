--Which brand has the most spend among users who were created within the past 6 months?

WITH RecentUsers AS (
    SELECT userId
    FROM Users_Dimension
    WHERE createdDate >= CURRENT_DATE - INTERVAL '6 months'
),
UserReceipts AS (
    SELECT rf.receiptId, rf.totalSpent, ril.barcode
    FROM Receipts_Fact rf
    LEFT JOIN Detailed_Receipt dr ON rf.receiptId = dr.receiptId
    LEFT JOIN Receipt_ItemList ril ON dr.receiptId = ril.receiptId
    WHERE rf.userId IN (SELECT userId FROM RecentUsers)
),
BrandSpending AS (
    SELECT bd.brandId, SUM(ur.totalSpent) AS totalSpend
    FROM UserReceipts ur
    LEFT JOIN Brand_Dimension bd ON ur.barcode = bd.barcode
    GROUP BY bd.brandId
),
RankedBrands AS (
    SELECT bs.brandId, bs.totalSpend,
           RANK() OVER (ORDER BY bs.totalSpend DESC) AS rank
    FROM BrandSpending bs
)
SELECT bi.brandName, rb.totalSpend
FROM RankedBrands rb
JOIN Brand_Information bi ON rb.brandId = bi.brandId
WHERE rb.rank = 1;