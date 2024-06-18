--When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
SELECT rs.rewardsReceiptStatus, SUM(rf.purchaseItemCount) AS totalItems
FROM Receipts_Fact rf
JOIN Detailed_Receipt dr ON rf.receiptId = dr.receiptId
JOIN Receipt_Status rs ON dr.rewardsReceiptStatusId = rs.rewardsReceiptStatusId
WHERE rs.rewardsReceiptStatus IN ('Accepted', 'Rejected')
GROUP BY rs.rewardsReceiptStatus
ORDER BY totalItems DESC;