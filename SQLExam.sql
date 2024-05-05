USE Barbershop


IF OBJECT_ID('Barbers','Table') IS NULL
BEGIN
	CREATE TABLE Barbers (
		Id int NOT NULL PRIMARY KEY identity(1, 1),
		Name nvarchar(50) NOT NULL CHECK (Name != ' '),
		Surname nvarchar(50) NOT NULL CHECK (Surname != ' '),
		Patronymic nvarchar(50) NOT NULL CHECK (Patronymic != ' '),
		Gender nvarchar(10) NOT NULL CHECK (gender IN ('Male', 'Female')),
		NumberPhone nvarchar(25) NOT NULL,
		Email nvarchar(50) NOT NULL,
		Date date not null CHECK (Date <= getdate()),
		hireDate date NOT NULL CHECK (hireDate <= getdate()),
		Position nvarchar(50) NOT NULL CHECK (Position IN ('Chief Barber', 'Senior Barber', 'Junior Barber'))
	);
END
GO

IF OBJECT_ID('Services','Table') IS NULL
BEGIN
	CREATE TABLE Services (
		Id int NOT NULL PRIMARY KEY identity(1, 1),
		ServiceName nvarchar(50) NOT NULL,
		Price money NOT NULL CHECK (Price >= 0),
		StartTime time NOT NULL CHECK (StartTime >= '10:00' AND StartTime <= '15:00'),
		EndTime time NOT NULL,
		);
END
GO

IF OBJECT_ID('BarberFeedback', 'table') IS NULL
BEGIN
    CREATE TABLE BarberFeedback (
        Id INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
        Barber_id INT NOT NULL,
        Client_id INT NOT NULL,
        Feedback nvarchar(MAX) NOT NULL,
        Rating nvarchar(20) NOT NULL CHECK (rating IN ('Very Poor', 'Poor', 'Fair', 'Good', 'Excellent')),
    );
END
GO


IF OBJECT_ID('Clients', 'table') IS NULL
BEGIN
    CREATE TABLE Clients (
        Id INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
        Name nvarchar(50) NOT NULL CHECK (Name != ' '),
		Surname nvarchar(50) NOT NULL CHECK (Surname != ' '),
		Patronymic nvarchar(50) NOT NULL CHECK (Patronymic != ' '),
		NumberPhone nvarchar(25) NOT NULL,
        Email nvarchar(50) NOT NULL,
    );
END
GO


IF OBJECT_ID('Appointments', 'table') IS NULL
BEGIN
    CREATE TABLE Appointments (
        Id INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
        barber_id INT NOT NULL,
        client_id INT NOT NULL,
        appointmentDate DATE NOT NULL CHECK (appointmentDate >= getdate()),
        appointmentTime TIME NOT NULL CHECK (appointmentTime >= '10:00' AND appointmentTime <= '15:00'),
        service_id INT NOT NULL,
    );
END
GO


IF OBJECT_ID('Visits', 'table') IS NULL
BEGIN
    CREATE TABLE Visits (
        Id INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
        client_id INT NOT NULL,
        barber_id INT NOT NULL,
        service_id INT NOT NULL,
        visitDate DATE NOT NULL CHECK (visitDate >= getdate()),
        total_cost money NOT NULL CHECK (total_cost >= 0),
        feedback_id INT NOT NULL,
    );
END
GO

-- Создаем внешний ключ для связи между таблицами Appointments и Barbers
IF OBJECT_ID('FK_Appointments_Barbers', 'F') IS NULL
BEGIN
    ALTER TABLE Appointments
    ADD CONSTRAINT FK_Appointments_Barbers FOREIGN KEY (barber_id) REFERENCES Barbers(Id);
END

-- Создаем внешний ключ для связи между таблицами Appointments и Clients
IF OBJECT_ID('FK_Appointments_Clients', 'F') IS NULL
BEGIN
    ALTER TABLE Appointments
    ADD CONSTRAINT FK_Appointments_Clients FOREIGN KEY (client_id) REFERENCES Clients(Id);
END

-- Создаем внешний ключ для связи между таблицами Visits и Clients
IF OBJECT_ID('FK_Visits_Clients', 'F') IS NULL
BEGIN
    ALTER TABLE Visits
    ADD CONSTRAINT FK_Visits_Clients FOREIGN KEY (client_id) REFERENCES Clients(Id);
END

-- Создаем внешний ключ для связи между таблицами Visits и Barbers
IF OBJECT_ID('FK_Visits_Barbers', 'F') IS NULL
BEGIN
    ALTER TABLE Visits
    ADD CONSTRAINT FK_Visits_Barbers FOREIGN KEY (barber_id) REFERENCES Barbers(Id);
END

-- Создаем внешний ключ для связи между таблицами Visits и Services
IF OBJECT_ID('FK_Visits_Services', 'F') IS NULL
BEGIN
    ALTER TABLE Visits
    ADD CONSTRAINT FK_Visits_Services FOREIGN KEY (service_id) REFERENCES Services(Id);
