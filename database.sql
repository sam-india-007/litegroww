CREATE DATABASE IF NOT EXISTS LiteGroww;

USE LiteGroww;


DROP TABLE IF EXISTS Cust_Stock;
DROP TABLE IF EXISTS Cust_ETF;
DROP TABLE IF EXISTS ETF;
DROP TABLE IF EXISTS Cust;
DROP TABLE IF EXISTS Stock;


CREATE TABLE ETF (
  TKR VARCHAR(10),
  SName VARCHAR(30) NOT NULL,
  Val DECIMAL(7,2), CHECK (Val>=0),
  Stocks_ETF INT(5) NOT NULL,
  AUM DECIMAL(10,2), CHECK (AUM>=0),
  AvailShares INT(8), CHECK (AvailShares>=0),
  TotalShares INT(9), CHECK (TotalShares>=0),
  PRIMARY KEY (TKR)
);

CREATE TABLE Cust (
  PAN CHAR(10),
  UName VARCHAR(30),
  Username VARCHAR(20) NOT NULL UNIQUE,
  Passwrd VARCHAR(30) NOT NULL,
  AccBal DECIMAL(8,2), CHECK (AccBal>=0),
  PRIMARY KEY (PAN)
);

CREATE TABLE Stock (
  TKR VARCHAR(10),
  SName VARCHAR(30) NOT NULL,
  CurValue DECIMAL(7,2), CHECK (CurValue>=0),
  TradeValue DECIMAL(7,2), CHECK (TradeValue>=0),
  PE DECIMAL(5,2),
  MarketCap DECIMAL(10,2),
  DY DECIMAL(4,2),
  Category VARCHAR(20) NOT NULL,
  AvailShares INT(10), CHECK (AvailShares>=0),
  TotalShares INT(11), CHECK (TotalShares>=0),
  PRIMARY KEY (TKR)
);

CREATE TABLE Cust_Stock (TKR VARCHAR(10), PAN CHAR(10), Num_Shares INT(10), Avg_Buy_Price DECIMAL(7,2), Hold_Val DECIMAL(9,2), CHECK (Hold_Val>=0), FOREIGN KEY (TKR) REFERENCES Stock(TKR), FOREIGN KEY (PAN) REFERENCES Cust(PAN));
CREATE TABLE Cust_ETF (TKR VARCHAR(10), PAN CHAR(10), Num_Shares INT(10), Avg_Buy_Price DECIMAL(7,2), Hold_Val DECIMAL(9,2), CHECK (Hold_Val>=0), FOREIGN KEY (TKR) REFERENCES ETF(TKR), FOREIGN KEY (PAN) REFERENCES Cust(PAN));

INSERT INTO Cust values ("ABCDSEFD", "Srijan", "Srijan13", "123234231", "10000");
INSERT INTO Cust values ("ABCDSEDSe", "Sammy", "Sammy", "12323420", "6900");
INSERT INTO ETF VALUES ("BEN", "Ben Holdings - Cement Bouquet", 69.00, 420, 42000.69,100,150);
INSERT INTO ETF VALUES ("GWEN", "Girish Funds", 79.00, 420, 4200.69,60,550);
INSERT INTO Stock VALUES ("KSB", "Amul", 74.56, 45.67, 6.78, 340000.69, 5.45, "Bank",110,250);
INSERT INTO Stock VALUES ("AD", "Yoshua Excellence", 47.56, 115.67, 16.78, 540000.69, 0.45, "IT",130,350);

DROP PROCEDURE IF EXISTS buy_share;

DELIMITER $$
USE LiteGroww$$
CREATE DEFINER='root'@'localhost' PROCEDURE buy_share (IN NoShares INT(10), IN buy_price DECIMAL(7,2), IN buy_tkr VARCHAR(10), IN Custpan CHAR(10))

MODIFIES SQL data
BEGIN
START TRANSACTION;
UPDATE Cust SET Cust.AccBal = Cust.AccBal - buy_price where Cust.PAN=Custpan;
UPDATE Stock SET Stock.AvailShares=Stock.AvailShares-NoShares where Stock.TKR=buy_tkr;
-- Inserting into Cust_Stock
IF (SELECT COUNT(*) FROM Cust_Stock WHERE Cust_Stock.PAN=Custpan AND Cust_Stock.TKR=buy_tkr)>0
	THEN UPDATE Cust_Stock SET Cust_Stock.Avg_Buy_Price=(Cust_Stock.hold_val+buy_price*NoShares)/(Cust_Stock.Num_Shares+NoShares) where Cust_Stock.PAN=Custpan;
	UPDATE Cust_Stock SET Cust_Stock.Hold_Val = Cust_Stock.hold_val+buy_price*NoShares;
	-- Setting number of shares
	UPDATE Cust_Stock SET Cust_Stock.Num_Shares=Cust_Stock.Num_Shares+NoShares where Cust_Stock.PAN=Custpan;
ELSE
	Insert into Cust_Stock values (buy_tkr,Custpan,NoShares,buy_price,buy_price*NoShares);
END IF;
commit;
END; $$
DELIMITER ;


-- call buy_share (4, 80, "KSB", 'ABCDSEDSe');

-- next fun

DROP PROCEDURE IF EXISTS buy_etf;

