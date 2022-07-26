CREATE DATABASE ENTV

USE ENTV

CREATE TABLE Customer(
	CustomerID CHAR(5) PRIMARY KEY CHECK(CustomerID LIKE 'CU[0-9][0-9][0-9]'),
	CustomerName VARCHAR(100) NOT NULL,
	CustomerEmail VARCHAR(100) NOT NULL CHECK(CustomerEmail LIKE '%"@yahoo.com"' OR CustomerEmail LIKE '%"@gmail.com"'),
	CustomerGender VARCHAR(10) NOT NULL CHECK(CustomerGender LIKE 'Male' or CustomerGender LIKE 'Female'),
	CustomerPhoneNumber VARCHAR(20) NOT NULL CHECK(CustomerPhoneNumber LIKE '+62%'),
	CustomerAddress VARCHAR(100),	
	CustomerDOB DATE NOT NULL
)

CREATE TABLE Staff(
	StaffID char(5) PRIMARY KEY CHECK(StaffID LIKE 'ST[0-9][0-9][0-9]'),
	StaffName VARCHAR(100) NOT NULL,
	StaffEmail VARCHAR(100) NOT NULL,
	StaffGender VARCHAR(10) NOT NULL CHECK(StaffGender LIKE 'Male' or StaffGender LIKE 'Female'),
	StaffPhoneNumber VARCHAR(20) NOT NULL CHECK(StaffPhoneNumber LIKE '+62%'),
	StaffAddress VARCHAR(100),
	StaffSalary INT NOT NULL,
	StaffDOB DATE NOT NULL CHECK(year(StaffDOB) <= 2000)
)

CREATE TABLE Vendor(
	VendorID CHAR(5) PRIMARY KEY CHECK(VendorID LIKE 'VE[0-9][0-9][0-9]'),
	VendorName VARCHAR(100) NOT NULL CHECK(len(VendorName) > 3),
	VendorEmail VARCHAR(100) NOT NULL,
	VendorPhoneNumber VARCHAR(20) NOT NULL,
	VendorAddress VARCHAR(100)
)

CREATE TABLE TelevisionBrand(
	TelevisionBrandID CHAR(5) PRIMARY KEY CHECK(TelevisionBrandID LIKE 'TB[0-9][0-9][0-9]'),
	TelevisionBrandName VARCHAR(100) NOT NULL
)

CREATE TABLE Television(
	TelevisionID CHAR(5) PRIMARY KEY CHECK(TelevisionID LIKE 'TE[0-9][0-9][0-9]'),
	TelevisionBrandID CHAR(5) FOREIGN KEY REFERENCES TelevisionBrand(TelevisionBrandID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	TelevisionName VARCHAR(100) NOT NULL,
	TelevisionPrice INT NOT NULL CHECK(TelevisionPrice BETWEEN 1000000 AND 20000000)
)

CREATE TABLE PurchaseTransactionHeader(
	PurchaseID CHAR(5) PRIMARY KEY CHECK(PurchaseID LIKE 'PE[0-9][0-9][0-9]'),
	StaffID CHAR(5) FOREIGN KEY REFERENCES Staff(StaffID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	VendorID CHAR(5) FOREIGN KEY REFERENCES Vendor(VendorID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	PurchaseDate DATE NOT NULL
)

CREATE TABLE PurchaseTransactionDetail(
	PurchaseID CHAR(5) FOREIGN KEY REFERENCES PurchaseTransactionHeader(PurchaseID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	TelevisionID CHAR(5) FOREIGN KEY REFERENCES Television(TelevisionID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	PurchaseQuantity INT NOT NULL,
	PRIMARY KEY(PurchaseID, TelevisionID)
)

CREATE TABLE SalesTransactionHeader(
	SalesID CHAR(5) PRIMARY KEY CHECK(SalesID LIKE 'SA[0-9][0-9][0-9]'),
	StaffID CHAR(5) FOREIGN KEY REFERENCES Staff(StaffID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	CustomerID CHAR(5) FOREIGN KEY REFERENCES Customer(CustomerID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	SalesDate DATE NOT NULL
)

CREATE TABLE SalesTransactionDetail(
	SalesID CHAR(5) FOREIGN KEY REFERENCES SalesTransactionHeader(SalesID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	TelevisionID CHAR(5) FOREIGN KEY REFERENCES Television(TelevisionID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	SalesQuantity INT NOT NULL,
	PRIMARY KEY(SalesID, TelevisionID)
)


 