END

-- Создаем внешний ключ для связи между таблицами Visits и BarberFeedback
IF OBJECT_ID('FK_Visits_BarberFeedback', 'F') IS NULL
BEGIN
    ALTER TABLE Visits
    ADD CONSTRAINT FK_Visits_BarberFeedback FOREIGN KEY (feedback_id) REFERENCES BarberFeedback(Id);
END


-- Заполнение таблицы Barbers
INSERT INTO Barbers (Name, Surname, Patronymic, Gender, NumberPhone, Email, Date, hireDate, Position)
VALUES 
('Иван', 'Иванов', 'Иванович', 'Male', '123456789', 'ivan@mail.com', '1990-05-15', '2020-05-07', 'Chief Barber'),
('Петр', 'Петров', 'Петрович', 'Male', '987654321', 'petr@mail.com', '1995-07-20', '2021-05-15', 'Senior Barber'),
('Мария', 'Сидорова', 'Петровна', 'Female', '456789123', 'maria@mail.com', '1992-12-10', '2019-05-10', 'Junior Barber'),
('Александр', 'Смирнов', 'Александрович', 'Male', '987654321', 'alex@mail.com', '1985-03-25', '2024-05-04', 'Senior Barber'),
('Елена', 'Кузнецова', 'Ивановна', 'Female', '789456123', 'elena@mail.com', '1998-08-12', '2024-04-21', 'Junior Barber');



-- Заполнение таблицы Services
INSERT INTO Services (ServiceName, Price, StartTime, EndTime)
VALUES 
('Стрижка', 500, '10:00', '11:00'),
('Бритье', 300, '11:00', '12:00'),
('Мужская стрижка и бритье', 700, '14:00', '15:00'),
('Мужская стрижка', 400, '10:00', '10:00'),
('Окрашивание', 600, '11:00', '13:00'),
('Укладка', 300, '11:00', '13:00');

-- Заполнение таблицы Clients
INSERT INTO Clients (Name, Surname, Patronymic, NumberPhone, Email)
VALUES 
('Анна', 'Семенова', 'Ивановна', '987654321', 'anna@mail.com'),
('Дмитрий', 'Козлов', 'Иванович', '123456789', 'dmitry@mail.com'),
('Ольга', 'Петрова', 'Дмитриевна', '456789123', 'olga@mail.com'),
('Михаил', 'Иванов', 'Петрович', '456123789', 'mikhail@mail.com'),
('Екатерина', 'Сидорова', 'Дмитриевна', '654987321', 'ekaterina@mail.com'),
('Владимир', 'Александров', 'Владимирович', '852369741', 'vladimir@mail.com');

-- Заполнение таблицы Appointments
INSERT INTO Appointments (barber_id, client_id, appointmentDate, appointmentTime, service_id)
VALUES 
(2, 3, '2024-05-08', '10:00', 1),
(3, 1, '2024-05-17', '11:00', 2),
(2, 2, '2024-05-12', '14:00', 3),
(1, 4, '2024-05-10', '13:00', 1),
(2, 5, '2024-05-15', '12:00', 2),
(1, 5, '2024-05-18', '15:00', 3);

-- Заполнение таблицы Visits
INSERT INTO Visits (client_id, barber_id, service_id, visitDate, total_cost, feedback_id)
VALUES 
(1, 1, 1, '2024-05-06', 500, 1),
(2, 2, 2, '2024-05-07', 300, 2),
(2, 3, 3, '2024-05-08', 700, 3),
(1, 2, 3, '2025-05-06', 800, 1),
(1, 1, 1, '2026-05-06', 700, 1),
(1, 1, 1, '2027-05-06', 900, 1),
(4, 1, 1, '2024-05-11', 400, 4),
(5, 2, 2, '2024-05-16', 600, 5),
(5, 1, 3, '2024-05-19', 300, 6);

-- Заполнение таблицы BarberFeedback
INSERT INTO BarberFeedback (barber_id, client_id, feedback, rating)
VALUES 
(2, 3, 'Отличный барбер!', 'Excellent'),
(1, 1, 'Хорошая стрижка, но неудобное местоположение.', 'Good'),
(3, 2, 'Очень понравилось! Буду обязательно возвращаться.', 'Excellent'),
(1, 4, 'Отличная работа! Спасибо за качественную стрижку.', 'Excellent'),
(2, 5, 'Понравилось все, кроме цены.', 'Good'),
(1, 5, 'Очень профессионально! Впечатлило качество обслуживания.', 'Excellent');



--PART 1
--1
GO
CREATE PROCEDURE GetBarbersFullName
AS
BEGIN
    SELECT CONCAT(Name, ' ', Surname, ' ', Patronymic) AS FullName
    FROM Barbers;
END;

EXEC GetBarbersFullName
--2
GO
CREATE PROCEDURE GetSeniorBarbersInfo
AS
BEGIN
    SELECT *
    FROM Barbers
    WHERE Position = 'Senior Barber';
END;

EXEC GetSeniorBarbersInfo

