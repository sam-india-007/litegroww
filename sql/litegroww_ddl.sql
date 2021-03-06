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
