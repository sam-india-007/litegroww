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


call buy_share (4, 80, "KSB", 'ABCDSEDSe');

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

call buy_etf (3, 100, "BEN", "ABCDSEFD");

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

call sell_share (3, 70, "KSB", 'ABCDSEDSe');
call sell_share (1, 71, "KSB", 'ABCDSEDSe');

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

call sell_etf (2, 75, "BEN", "ABCDSEFD");

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

call show_category ("IT");

-- select * from Cust_ETF;
-- use LiteGroww;
-- select * from Cust_Stock;