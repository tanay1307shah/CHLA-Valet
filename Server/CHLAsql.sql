DROP DATABASE if exists CHLAsql;
CREATE DATABASE CHLAsql;
USE CHLAsql;

CREATE TABLE NewCar(
		carID INTEGER PRIMARY KEY not null auto_increment,
		mobileNumber VARCHAR(255) not null,
        ticketNumber VARCHAR(255) not null,
        plateNumber VARCHAR(255) not null,
        color VARCHAR(255) not null,
        carType VARCHAR(255) not null,
        carMake VARCHAR(255) not null
			);

CREATE TABLE carList(
		carID int NOT NULL,
        FOREIGN KEY (carID) REFERENCES NewCar(carID)
			);
            
CREATE TABLE requests(
		carID int NOT NULL,
        FOREIGN KEY(carID) REFERENCES NewCar(carID)
			);
            
CREATE TABLE patients(
		carID int NOT NULL,
        FOREIGN KEY(carID) REFERENCES NewCar(carID)
			);

CREATE TABLE employees(
		carID int NOT NULL,
        FOREIGN KEY(carID) REFERENCES NewCar(carID)
			);