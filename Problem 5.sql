USE ENTV

-- 1.	Display StaffID, StaffName, VendorName, and Total Transaction (Obtained from counting the purchase transaction) for every		 transaction happens later than August and StaffName starts with letter 'B’.
SELECT
	s.StaffID,
	StaffName,
	VendorName,
	COUNT(PurchaseID) [Total Transaction]
FROM Staff s
JOIN PurchaseTransactionHeader pth ON pth.StaffID = s.StaffID
JOIN Vendor v ON v.VendorID = pth.VendorID
WHERE MONTH(PurchaseDate) > 8 AND StaffName LIKE 'B%'
GROUP BY s.StaffID, StaffName, VendorName

-- 2.	Display CustomerID (obtained by last 3 characters), CustomerName, and Total Spending (obtained from sum of all TelevisionPrice times Quantity) for every CustomerName contains letter 'a' and TelevisionName contains 'LED'
SELECT
	RIGHT(c.CustomerID,3) [CustomerID],
	CustomerName,
	SUM(TelevisionPrice * SalesQuantity) [Total Spending]
FROM Customer c
JOIN SalesTransactionHeader sth ON sth.CustomerID = c.CustomerID
JOIN SalesTransactionDetail std ON std.SalesID  = sth.SalesID
JOIN Television t ON t.TelevisionID = std.TelevisionID
WHERE CustomerName LIKE '%a%' AND TelevisionName LIKE '%LED%'
GROUP BY c.CustomerID, CustomerName


-- 3.	Display StaffName (obtained from the first name of the Staff), TelevisionName, and Total Price (obtained from sum of all TelevisionPrice times Quantity) for every transaction happens more than twice and TelevisionName contains 'UHD'. (sales transaction)
SELECT
	SUBSTRING(StaffName, 1, CHARINDEX(' ', StaffName)-1) [StaffName],
	TelevisionName,
	SUM(TelevisionPrice * SalesQuantity) [Total Price]
FROM Staff s
JOIN SalesTransactionHeader sth ON sth.StaffID = s.StaffID
JOIN SalesTransactionDetail std ON std.SalesID = sth.SalesID
JOIN Television t ON t.TelevisionID = std.TelevisionID
WHERE TelevisionName LIKE '%UHD%'
GROUP BY StaffName, TelevisionName, SalesQuantity

-- 4.	Display TelevisionName (obtained from TelevisionName in upper case format), Max Television Sold (obtained from the maximum quantity that has been sold in one transaction end with the word ‘ Pc(s)’), Total Television Sold (obtained from sum of the quantity that sold in all transaction end with the word ‘ Pc(s)’) for every Television which price is more than 3000000 and sales happens after February, order it by Total Television Sold ascendingly.
SELECT 
	UPPER(TelevisionName) [TelevisionName],
	CAST(MAX(SalesQuantity) AS VARCHAR) + ' Pc(s)' [Max Television Sold],
	CAST(SUM(SalesQuantity) AS VARCHAR) + ' Pc(s)' [Total Television Sold]
FROM Television t
JOIN SalesTransactionDetail std ON std.TelevisionID = t.TelevisionID
JOIN SalesTransactionHeader sth ON sth.SalesID = std.SalesID
WHERE TelevisionPrice > 3000000 AND month(SalesDate) > 2
GROUP BY TelevisionName
ORDER BY SUM(SalesQuantity) ASC

-- 5.	Display VendorName,VendorPhone (obtained from vendorPhone with ‘+62’ replace by ‘0’), TelevisionName, TelevisionPrice (obtained from adding ‘Rp. ’ before TelevisionPrice) for every Television which price more than average of all TelevisionPrice and VendorName must be at least 2 words. (alias subquery)
SELECT
	VendorName,
	REPLACE(VendorPhoneNumber,'+62','0') [VendorPhone],
	TelevisionName,
	'Rp. ' + CAST(TelevisionPrice AS VARCHAR) [TelevisionPrice]
FROM Vendor v
JOIN PurchaseTransactionHeader pth ON pth.VendorID = v.VendorID
JOIN PurchaseTransactionDetail ptd ON ptd.PurchaseID = pth.PurchaseID
JOIN Television t ON t.TelevisionID = ptd.TelevisionID,
	(
		SELECT
			AVG(TelevisionPrice) [AveragePrice]
		FROM Television
	)alias
WHERE TelevisionPrice > alias.AveragePrice AND LEN(VendorName) - LEN(REPLACE(VendorName,' ','')) >= 1

-- 6.	Display StaffID, StaffName, StaffEmail (obtained from words before ‘@’), and StaffSalary for every StaffSalary more than average of StaffSalary and taken care transaction for customer whose name contains ‘o’. (alias subquery)
SELECT
	s.StaffID,
	StaffName,
	SUBSTRING(StaffEmail,1,CHARINDEX('@',StaffEmail)-1) [StaffEmail],
	StaffSalary
FROM Staff s
JOIN SalesTransactionHeader sth ON sth.StaffID = s.StaffID
JOIN Customer c ON c.CustomerID = sth.CustomerID,
	(
		SELECT
			AVG(StaffSalary) [AverageSalary]
		FROM Staff
	)alias
WHERE StaffSalary > alias.AverageSalary AND CustomerName LIKE '%o%'

