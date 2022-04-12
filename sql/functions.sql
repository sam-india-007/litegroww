-- FUNCTION FOR BUYING SHARES, it is assumed that buy_price>=current price of given share
DELIMITER $$
CREATE DEFINER='root'@'localhost' PROCEDURE 'buy_share' (IN NoShares INT(10), IN buy_price DECIMAL(7,2), IN buy_tkr VARCHAR(10), IN Custpan CHAR(10))
MODIFIES SQL data
BEGIN
START TRANSACTION
SET Cust.AccBal=Cust.AccBal-buy_price where Cust.PAN=Custpan;
SET Stock.AvailShares=Stock.AvailShares-NoETF where Stock.TKR=buy_tkr;
-- Inserting into Cust_Stock
IF (COUNT(*) FROM Cust_Stock WHERE Cust_Stock.PAN=Custpan AND Cust_Stock.TKR=buy_tkr)>0
	THEN SET Cust_Stock.Avg_Buy_Price=(Cust_Stock.hold_val+buy_price*NoShares)/(Cust_Stock.Num_Shares+NoShares) where Cust_Stock.PAN=Custpan;
	SET Cust_Stock.Hold_Val = Cust_Stock.hold_val+buy_price*NoShares;
	-- Setting number of shares
	SET Cust_Stock.Num_Shares=Cust_Stock.Num_Shares+NoShares where Cust_Stock.PAN=Custpan;
ELSE
	Insert into Cust_Stock values (buy_tkr,Custpan,NoShares,buy_price,buy_price*NoShares);
ENDIF
commit;
END$$
DELIMITER;


-- FUNCTION FOR BUYING ETFs, it is assumed that buy_price>=current price of given ETF
DELIMITER $$
CREATE DEFINER='root'@'localhost' PROCEDURE 'buy_etf' (IN NoETF INT(10), IN buy_price DECIMAL(7,2), IN buy_tkr VARCHAR(10), IN Custpan CHAR(10))
MODIFIES SQL data
BEGIN
START TRANSACTION
SET Cust.AccBal=Cust.AccBal-buy_price where Cust.PAN=Custpan;
SET ETF.AvailShares=ETF.AvailShares-NoETF where ETF.TKR=buy_tkr;
-- Inserting into Cust_ETF
IF (COUNT(*) FROM Cust_ETF WHERE Cust_ETF.PAN=Custpan AND Cust_ETF.TKR=buy_tkr)>0
	THEN SET Cust_ETF.Avg_Buy_Price=(Cust_ETF.hold_val+buy_price*NoETF)/(Cust_ETF.Num_Shares+NoETF) where Cust_ETF.PAN=Custpan;
	SET Cust_ETF.hold_val = Cust_ETF.hold_val+buy_price*NoETF;
	-- Setting number of shares
	SET Cust_ETF.Num_Shares=Cust_ETF.Num_Shares+NoETF where Cust_ETF.PAN=Custpan;
ELSE
	Insert into Cust_ETF values (buy_tkr,Custpan,NoETF,buy_price,buy_price*NoETF);
ENDIF
commit;
END$$
DELIMITER;

-- FUNCTION FOR SELLING SHARES, it is assumed that sell_price<=current price of given share and NoShares<=Num_Shares held for that particular TKR
DELIMITER $$
CREATE DEFINER='root'@'localhost' PROCEDURE 'sell_share' (IN NoShares INT(10), IN sell_price DECIMAL(7,2), IN sell_tkr VARCHAR(10), IN Custpan CHAR(10))
MODIFIES SQL data
BEGIN
START TRANSACTION
SET Cust.AccBal=Cust.AccBal+sell_price where Cust.PAN=Custpan;
SET Stock.AvailShares=Stock.AvailShares+NoShares where Stock.TKR=sell_tkr;
-- Deleting from Cust_Stock
-- First case, if all are sold
IF Cust_Stock.Num_Shares=NoETF WHERE Cust_Stock.PAN=Custpan AND Cust_Stock.TKR=sell_tkr
	THEN delete from Cust_Stock WHERE Cust_Stock.PAN=Custpan AND Cust_Stock.TKR=sell_tkr;
ELSE
	SET Cust_Stock.Num_Shares=Cust_Stock.Num_Shares-NoShares WHERE Cust_Stock.PAN=Custpan AND Cust_Stock.TKR=sell_tkr
	SET Cust_Stock.Hold_Val = Cust_Stock.hold_val-sell_price*NoShares;
ENDIF
commit;
END$$
DELIMITER;

-- FUNCTION FOR SELLING ETFs, it is assumed that sell_price<=current price of given ETF and NoETF<=Num_Shares held for that particular TKR
DELIMITER $$
CREATE DEFINER='root'@'localhost' PROCEDURE 'sell_etf' (IN NoETF INT(10), IN sell_price DECIMAL(7,2), IN sell_tkr VARCHAR(10), IN Custpan CHAR(10))
MODIFIES SQL data
BEGIN
START TRANSACTION
SET Cust.AccBal=Cust.AccBal+sell_price where Cust.PAN=Custpan;
SET ETF.AvailShares=ETF.AvailShares+NoETF where ETF.TKR=buy_tkr;
-- Deleting from Cust_Stock
-- First case if all are sold
IF Cust_ETF.Num_Shares=NoETF WHERE Cust_ETF.PAN=Custpan AND Cust_ETF.TKR=sell_tkr
	THEN delete from Cust_ETF WHERE Cust_ETF.PAN=Custpan AND Cust_ETF.TKR=sell_tkr;
ELSE
	SET Cust_ETF.Num_Shares=Cust_ETF.Num_Shares-NoETF WHERE Cust_ETF.PAN=Custpan AND Cust_ETF.TKR=sell_tkr
	SET Cust_ETF.Hold_Val = Cust_ETF.hold_val-sell_price*NoETF;
ENDIF
commit;
END$$
DELIMITER;


DELIMITER $$
CREATE DEFINER='root'@'localhost' PROCEDURE 'show_category' (IN cat_name VARCHAR(20))
READS SQL data
BEGIN
SELECT Name,CurValue,MarketCap,AvailShares from Stock where Stock.category=cat_name;
END$$
DELIMITER;