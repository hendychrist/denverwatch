
	-- Table StaffPosition
	Create table StaffPosition(
	PositionID char(5) not null check(PositionID like 'SP[0-9][0-9][0-9]'),
	StaffPositionName varchar(50) not null unique ,
	PositionGrade varchar(50) not null
	PRIMARY KEY(PositionID)
	) 

	--Table Staff
	Create table Staff(
	StaffID char(5) primary key, check (StaffID like 'ST[0-9][0-9][0-9]'),
	PositionID char(5) FOREIGN KEY REFERENCES StaffPosition(PositionID),
	StaffName varchar(50) not null, 
	StaffGender varchar(50) not null,
	StaffEmail varchar(50) not null,
	StaffPhone varchar(50) not null,
	StaffDOB DATE not null,
	StaffSalary int not null
	)

	-- Table watchType
	Create table watchType(
	WatchTypeID char(5) NOT NULL unique check(watchTypeID like 'WT[0-9][0-9][0-9]'),
	TypeName varchar(20) NOT NULL unique,
	PRIMARY KEY (WatchTypeID)
	)

	-- Table Watch
	Create table Watch(
	WatchID varchar(5) not null PRIMARY KEY check (watchID like 'WH[0-9][0-9][0-9]'),
	WatchTypeID char(5) FOREIGN KEY REFERENCES  watchType(WatchTypeID),
	WatchName varchar(50) not null,
	WatchSellingPrice varchar(30) not null,
	WatchPurchasePrice varchar(30) not null
	)

	-- Table Customer
	Create table Customer(
	CustomerID char(5) PRIMARY KEY check(CustomerID like 'CS[0-9][0-9][0-9]'),
	CustomerName varchar(50) not null,
	CustomerPhone varchar(20) not null,
	CustomerAddress varchar(50) not null,
	CustomerEmail varchar(50) not null,
	CustomerGender varchar(10) not null,
	)

	-- Table Vendor
	Create table Vendor(
	VendorID char(5) PRIMARY KEY check(VendorID like 'VN[0-9][0-9][0-9]'),
	VendorName varchar(50) not null,
	VendorPhone varchar(20) not null,
	VendorAddress varchar(50) not null,
	VendorEmail varchar(50) not null 
	)

	-- Table HeaderSalesTransaction
	CREATE TABLE HeaderSalesTransaction(
	TransactionID char(5) unique check(TransactionID like 'SH[0-9][0-9][0-9]'),
	CustomerID char(5) FOREIGN KEY REFERENCES Customer(CustomerID),
	StaffID char(5) FOREIGN KEY REFERENCES Staff(StaffID),
	TransactionDate date not null,
	PRIMARY KEY (TransactionID)
	)

	-- Table DetailSalesTransaction
	CREATE TABLE DetailSalesTransaction(
	SalesTransactionDetailID char(5) FOREIGN KEY REFERENCES HeaderSalesTransaction(TransactionID),
	WatchID varchar(5) FOREIGN KEY REFERENCES Watch(WatchID),
	Quantity varchar(30) not null,
	PRIMARY KEY(SalesTransactionDetailID,WatchID)
	)

	-- Table HeaderPurchaseTransaction
	CREATE TABLE HeaderPurchaseTransaction(
	PurchaseTranscationID char(5) primary key check(PurchaseTranscationID like 'PH[0-9][0-9][0-9]'),
	StaffID char(5) FOREIGN KEY REFERENCES Staff(StaffId),
	VendorID char(5) FOREIGN KEY REFERENCES Vendor(VendorID),
	TransactionDate date not null,
	)

	-- Table DetailPurchaseTransaction
	CREATE TABLE DetailPurchaseTransaction(
	PurchaseTranscationID char(5) FOREIGN KEY REFERENCES HeaderPurchaseTransaction(PurchaseTranscationID),
	WatchID varchar(5) FOREIGN KEY REFERENCES Watch(WatchID),
	Quantity varchar(30) not null,
	PRIMARY KEY (PurchaseTranscationID,WatchID)
	)

	ALTER TABLE Customer 
	ADD CONSTRAINT checkEmail check (CustomerEmail like '%@%' )

	/* ALTER TABLE Customer
	ADD CONSTRAINT CPhone check(CustomerPhone like '[0-9]*8') or (CustomerPhone like '[0-9]*9') or (CustomerPhone like '[0-9]*10') or
	(CustomerPhone like '[0-9]*11') or (CustomerPhone like '[0-9]*12') or (CustomerPhone like '[0-9]*13') or (CustomerPhone like '[0-9]*14') */