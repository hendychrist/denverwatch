--No.1
	SELECT Staff.StaffName,StaffPosition.StaffPositionName,[Total Sales] = CAST(COUNT(DetailSalesTransaction.SalesTransactionDetailID)as varchar )+ ' Transactions'
	FROM StaffPosition
	JOIN Staff 
	ON StaffPosition.PositionID = Staff.PositionID
		JOIN HeaderSalesTransaction
		ON Staff.StaffID = HeaderSalesTransaction.StaffID
			JOIN DetailSalesTransaction
			ON HeaderSalesTransaction.TransactionID = DetailSalesTransaction.SalesTransactionDetailID
     WHERE StaffPosition.StaffPositionName like '%Marketing%' and cast(RIGHT(PositionGrade,2) AS INT) BETWEEN 1 and 10
	 GROUP BY  Staff.StaffName,StaffPosition.StaffPositionName

	SELECT * FROM DetailSalesTransaction

	--No.2
	SELECT [SalesID] = TransactionID, [SalesDate] = TransactionDate, WatchName , [Total Price] = SUM(cast(Watch.WatchSellingPrice AS INT) * cast(DetailSalesTransaction.Quantity AS INT))
	FROM HeaderSalesTransaction
	 JOIN DetailSalesTransaction
	 ON HeaderSalesTransaction.TransactionID = DetailSalesTransaction.SalesTransactionDetailID
		JOIN Watch
		ON Watch.WatchID = DetailSalesTransaction.WatchID
	WHERE  TransactionID = 'SH004' and WatchName like '% % %'
	GROUP BY TransactionID,TransactionDate,WatchName


	--No.3 
	SELECT StaffName , [SalesID] = TransactionID, [Transaction Date] =  CONVERT(varchar,TransactionDate,107),[WatchTypeName] = TypeName
	FROM Staff
		JOIN HeaderSalesTransaction
		ON Staff.StaffID = HeaderSalesTransaction.StaffID
			JOIN DetailSalesTransaction
			ON HeaderSalesTransaction.TransactionID = DetailSalesTransaction.SalesTransactionDetailID
				JOIN Watch
				ON Watch.WatchID = DetailSalesTransaction.WatchID
					JOIN watchType
					ON watchType.WatchTypeID = Watch.WatchTypeID	
	WHERE Quantity > 2 and StaffName like '% % %'
		
	--NO.4
	SELECT VendorName,[PurchaseID] = HeaderPurchaseTransaction.PurchaseTranscationID ,
		 [Total Transaction] = COUNT(DetailPurchaseTransaction.PurchaseTranscationID),
		 [Transaction Date ] = CONVERT(varchar,HeaderPurchaseTransaction.TransactionDate,106)
	FROM Vendor		
	 JOIN HeaderPurchaseTransaction
	 ON Vendor.VendorID = HeaderPurchaseTransaction.VendorID
	   JOIN DetailPurchaseTransaction
	   ON DetailPurchaseTransaction.PurchaseTranscationID = HeaderPurchaseTransaction.PurchaseTranscationID
		JOIN Watch
		ON Watch.WatchID = DetailPurchaseTransaction.WatchID
		WHERE Watch.WatchPurchasePrice > 15000000000 and Year(TransactionDate) = 2018
	   GROUP BY VendorName , HeaderPurchaseTransaction.PurchaseTranscationID, HeaderPurchaseTransaction.TransactionDate


	--No.5

	 SELECT [SalesID] = 'Transaction no. ' + RIGHT(TransactionID,3), StaffName, StaffPhone
	 FROM  HeaderSalesTransaction
		JOIN Staff
		 ON  Staff.StaffID = HeaderSalesTransaction.StaffID
	 WHERE  StaffSalary > (SELECT AVG(StaffSalary) FROM Staff WHERE year(StaffDOB) < 1990)
	  GROUP BY TransactionID,StaffName,StaffPhone
		
	--No.6
	SELECT StaffName,[StaffPhone] = '+12 ' + RIGHT(StaffPhone,11) ,
	       [Purchase Date] = CONVERT(varchar,TransactionDate, 109)  
	FROM Staff
		JOIN HeaderPurchaseTransaction
		ON  Staff.StaffID = HeaderPurchaseTransaction.StaffID
			JOIN (SELECT PurchaseTranscationID,[Quantity] = MIN(Quantity) FROM DetailPurchaseTransaction GROUP BY PurchaseTranscationID) as cek 
			ON HeaderPurchaseTransaction.PurchaseTranscationID = cek.PurchaseTranscationID
	WHERE Quantity > (
			SELECT cek.Quantity 
			FROM DetailPurchaseTransaction
				JOIN HeaderPurchaseTransaction
				ON HeaderPurchaseTransaction.PurchaseTranscationID = DetailPurchaseTransaction.PurchaseTranscationID
			WHERE MONTH(HeaderPurchaseTransaction.TransactionDate) = 1
			 ) 
	GROUP BY StaffName,StaffPhone,TransactionDate

	--No.7
	SELECT [PurchaseId] = HeaderPurchaseTransaction.PurchaseTranscationID,
		   [StaffFirstName] = LEFT(StaffName,CHARINDEX(' ',StaffName + ' ') -1),
		   [Total Quantity] = SUM(CONVERT(int, DetailPurchaseTransaction.Quantity))
	FROM Staff
		JOIN HeaderPurchaseTransaction
		ON Staff.StaffID = HeaderPurchaseTransaction.StaffID
			JOIN DetailPurchaseTransaction
			ON HeaderPurchaseTransaction.PurchaseTranscationID = DetailPurchaseTransaction.PurchaseTranscationID
				JOIN (SELECT WatchID,
						[WatchPurchasePrice] = CONVERT(bigint, WatchPurchasePrice),
						cek = AVG(CONVERT(bigint,Watch.WatchPurchasePrice))
						FROM Watch 
						GROUP BY WatchID,WatchPurchasePrice ) as pab
						ON DetailPurchaseTransaction.WatchID = pab.WatchID
	WHERE pab.WatchPurchasePrice < pab.cek and  Quantity BETWEEN 10 and 30 
	GROUP BY HeaderPurchaseTransaction.PurchaseTranscationID,StaffName

	HARGA price < RATA - RATA DARI pruchase price
	dan QUantity beetween 10 and 30 

	--No.8 (alias subquery)
	SELECT [CustomerName] = UPPER(CustomerName),
		   [CustomerPhone] = '+62 ' + RIGHT(CustomerPhone,11),
		   [Total Price] = 'IDR ' + CAST(SUM(CAST(Quantity as int)) * WatchSellingPrice AS VARCHAR) 
	FROM Customer
		JOIN HeaderSalesTransaction
		ON HeaderSalesTransaction.CustomerID = Customer.CustomerID
			JOIN DetailSalesTransaction
			ON HeaderSalesTransaction.TransactionID = DetailSalesTransaction.SalesTransactionDetailID
				JOIN Watch
				ON DetailSalesTransaction.WatchID = Watch.WatchID
	WHERE Customer.CustomerName like '% % %'and WatchSellingPrice > (SELECT AVG(CONVERT(int ,WatchSellingPrice)) FROM Watch)
	GROUP BY CustomerName , CustomerPhone , WatchSellingPrice


	--No.9
	CREATE VIEW [CustomerQuantityViewer]
	AS SELECT [CustomerID] = 'Customer ' + RIGHT(Customer.CustomerID,3), CustomerName, CustomerEmail,
	       [Maximum Quantity] = MAX(cek.maks)   
	FROM Customer
		JOIN HeaderSalesTransaction
		ON HeaderSalesTransaction.CustomerID = Customer.CustomerID
			JOIN (SELECT SalesTransactionDetailID,Quantity,
						 maks = MAX(Quantity),
						 mins = MIN(Quantity) 
				   FROM DetailSalesTransaction
				   GROUP BY SalesTransactionDetailID,Quantity
				   HAVING MIN(Quantity)  > 2
				   ) as cek
			ON HeaderSalesTransaction.TransactionID = cek.SalesTransactionDetailID
	WHERE Customer.CustomerGender = 'Male'
	GROUP BY Customer.CustomerID,CustomerName,CustomerEmail
	UNION
	SELECT [CustomerID] = 'Customer ' + RIGHT(Customer.CustomerID,3), CustomerName, CustomerEmail,
	       [Minimum Quantity] = MIN(cek.mins)   
	FROM Customer
		JOIN HeaderSalesTransaction
		ON HeaderSalesTransaction.CustomerID = Customer.CustomerID
			JOIN (SELECT SalesTransactionDetailID,Quantity,
						 maks = MAX(Quantity),
						 mins = MIN(Quantity) 
				   FROM DetailSalesTransaction
				   GROUP BY SalesTransactionDetailID,Quantity
				   HAVING MIN(Quantity)  > 2
				   ) as cek
			ON HeaderSalesTransaction.TransactionID = cek.SalesTransactionDetailID
	WHERE Customer.CustomerGender = 'Male'
	GROUP BY Customer.CustomerID,CustomerName,CustomerEmail


	SELECT * FROM [CustomerQuantityViewer] 
	DROP VIEW [CustomerQuantityViewer]

	--No.10
	CREATE VIEW [VendorPurchaseViewer]
	AS 
		SELECT Vendor.VendorID, 
			   [VendorName] = UPPER(VendorName),
			   'IDR ' + CAST((SUM(CAST(WatchPurchasePrice as bigint)) * DetailPurchaseTransaction.Quantity) as varchar) as TotalPurchase ,
			   [Total Transaction] = ( SELECT DISTINCT [Total Transaction] = SUM(CAST(WatchPurchasePrice AS BIGINT)) FROM Watch )
	FROM Vendor
		JOIN HeaderPurchaseTransaction
		ON HeaderPurchaseTransaction.VendorID = Vendor.VendorID
		 JOIN DetailPurchaseTransaction
		 ON DetailPurchaseTransaction.PurchaseTranscationID = HeaderPurchaseTransaction.PurchaseTranscationID
			JOIN (
			--LOADING
				SELECT WatchID,SUM(CAST(WatchPurchasePrice as bigint ))
				FROM Watch
				GROUP BY WatchID
			) AS bubur
			ON DetailPurchaseTransaction.WatchID = bubur.WatchID
	GROUP BY Quantity,VendorName,Vendor.VendorID

		SELECT DISTINCT [Total Transaction] = SUM(CAST(WatchPurchasePrice AS BIGINT)) FROM Watch
		WHERE Total Purchase > 50000000000