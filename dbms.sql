Relational Schema-

Employee (ID (PK), BaseID (FK), ManagerID)
Booking (BookID (PK), StartDate, EndDate, Insurance, Day, VehicleID (FK))
Client (LicenseID (PK), FirstName, LastName, DOB, Age, AddressID (FK),Mobile, Email)
Bind (ClientID (FK), Type, Age)
Drivers(LicenseID (PK), BookID (pk))
Address (ID (PK), StreetName, Town, City, PostCode)
Vehicle (Name, ID (PK), Seats, Engine, Cost, Type, Transmission, Availability, BaseID (FK))
Base (BaseID (PK), AddressID (FK))
Cost (Price, Discount, BookID (FK))

CREATE TABLE Address (
  ID BIGINT PRIMARY KEY AUTO_INCREMENT,
  StreetName VARCHAR(50) NOT NULL,
  Town VARCHAR(20) NOT NULL,
  City VARCHAR(20) NOT NULL,
  PostCode VARCHAR(12) NOT NULL
) ENGINE=INNODB;

CREATE TABLE Base (
  ID INT PRIMARY KEY AUTO_INCREMENT,
  AddressID BIGINT,
  FOREIGN KEY (AddressID) REFERENCES Address(ID)
) ENGINE=INNODB;

CREATE TABLE Employee (

  ID INT PRIMARY KEY AUTO_INCREMENT,
  BaseID INT,
  FOREIGN KEY (BaseID) REFERENCES Base(ID),
  ManagerID INT
) ENGINE=INNODB;

CREATE TABLE Vehicle (
  ID BIGINT PRIMARY KEY AUTO_INCREMENT,
  Name VARCHAR(50) NOT NULL,
  Seats TINYINT DEFAULT 4,
  Engine VARCHAR(20) NOT NULL,
  Cost TINYINT(100) NOT NULL,
  Type VARCHAR(50) NOT NULL,
  Availability BOOLEAN,
  Transmission VARCHAR(50) DEFAULT 'Automatic' CHECK (Transmission='Automatic' OR Transmission='Manual'),
  BaseID INT,
  FOREIGN KEY (BaseID) REFERENCES Base(ID)
) ENGINE=INNODB;

CREATE TABLE Booking (

  ID INT PRIMARY KEY AUTO_INCREMENT,
  StartDate DATE NOT NULL,
  EndDate DATE NOT NULL,
  Insurance BOOLEAN DEFAULT False,
  Day TINYINT DEFAULT 1,
  VehicleID BIGINT,
  FOREIGN KEY (VehicleID) REFERENCES Vehicle(ID)
) ENGINE=INNODB;

CREATE TABLE Client (

  LicenseID VARCHAR(20) PRIMARY KEY NOT NULL,
  FirstName VARCHAR(20) NOT NULL,
  LastName VARCHAR(20) NOT NULL,
  DOB DATE NOT NULL,
  Age TINYINT CHECK (Age>=25),
  AddressID BIGINT,
  FOREIGN KEY (AddressID) REFERENCES Address(ID),
  Mobile CHAR(10) UNIQUE,
  Email VARCHAR(50) UNIQUE
) ENGINE=INNODB;

CREATE TABLE Bind (
  ClientID VARCHAR(20),
  PRIMARY KEY (ClientID),
  FOREIGN KEY (ClientID) REFERENCES Client(LicenseID),
  Type VARCHAR(50) ,
  Age TINYINT
) ENGINE=INNODB;

CREATE TABLE Cost (
  Discount INT,
  Price INT,
  BookID INT,
  FOREIGN KEY (BookID) REFERENCES Booking(ID),
  Primary KEY(BookID, Price)
) ENGINE=INNODB;

CREATE TABLE Drivers (
  LicenseID VARCHAR(20),
  BookID INT,
  FOREIGN KEY (LicenseID) REFERENCES Client(LicenseID),
  FOREIGN KEY (BookID) REFERENCES Booking(ID),
  Primary KEY(BookID, LicenseID)
) ENGINE=INNODB;


/*
**Employee**
Employee class is created to allow us to have recursive relation.
A manager supervises an employee, who is also an employee, which
makes up the recursive relation. It has many to one relationship
with base.

**Base**
Base has one to one relationship with Address Entity.

**Vehicle**
Vehicle has its necessary specifications and many to one
relationship with Base entity.

**Booking**
This entity holds booking details from any booking made by a client.
Therefore, it has many to one relationship. There is also an
associated class (Cost) that decides the cost of the booking in the
booking to client relation. It has the references to the vehicle with
many to one relation.

The price and discount columns are calculated using the cost column from the vehicle table and
the days column from the booking table,
Which calculates the cost of booking the vehcle for the required amount of days
but if the client books the vehicle for > 7 days a discount of 20% will be applicable and will be automatically cut from the price.

**Address**
Stores the address of clients and bases, has a one-to-one relationship with client
and base tables.

**Drivers**
This the entity that holds the additional drivers from the booking.
Therefore, it has many to one relationship with the booking.

**Client**
It holds the information of a client. has a one to one relation with address and one to many relation with booking


**Bind**
This class will determine the type of cars that a person can have according
to their age restriction.

Age works around a check function which uses the datediff() function to get the current date with getdate()
and the date given in the DOB column in Client to get the age of the driver.
This in turn allows us to check and apply a constraint stating that if the age of the client is above 25
but below 30 the car types they are allowed to take is restricted whereas if there age is above 30
they can take any car type.
*/