-- 7.	Display TelevisionID (obtained from replacing ‘TE’ to ‘Television ’), TelevisionName, TelevisionBrand (obtained from TelevisionBrand in upper case format), and TotalSold (obtained from the sum of quantity sold to customer end with the word ‘ Pc(s)’) for every TelevisionName that contains the word ‘LED’ and TotalSold more than average of the total sold of all television , order it by TotalSold ascendingly. (alias subquery)
SELECT
	REPLACE(t.TelevisionID,'TE','Television') [TelevisionID],
	TelevisionName,
	UPPER(TelevisionBrandName) [TelevisionBrandName],
	cast(alias.sumQuantity AS VARCHAR) + ' Pc(s)' [TotalSold]
FROM Television t
JOIN TelevisionBrand tb ON tb.TelevisionBrandID = t.TelevisionBrandID,
	(
		SELECT
			t.TelevisionID,
			SUM(std.SalesQuantity) [sumQuantity]
		FROM SalesTransactionDetail std
		JOIN Television t ON t.TelevisionID = std.TelevisionID
		GROUP BY t.TelevisionID
	)alias,
		(
			SELECT
				AVG([sumQuantity]) [averageQuantity]
			FROM
			(
				SELECT
					t.TelevisionID,
					SUM(std.SalesQuantity) [sumQuantity]
				FROM SalesTransactionDetail std
				JOIN Television t ON t.TelevisionID = std.TelevisionID
				GROUP BY t.TelevisionID
			)alias2
		)alias3
WHERE alias.TelevisionID = t.TelevisionID AND alias.sumQuantity > alias3.averageQuantity AND TelevisionName LIKE '%LED%'
ORDER BY alias.sumQuantity ASC

-- 8.	Display VendorName, VendorEmail, VendorPhone (obtained by replacing VendorPhone first character into ‘+62’), and Total Quantity (obtained from the sum of quantity purchased and ended with ‘ Pc(s)’) for every purchase which television price is higher than the maximum television price in every purchase that occurred between the 3th and 6th month of the year and VendorName must at least 2 words. (alias subquery)
SELECT
	VendorName,
	VendorEmail,
	REPLACE(VendorPhoneNumber,LEFT(VendorPhoneNumber,1),'+62') [VendorPhone],
	CAST(SUM(PurchaseQuantity) AS VARCHAR) + ' Pc(s)'[Total Quantity]
FROM Vendor v
JOIN PurchaseTransactionHeader pth ON pth.VendorID = v.VendorID
JOIN PurchaseTransactionDetail ptd ON ptd.PurchaseID = pth.PurchaseID
JOIN Television t ON t.TelevisionID = ptd.TelevisionID,
	(
		SELECT
			MAX(TelevisionPrice) [MaxPrice]
		FROM Television t
		JOIN PurchaseTransactionDetail ptd ON ptd.TelevisionID = t.TelevisionID
		JOIN PurchaseTransactionHeader pth ON pth.PurchaseID = ptd.PurchaseID
		WHERE MONTH(PurchaseDate) BETWEEN 3 AND 6 
	)alias
WHERE TelevisionPrice > alias.MaxPrice AND VendorName LIKE '% %'
GROUP BY VendorName, VendorEmail, VendorPhoneNumber

-- 9.	Create a view named ‘CustomerTransaction’ to display CustomerName, CustomerEmail, Maximum Quantity Television (obtained from the maximum quantity sold and ended with ‘ Pc(s)’), and Minimum Quantity Television (obtained from the minimum quantity purchased and ended with ‘ Pc(s)’) for every customer whose name contains ‘b’ and the maximum quantity isn’t equal to its minimum quantity.
GO
CREATE VIEW CustomerTransaction
AS
SELECT
	CustomerName,
	CustomerEmail,
	CAST(MAX(SalesQuantity) AS VARCHAR) + ' Pc(s)' [Maximum Quantity Television],
	CAST(MIN(PurchaseQuantity) AS VARCHAR) + ' Pc(s)' [Minimum Quantity Television]
FROM Customer c
JOIN SalesTransactionHeader sth ON sth.CustomerID = c.CustomerID
JOIN SalesTransactionDetail std ON std.SalesID = sth.SalesID
JOIN Television t ON t.TelevisionID = std.TelevisionID
JOIN PurchaseTransactionDetail ptd ON ptd.TelevisionID = t.TelevisionID
WHERE CustomerName LIKE '%b%'
GROUP BY CustomerName, CustomerEmail
HAVING MAX(SalesQuantity) != MIN(PurchaseQuantity)

-- 10.	Create a view named 'StaffTransaction' to display StaffName, StaffEmail, StaffPhone, Count Transaction (obtained from total number of transaction), and Total Television (obtained by total quantity of television purchased) for every transaction that the date of transaction happened later than 10th day and staff email ends with '@gmail.com'.
GO
CREATE VIEW StaffTransaction
AS
SELECT
	StaffName,
	StaffEmail,
	StaffPhoneNumber,
	COUNT(pth.PurchaseID) [Count Transaction],
	SUM(PurchaseQuantity) [Total Television]
FROM Staff s
JOIN PurchaseTransactionHeader pth ON pth.StaffID = s.StaffID
JOIN PurchaseTransactionDetail ptd ON ptd.PurchaseID = pth.PurchaseID
JOIN Television t ON t.TelevisionID = ptd.TelevisionID
GROUP BY StaffName, StaffEmail, StaffPhoneNumber












