--When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?

SELECT rs.rewardsReceiptStatus, AVG(rf.totalSpent) AS avgSpend
FROM Receipts_Fact rf
JOIN Detailed_Receipt dr ON rf.receiptId = dr.receiptId
JOIN Receipt_Status rs ON dr.rewardsReceiptStatusId = rs.rewardsReceiptStatusId
WHERE rs.rewardsReceiptStatus IN ('Accepted', 'Rejected')
GROUP BY rs.rewardsReceiptStatus
ORDER BY avgSpend DESC;