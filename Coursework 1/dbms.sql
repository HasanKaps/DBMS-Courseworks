/* 
T2- Relational Schema-

Employee (SSN (PK), FirstName, LastName, DOB, BaseID (FK), ManagerSSN)
Booking (BookID (PK), SSN, StartDate, EndDate, Insurance, /Day, VehicleID (FK))
Client (SSN (PK), FirstName, LastName, DOB, /Age, AddressID (FK), Mobile, Email)
Bind (ClientID (FK), VehicleID (FK), Type, Age)
Drivers (SSN (PK), BookID (pk))
Address (ID (PK), StreetName, Town, City, PostCode)
Vehicle (Name, ID (PK), Seats, Engine, Cost, Type, Transmission, Availability, BaseID (FK))
Base (BaseID (PK), AddressID (FK))
Cost (Price, Discount, BookID (FK)) 
*/

/*
T3- MySQL Schema (With Commments)
*/

CREATE TABLE Address (

  ID BIGINT PRIMARY KEY AUTO_INCREMENT,
  StreetName VARCHAR(50) NOT NULL,
  Town VARCHAR(20) NOT NULL,
  City VARCHAR(20) NOT NULL,
  PostCode VARCHAR(12) NOT NULL
) ENGINE=INNODB;

CREATE TABLE Client (

  SSN VARCHAR(20) PRIMARY KEY NOT NULL,
  LicenseID VARCHAR(20) UNIQUE,
  FirstName VARCHAR(20) NOT NULL,
  LastName VARCHAR(20) NOT NULL,
  DOB DATE NOT NULL,
  Age TINYINT CHECK (Age>=25),
  AddressID BIGINT,
  FOREIGN KEY (AddressID) REFERENCES Address(ID),
  Mobile CHAR(10) UNIQUE,
  Email VARCHAR(50) UNIQUE
) ENGINE=INNODB;

CREATE TABLE Base (
  ID INT PRIMARY KEY AUTO_INCREMENT,
  AddressID BIGINT,
  FOREIGN KEY (AddressID) REFERENCES Address(ID)
) ENGINE=INNODB;

CREATE TABLE Employee (

  SSN VARCHAR(20) PRIMARY KEY,
  FirstName VARCHAR(20) NOT NULL,
  LastName VARCHAR(20) NOT NULL,
  DOB DATE NOT NULL,
  BaseID INT,
  FOREIGN KEY (BaseID) REFERENCES Base(ID),
  ManagerSSN VARCHAR(20)
) ENGINE=INNODB;

CREATE TABLE Vehicle (
  ID BIGINT PRIMARY KEY AUTO_INCREMENT,
  Name VARCHAR(50) NOT NULL,
  Seats TINYINT DEFAULT 4,
  Engine VARCHAR(20) NOT NULL,
  Cost TINYINT(100) NOT NULL,
  Type VARCHAR(50) NOT NULL CHECK (Type='SmallTownCar' OR Type='FamilyCar' OR Type='MPV' OR Type='SportsCar' OR Type='Luxury' OR Type='Minivans'),
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
  SSN VARCHAR(20),
  FOREIGN KEY (SSN) REFERENCES Client(SSN),
  FOREIGN KEY (VehicleID) REFERENCES Vehicle(ID)
) ENGINE=INNODB;

CREATE TABLE Bind (
  ClientID VARCHAR(20),
  VehicleID BIGINT,
  FOREIGN KEY (VehicleID) REFERENCES Vehicle(ID),
  PRIMARY KEY (ClientID),
  FOREIGN KEY (ClientID) REFERENCES Client(SSN),
  Type VARCHAR(50),
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
  SSN VARCHAR(20),
  BookID INT,
  FOREIGN KEY (SSN) REFERENCES Client(SSN),
  FOREIGN KEY (BookID) REFERENCES Booking(ID),
  Primary KEY(BookID, SSN)
) ENGINE=INNODB;
/

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
associated class (Cost) that decides the cost of the booking after discount
in the booking to client relation. It has the references to the vehicle with
many to one relation.

The Day attribute is a derived attribute calculated from the StartDate & Enddate attributes
which is calculated with (EndDate - StartDate) 

The price and discount columns are calculated using the cost column from the vehicle table and
the days column from the booking table,
Which calculates the cost of booking the vehcle for the required amount of days
but if the client books the vehicle for > 7 days a discount of 20% will be applicable and 
will be automatically cut from the price.

**Address**
Stores the address of clients and bases, has a one-to-one relationship with client
and base tables.

**Drivers**
This the entity that holds the additional drivers from the booking.
Therefore, it has many to one relationship with the booking.

**Client**
It holds the information of a client. has a one to one relation with address 
and one to many relation with booking


**Bind**
This class will determine the type of cars that a person can have according
to their age restriction.

Age works around a check function which uses the datediff() function to get the current date with getdate()
and the date given in the DOB column in Client to get the age of the driver.
This in turn allows us to check and apply a constraint stating that if the age of the client is above 25
but below 30 the car types they are allowed to take is restricted whereas if there age is above 30
they can take any car type.
*/

/*
T4 Indexes (With Comments)
*/
CREATE INDEX EmployeeID ON Employee(FirstName, LastName, BaseID);
CREATE INDEX BookingDetails ON Booking(SSN, VehicleID, Day);
CREATE INDEX VehicleID ON Vehicle(Name, Type, Availability, Cost);
CREATE INDEX ClientDetails ON Client(FirstName,LastName,Age,Mobile,Email);
CREATE INDEX Address ON Address(StreetName, City, PostCode);

/*
**EmployeeID**
As the company HW Motors has many bases across UK and are a company focused on expanding
the company would have a number of employees with similar first names and last names
an index would be useful on th employee's (FirstName, LastName, BaseID) to make it 
easier to find the employees in the company.

**BookingDetails**
HWMotors as an expanding comnpany would have a lot of Bookings with the same client
so to narrow it down and make it easier to search having an index on (SSN, VehicleID, Day)
would make it easier to find the specific booking

**VehicleID**
Would make it easier to find if a specific vehicle is available and if the vehicle type is 
suited for the client.

**ClientDetails**
Similar to EmployeeID as the company is an expanding company with good aims the company is bound
to have many clients with similar names and DOBs. An index on Client would provide the ability to
search for the details of a client more efficently and faster.

**Address**
Address is an entity which contains the address for all the companies clients and bases as these 
attributes can have a multitude of enteries having an index here could make it easier to 
search or a specific address using(StreetName, City, PostCode).

*/