--3
GO
CREATE PROCEDURE GetBarbersForTraditionalShave
AS
BEGIN
    SELECT *
    FROM Barbers
    WHERE Id IN (SELECT id FROM Services WHERE ServiceName = 'Бритье');
END;

EXEC GetBarbersForTraditionalShave


--4
GO
CREATE PROCEDURE GetBarbersForService
    @ServiceName NVARCHAR(50)
AS
BEGIN
    SELECT *
    FROM Barbers
    WHERE Id IN (SELECT Id FROM Services WHERE ServiceName = @ServiceName);
END;

EXEC GetBarbersForService 'Мужская стрижка и бритье';


--5
GO
CREATE PROCEDURE GetBarbersWorkMoreThanYears
    @Years INT
AS
BEGIN
    SELECT *
    FROM Barbers
    WHERE DATEDIFF(YEAR, hireDate, GETDATE()) > @Years;
END;

EXEC GetBarbersWorkMoreThanYears 3


--6
GO
CREATE PROCEDURE GetSeniorAndJuniorBarbersCount
AS
BEGIN
    SELECT
        (SELECT COUNT(*) FROM Barbers WHERE Position = 'Senior Barber') AS SeniorBarbersCount,
        (SELECT COUNT(*) FROM Barbers WHERE Position = 'Junior Barber') AS JuniorBarbersCount;
END;

EXEC GetSeniorAndJuniorBarbersCount


--7
GO
CREATE PROCEDURE GetRegularClients
    @VisitCount INT
AS
BEGIN
    SELECT C.*
    FROM Clients C
    INNER JOIN (
        SELECT client_id
        FROM Visits
        GROUP BY client_id
        HAVING COUNT(*) >= @VisitCount
    ) AS RegularClients ON C.Id = RegularClients.client_id;
END;

EXEC GetRegularClients 3

--8
GO
CREATE TRIGGER PreventDeleteChiefBarber
ON Barbers
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM deleted WHERE Position = 'Chief Barber' AND Id NOT IN (SELECT Id FROM Barbers WHERE Position = 'Chief Barber' AND Id != deleted.Id))
    BEGIN
        RAISERROR('Cannot delete the only chief barber', 16, 1);
    END
    ELSE
    BEGIN
        DELETE FROM Barbers WHERE Id IN (SELECT Id FROM deleted);
    END
END;

DELETE FROM Barbers WHERE Position = 'Chief Barber';

--9
GO
CREATE TRIGGER PreventAddUnderageBarber
ON Barbers
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE DATEDIFF(YEAR, Date, GETDATE()) < 21)
    BEGIN
        RAISERROR('Cannot add barber under 21 years old', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

INSERT INTO Barbers (Name, Surname, Patronymic, Gender, NumberPhone, Email, Date, hireDate, Position)
VALUES ('Николай', 'Николаев', 'Николаевич', 'Male', '123456789', 'nikolai@mail.com', '2005-01-01', '2024-05-15', 'Junior Barber');


--PART 2
--1
GO
CREATE FUNCTION LongestWorkingBarber()
RETURNS TABLE
AS
RETURN
(
    SELECT TOP 1 *
    FROM Barbers
    ORDER BY DATEDIFF(day, hireDate, GETDATE()) DESC
);

SELECT * FROM LongestWorkingBarber();

--2
GO
CREATE PROCEDURE MostClientsByDateRange
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT TOP 1 B.*
    FROM Barbers B
    JOIN (
        SELECT barber_id, COUNT(*) AS NumClients
        FROM Appointments
        WHERE appointmentDate BETWEEN @StartDate AND @EndDate
        GROUP BY barber_id
    ) AS A ON B.Id = A.barber_id
    ORDER BY NumClients DESC;
END;

EXEC MostClientsByDateRange @StartDate = '2024-05-01', @EndDate = '2024-06-25';

--3
GO
CREATE FUNCTION MostFrequentClient()
RETURNS TABLE
AS
RETURN
(
    SELECT TOP 1 C.*
    FROM Clients C
    JOIN (
        SELECT client_id, COUNT(*) AS NumVisits
        FROM Visits
        GROUP BY client_id
    ) AS V ON C.Id = V.client_id
    ORDER BY NumVisits DESC
);

SELECT * FROM MostFrequentClient();

--4
GO
CREATE FUNCTION HighestSpendingClient()
RETURNS TABLE
AS
RETURN
(
    SELECT TOP 1 C.*
    FROM Clients C
    JOIN (
        SELECT client_id, SUM(total_cost) AS TotalSpent
        FROM Visits
        GROUP BY client_id
    ) AS V ON C.Id = V.client_id
    ORDER BY TotalSpent DESC
);

SELECT * FROM HighestSpendingClient();

--5
GO
CREATE FUNCTION LongestServiceDuration()
RETURNS TABLE
AS
RETURN
(
    SELECT TOP 1 *
    FROM Services
    ORDER BY DATEDIFF(minute, StartTime, EndTime) DESC
);


SELECT * FROM LongestServiceDuration();


