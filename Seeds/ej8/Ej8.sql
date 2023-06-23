CREATE DATABASE Ejercicio_8;
GO
USE Ejercicio_8;
GO

CREATE TABLE Persona (
    id INT PRIMARY KEY,
    nombre VARCHAR(255)
);

CREATE TABLE Bar (
    id INT PRIMARY KEY,
    nombre VARCHAR(255)
);

CREATE TABLE Cerveza (
    id INT PRIMARY KEY,
    nombre VARCHAR(255)
);

CREATE TABLE Frecuenta (
    idPersona INT,
    idBar INT,
    FOREIGN KEY (idPersona) REFERENCES Persona(id),
    FOREIGN KEY (idBar) REFERENCES Bar(id)
);

CREATE TABLE Sirve (
    idBar INT,
    idCerveza INT,
    FOREIGN KEY (idBar) REFERENCES Bar(id),
    FOREIGN KEY (idCerveza) REFERENCES Cerveza(id)
);

CREATE TABLE Gusta (
    idPersona INT,
    idCerveza INT,
    FOREIGN KEY (idPersona) REFERENCES Persona(id),
    FOREIGN KEY (idCerveza) REFERENCES Cerveza(id)
);