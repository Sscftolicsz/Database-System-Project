USE ENTV

-- SIMULATE TRANSACTION PROCESS FOR SALES
-- Seorang staff yang memiliki nama Bijan Bayu dengan ID Staff 'ST007' melayani Customer yang memiliki nama 'Krisna Putra Yudha' dengan ID Customer 'CU004' yang ingin membeli 2 televisi yaitu 'Samsung 32" LED TV - 32N4300' dengan ID TV 'TE001' dan 'Coocaa 50" SMART TV - 50S3N' dengan ID TV 'TE012' pada tanggal 20 desember 2021
	
	BEGIN TRAN
	INSERT INTO SalesTransactionHeader VALUES
	('SA016','ST007','CU004','2021-12-20')

	INSERT INTO SalesTransactionDetail VALUES
	('SA016','TE001','1'),
	('SA016','TE012','1')
	ROLLBACK

-- SIMULATE TRANSACTION PROCESS FOR PURCHASE
-- Seorang staff yang memiliki nama Lukas Dimas Daely dengan ID Staff 'ST001' melakukan pembelian 3 televisi dari vendor yang memiliki nama Mandiri Megah Electric dengan ID Vendor 'VE003' berupa 2 buah televisi Sony Bravia X90J Class HDR 4K UHD Smart TV - 55 Inch dengan ID TV 'TE011' dan 1 buah televisi TV 32 INCH Xiaomi ANDROID dengan ID TV 'TE010' pada tanggal 11 Februari 2021

	BEGIN TRAN
	INSERT INTO PurchaseTransactionHeader VALUES
	('PE016','ST001','VE003','2021-02-11')

	INSERT INTO PurchaseTransactionDetail VALUES
	('PE016','TE010','1'),
	('PE016','TE011','2')
	ROLLBACK