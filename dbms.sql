Relational Schema-

Booking (BookID (PK), StartDate, EndDate, Insurance, Day, VehicleID (FK))
Client (LicenseID (PK), FirstName, LastName, DOB, Age, AddressID (FK),Mobile, E-Mail)
Drivers(LicenseID (PK), BookID (pk))
Address (ID (PK), StreetName, Town, City, PostCode)
Vehicle (Name, ID (PK), Seats, Engine, Cost, Type, Transmission, BaseID (FK))
Base (BaseID (PK), AddressID (FK))
Service (Availability, Schedule)
Cost (Price, Discount, BookID (FK))


CREATE TABLE Booking (

ID INT PRIMARY KEY AUTO_INCREMENT,
StartDate DATE NOT NULL,
EndDate DATE NOT NULL,
Insurance BOOLEAN DEFAULT False,
Day TINYINT DEFAULT 1,
VehicleID BIGINT FOREIGN KEY REFERENCES Vehicle(ID)
) ENGINE=INNODB;

CREATE TABLE Client (

LicenseID VARCHAR(20) PRIMARY KEY NOT NULL,
FirstName VARCHAR(20) NOT NULL,
LastName VARCHAR(20) NOT NULL,
DOB DATE NOT NULL,
Age TINYINT CHECK (Age>=25),
AddressID BIGINT FOREIGN KEY REFERENCES Address(ID)
Mobile CHAR(10) UNIQUE,
E-Mail VARCHAR(50) UNIQUE
) ENGINE=INNODB

CREATE TABLE Address (
ID BIGINT PRIMARY KEY AUTO_INCREMENT,
StreetName VARCHAR(50) NOT NULL,
Town VARCHAR(20) NOT NULL,
City VARCHAR(20) NOT NULL,
PostCode VARCHAR(12) NOT NULL
) ENGINE=INNODB

CREATE TABLE Vehicle (
ID BIGINT PRIMARY KEY AUTO_INCREMENT,
Name VARCHAR(50) NOT NULL,
Seats TINYINT DEFAULT 4,
Engine VARCHAR(20) NOT NULL,
Cost TINYINT(100) NOT NULL,
Type VARCHAR(50) NOT NULL,
Transmission VARCHAR(50) DEFAULT 'Automatic' CHECK (Transmission='Automatic' OR Transmission='Manual'),
BaseID TINYINT FOREIGN KEY REFERENCES Base(ID)
) ENGINE=INNODB

CREATE TABLE Base (
ID TINYINT PRIMARY KEY AUTO_INCREMENT,
AddressID BIGINT FOREIGN KEY REFERENCES Address(ID)
) ENGINE=INNODB

CREATE TABLE Cost (
Discount INT,
Price INT,
BookID VARCHAR(50) FOREIGN KEY REFERENCES Booking(ID),
Primary KEY(BookID, Price)
) ENGINE=INNODB

CREATE TABLE Drivers (
LicenseID VARCHAR(20) FOREIGN KEY REFERENCES Client(LicenseID),
BookID VARCHAR(50) FOREIGN KEY REFERENCES Booking(ID),
Primary KEY(BookID, LicenseID)
) ENGINE=INNODB