DELIMITER $$
USE LiteGroww$$
CREATE DEFINER='root'@'localhost' PROCEDURE buy_etf (IN NoETF INT(10), IN buy_price DECIMAL(7,2), IN buy_tkr VARCHAR(10), IN Custpan CHAR(10))
MODIFIES SQL data
BEGIN
START TRANSACTION;
UPDATE Cust SET Cust.AccBal=Cust.AccBal-buy_price where Cust.PAN=Custpan;
UPDATE ETF SET ETF.AvailShares=ETF.AvailShares-NoETF where ETF.TKR=buy_tkr;
-- Inserting into Cust_ETF
IF (SELECT COUNT(*) FROM Cust_ETF WHERE Cust_ETF.PAN=Custpan AND Cust_ETF.TKR=buy_tkr)>0
	THEN UPDATE Cust_ETF SET Cust_ETF.Avg_Buy_Price=(Cust_ETF.hold_val+buy_price*NoETF)/(Cust_ETF.Num_Shares+NoETF) where Cust_ETF.PAN=Custpan;
	UPDATE Cust_ETF SET Cust_ETF.hold_val = Cust_ETF.hold_val+buy_price*NoETF;
	-- Setting number of shares
	UPDATE Cust_ETF SET Cust_ETF.Num_Shares=Cust_ETF.Num_Shares+NoETF where Cust_ETF.PAN=Custpan;
ELSE
	Insert into Cust_ETF values (buy_tkr,Custpan,NoETF,buy_price,buy_price*NoETF);
END IF;
commit;
END$$
DELIMITER ;

-- call buy_etf (3, 100, "BEN", "ABCDSEFD");

-- next fun

DROP PROCEDURE IF EXISTS sell_share;

DELIMITER $$
USE LiteGroww$$
CREATE DEFINER='root'@'localhost' PROCEDURE sell_share (IN NoShares INT(10), IN sell_price DECIMAL(7,2), IN sell_tkr VARCHAR(10), IN Custpan CHAR(10))
MODIFIES SQL data
BEGIN
START TRANSACTION;
UPDATE Cust SET Cust.AccBal=Cust.AccBal+sell_price where Cust.PAN=Custpan;
UPDATE Stock SET Stock.AvailShares=Stock.AvailShares+NoShares where Stock.TKR=sell_tkr;
-- Deleting from Cust_Stock
-- First case, if all are sold
IF (select Cust_Stock.Num_Shares from Cust_Stock WHERE Cust_Stock.PAN=Custpan AND Cust_Stock.TKR=sell_tkr)=NoShares 
	THEN delete from Cust_Stock WHERE Cust_Stock.PAN=Custpan AND Cust_Stock.TKR=sell_tkr;
ELSE
	UPDATE Cust_Stock SET Cust_Stock.Num_Shares=Cust_Stock.Num_Shares-NoShares WHERE Cust_Stock.PAN=Custpan AND Cust_Stock.TKR=sell_tkr;
	UPDATE Cust_Stock SET Cust_Stock.Hold_Val = Cust_Stock.hold_val-sell_price*NoShares WHERE Cust_Stock.PAN=Custpan AND Cust_Stock.TKR=sell_tkr;
END IF;
commit;
END$$
DELIMITER ;

-- call sell_share (3, 70, "KSB", 'ABCDSEDSe');
-- call sell_share (1, 71, "KSB", 'ABCDSEDSe');

-- next fun

DROP PROCEDURE IF EXISTS sell_etf;

DELIMITER $$
USE LiteGroww$$
CREATE DEFINER='root'@'localhost' PROCEDURE sell_etf (IN NoETF INT(10), IN sell_price DECIMAL(7,2), IN sell_tkr VARCHAR(10), IN Custpan CHAR(10))
MODIFIES SQL data
BEGIN
START TRANSACTION;
UPDATE Cust SET Cust.AccBal=Cust.AccBal+sell_price where Cust.PAN=Custpan;
UPDATE ETF SET ETF.AvailShares=ETF.AvailShares+NoETF where ETF.TKR=sell_tkr;
-- Deleting from Cust_Stock
-- First case if all are sold
IF (Select Cust_ETF.Num_Shares from Cust_ETF WHERE Cust_ETF.PAN=Custpan AND Cust_ETF.TKR=sell_tkr)=NoETF
	THEN delete from Cust_ETF WHERE Cust_ETF.PAN=Custpan AND Cust_ETF.TKR=sell_tkr;
ELSE
	UPDATE Cust_ETF SET Cust_ETF.Num_Shares=Cust_ETF.Num_Shares-NoETF WHERE Cust_ETF.PAN=Custpan AND Cust_ETF.TKR=sell_tkr;
	UPDATE Cust_ETF SET Cust_ETF.Hold_Val = Cust_ETF.hold_val-sell_price*NoETF WHERE Cust_ETF.PAN=Custpan AND Cust_ETF.TKR=sell_tkr;
END IF;
commit;
END$$
DELIMITER ;

-- call sell_etf (2, 75, "BEN", "ABCDSEFD");

-- next fun

DROP PROCEDURE IF EXISTS show_category;

DELIMITER $$
USE LiteGroww$$
CREATE DEFINER='root'@'localhost' PROCEDURE show_category (IN cat_name VARCHAR(20))
READS SQL data
BEGIN
SELECT SName,CurValue,MarketCap,AvailShares from Stock where Stock.category=cat_name;
END$$
DELIMITER ;

-- call show_category ("IT");

-- select * from Cust_ETF;
-- use LiteGroww;
-- select * from Cust_Stock;
