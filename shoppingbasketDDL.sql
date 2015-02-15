/* SQL file for Shopping Basket problem in HW5, CS174A, Winter 2015, UCSB */
CREATE DATABASE ShoppingBasket;

/*DROP TABLE Purchases;
DROP TABLE Accounts;
DROP TABLE Products;*/
CREATE TABLE Accounts (
    aname CHAR(20),
    encrypted_password CHAR(40),
    PRIMARY KEY (aname)
);

CREATE TABLE Products (
	pid CHAR(20),
    description TEXT,
    price REAL,
    PRIMARY KEY (pid)
);


CREATE TABLE Purchases (
	id CHAR(40),
    pid CHAR(20),
    aname CHAR(20),
    quantity INTEGER,
    purchase_time DATETIME,
    PRIMARY KEY (purchase_time, pid, aname),
    FOREIGN KEY (pid) REFERENCES Products(pid),
    FOREIGN KEY (aname) REFERENCES Accounts(aname)
);
    