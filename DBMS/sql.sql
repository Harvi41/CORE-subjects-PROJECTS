CREATE DATABASE SpaceStationDB;
USE SpaceStationDB;

SET SQL_SAFE_UPDATES = 0;

-- STORAGE UNIT TABLE
CREATE TABLE StorageUnit (
    StorageUnitID INT PRIMARY KEY AUTO_INCREMENT,
    Capacity FLOAT,
    SupportedResourceType VARCHAR(10)
);
INSERT INTO StorageUnit (Capacity, SupportedResourceType)
VALUES 
(500.0, 'Liquid'),
(300.0, 'Gas'),
(400.0, 'Solid'),
(250.0, 'Liquid'),
(600.0, 'Gas'),
(350.0, 'Solid'),
(450.0, 'Liquid'),
(700.0, 'Gas'),
(200.0, 'Solid'),
(800.0, 'Liquid');

SELECT * FROM StorageUnit;

-- RESOURCE TABLE
CREATE TABLE Resource (
    ResourceID INT PRIMARY KEY,
    Name VARCHAR(50),
    Type VARCHAR(30),
    UnitOfMeasurement VARCHAR(20),
    Recyclable BOOLEAN,
    StorageUnitID INT,
    FOREIGN KEY (StorageUnitID) REFERENCES StorageUnit(StorageUnitID)
        ON DELETE SET NULL
);

INSERT INTO Resource (ResourceID, Name, Type, UnitOfMeasurement, Recyclable, StorageUnitID)
VALUES-
(101, 'Water', 'Liquid', 'Liters', TRUE, 1),
(102, 'Oxygen', 'Gas', 'Cubic Meters', TRUE, 2),
(103, 'Food Rations', 'Solid', 'Kilograms', FALSE, 3),
(104, 'Fuel', 'Liquid', 'Liters', FALSE, 4),
(105, 'Carbon Dioxide', 'Gas', 'Cubic Meters', TRUE, 5),
(106, 'Medical Kit', 'Solid', 'Units', FALSE, 6),
(107, 'Coolant', 'Liquid', 'Liters', TRUE, 7),
(108, 'Hydrogen', 'Gas', 'Cubic Meters', TRUE, 8),
(109, 'Metal Parts', 'Solid', 'Kilograms', TRUE, 9),
(110, 'Waste Water', 'Liquid', 'Liters', TRUE, 10);

SELECT * FROM Resource;

-- Resource level table

CREATE TABLE ResourceLevel (
    LevelID INT PRIMARY KEY AUTO_INCREMENT,
    StorageUnitID INT,
    ResourceID INT,
    CurrentLevel FLOAT,
    MinThreshold FLOAT,
    MaxThreshold FLOAT,
    FOREIGN KEY (StorageUnitID) REFERENCES StorageUnit(StorageUnitID),
    FOREIGN KEY (ResourceID) REFERENCES Resource(ResourceID)
);

INSERT INTO ResourceLevel (StorageUnitID, ResourceID, CurrentLevel, MinThreshold, MaxThreshold)
VALUES
(1, 101, 250, 50, 500),     -- Water
(2, 102, 150, 30, 300),     -- Oxygen
(3, 103, 200, 50, 400),     -- Food Rations
(4, 104, 100, 20, 250),     -- Fuel
(5, 105, 400, 100, 600),    -- Carbon Dioxide
(6, 106, 200, 50, 350),     -- Medical Kit
(7, 107, 225, 50, 450),     -- Coolant
(8, 108, 350, 100, 700),    -- Hydrogen
(9, 109, 100, 50, 200),     -- Metal Parts
(10, 110, 600, 200, 800);   -- Waste Water

SELECT * FROM ResourceLevel;

-- CrewMember

CREATE TABLE RoleInfo (
    Role VARCHAR(50) PRIMARY KEY,
    RoleDescription VARCHAR(255)
);
INSERT INTO RoleInfo (Role, RoleDescription)
VALUES
('Commander', 'Leads the station operations and coordinates crew'),
('Pilot', 'Operates spacecraft and manages docking procedures'),
('Engineer', 'Maintains life support, power, and technical systems'),
('LifeSupportSpecialist', 'Monitors air, water, and environmental systems'),
('Scientist', 'Conducts experiments in microgravity'),
('MedicalOfficer', 'Provides medical care and health monitoring'),
('Biologist', 'Handles biological and plant experiments'),
('Physicist', 'Conducts physics research in microgravity'),
('CommunicationOfficer', 'Manages communication with Earth and satellites'),
('SafetyOfficer', 'Ensures station safety, emergency procedures, and protocols');

Select * from Roleinfo;
CREATE TABLE CrewMember (
    CrewID INT PRIMARY KEY,
    Name VARCHAR(100),
    Role VARCHAR(50),
    AssignedModule VARCHAR(100),
    Status VARCHAR(30),
    FOREIGN KEY (Role) REFERENCES RoleInfo(Role)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);
INSERT INTO CrewMember (CrewID, Name, Role, AssignedModule, Status)
VALUES
(101, 'John Carter', 'Engineer', 'Habitat Module', 'Active'),
(102, 'Sara Blake', 'MedicalOfficer', 'Medical Module', 'Active'),
(103, 'Alan Trent', 'Scientist', 'Lab Module', 'Active'),
(104, 'Maria Lopez', 'Pilot', 'Command Module', 'Active'),
(105, 'David Kim', 'LifeSupportSpecialist', 'Life Support Module', 'Active'),
(106, 'Emma Stone', 'Commander', 'Command Module', 'Active'),
(107, 'Liam Wong', 'Biologist', 'Lab Module', 'Active'),
(108, 'Olivia Brown', 'Physicist', 'Lab Module', 'Active'),
(109, 'Ethan Davis', 'SafetyOfficer', 'Habitat Module', 'Active'),
(110, 'Sophia Lee', 'CommunicationOfficer', 'Comm Module', 'Active');

select * from crewmember;
-- Consumption TABLE

CREATE TABLE ConsumptionLog (
    LogID INT PRIMARY KEY,
    CrewID INT,
    ResourceID INT,
    Quantity FLOAT,
    DateTime DATETIME,
    FOREIGN KEY (CrewID) REFERENCES CrewMember(CrewID),
    FOREIGN KEY (ResourceID) REFERENCES Resource(ResourceID)
);
INSERT INTO ConsumptionLog (LogID, CrewID, ResourceID, Quantity, DateTime)
VALUES
(201, 101, 101, 50, '2025-11-08 08:00:00'),  
(202, 102, 102, 20, '2025-11-08 08:15:00'), 
(203, 103, 103, 5, '2025-11-08 08:30:00'),
(204, 104, 104, 30, '2025-11-08 09:00:00'),  
(205, 105, 105, 10, '2025-11-08 09:15:00'),  
(206, 106, 101, 40, '2025-11-08 09:30:00'),  
(207, 107, 106, 2, '2025-11-08 10:00:00'),   
(208, 108, 107, 15, '2025-11-08 10:30:00'),  
(209, 109, 109, 8, '2025-11-08 11:00:00'),   
(210, 110, 110, 60, '2025-11-08 11:15:00'); 

select * from consumptionlog;
CREATE TABLE ResupplySchedule (
    ResupplyID INT PRIMARY KEY,
    OrderDate DATE,
    ExpectedDeliveryDate DATE,
    ResourceID INT,
    Quantity FLOAT,
    Status VARCHAR(20),
    FOREIGN KEY (ResourceID) REFERENCES Resource(ResourceID)
);
INSERT INTO ResupplySchedule (ResupplyID, OrderDate, ExpectedDeliveryDate, ResourceID, Quantity, Status)
VALUES
(301, '2025-11-01', '2025-11-10', 101, 500, 'Pending'),   
(302, '2025-11-02', '2025-11-12', 102, 300, 'Pending'),   
(303, '2025-11-03', '2025-11-13', 103, 400, 'Pending'),   
(304, '2025-11-04', '2025-11-14', 104, 250, 'Pending'),
(305, '2025-11-05', '2025-11-15', 105, 600, 'Pending'),   
(306, '2025-11-06', '2025-11-16', 106, 350, 'Pending'),   
(307, '2025-11-07', '2025-11-17', 107, 450, 'Pending'),   
(308, '2025-11-08', '2025-11-18', 108, 700, 'Pending'),   
(309, '2025-11-09', '2025-11-19', 109, 200, 'Delivered'),   
(310, '2025-11-10', '2025-11-20', 110, 800, 'Pending');   
select * from Resupplyschedule;

CREATE TABLE MaintenanceTask (
    TaskID INT PRIMARY KEY,
    CrewID INT,
    Description VARCHAR(100),
    ScheduledDate DATE,
    Deadline DATE,
    Status VARCHAR(20),
    FOREIGN KEY (CrewID) REFERENCES CrewMember(CrewID)
);

INSERT INTO MaintenanceTask (TaskID, CrewID, Description, ScheduledDate, Deadline, Status)
VALUES
(401, 101, 'Check life support systems', '2025-11-08', '2025-11-09', 'Pending'),
(402, 105, 'Repair solar panels', '2025-11-08', '2025-11-10', 'Pending'),
(403, 101, 'Inspect power generators', '2025-11-09', '2025-11-10', 'Pending'),
(404, 104, 'Test spacecraft docking system', '2025-11-09', '2025-11-11', 'Completed'),
(405, 102, 'Check medical instruments', '2025-11-08', '2025-11-09', 'Pending'),
(406, 106, 'Review station protocols', '2025-11-10', '2025-11-11', 'Pending'),
(407, 101, 'Calibrate sensors', '2025-11-10', '2025-11-12', 'Pending'),
(408, 105, 'Inspect storage modules', '2025-11-11', '2025-11-12', 'Completed'),
(409, 109, 'Check safety equipment', '2025-11-11', '2025-11-12', 'Pending'),
(410, 107, 'Maintain lab equipment', '2025-11-12', '2025-11-13', 'Pending');
select * from maintenanceTask;

CREATE TABLE MedicalSupply (
    MedicalID INT PRIMARY KEY,
    Name VARCHAR(50),
    Stock INT,
    consumed VARCHAR(100),
    ExpiryDate DATE
);
INSERT INTO MedicalSupply (MedicalID, Name, Stock, consumed, ExpiryDate)
VALUES
(501, 'First Aid Kit', 20, 'Bandages, Antiseptic', '2026-01-01'),
(502, 'Oxygen Mask', 15, 'Emergency use', '2026-02-01'),
(503, 'Painkillers', 50, 'Ibuprofen, Paracetamol', '2025-12-15'),
(504, 'Antibiotics', 30, 'Amoxicillin', '2026-03-01'),
(505, 'Syringes', 100, 'Injection use', '2027-01-01'),
(506, 'Defibrillator', 2, 'Cardiac emergency', '2030-01-01'),
(507, 'Blood Pressure Monitor', 5, 'BP measurement', '2028-01-01'),
(508, 'Thermometer', 10, 'Temperature check', '2027-06-01'),
(509, 'Gloves', 200, 'Protection', '2027-12-01'),
(510, 'Face Masks', 300, 'Protection', '2027-12-01');

select * from medicalsupply;
CREATE TABLE MedicalLog (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    CrewID INT,
    MedicalID INT,
    UsageDetails VARCHAR(100),
    DateTime DATETIME,
    FOREIGN KEY (CrewID) REFERENCES CrewMember(CrewID),
    FOREIGN KEY (MedicalID) REFERENCES MedicalSupply(MedicalID)
);
INSERT INTO MedicalLog (CrewID, MedicalID, UsageDetails, DateTime)
VALUES
(102, 501, 'Applied bandage for minor cut', '2025-11-08 08:30:00'),
(102, 503, 'Took painkiller for headache', '2025-11-08 09:00:00'),
(101, 502, 'Used oxygen mask during exercise', '2025-11-08 10:00:00'),
(103, 504, 'Administered antibiotics', '2025-11-08 11:00:00'),
(105, 505, 'Used syringe for sample injection', '2025-11-08 12:00:00'),
(102, 501, 'Replaced bandage', '2025-11-08 13:00:00'),
(107, 508, 'Measured temperature', '2025-11-08 14:00:00'),
(106, 507, 'Checked blood pressure', '2025-11-08 15:00:00'),
(109, 509, 'Wore gloves for lab safety', '2025-11-08 16:00:00'),
(110, 510, 'Wore face mask during maintenance', '2025-11-08 17:00:00');

select * from medicallog;
CREATE TABLE SystemLog (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    Type VARCHAR(30),
    StatusDetails VARCHAR(200),
    DateTime DATETIME
);
INSERT INTO SystemLog (Type, StatusDetails, DateTime)
VALUES
('LifeSupport', 'Oxygen levels stable', '2025-11-08 08:00:00'),
('Power', 'Solar panels at full output', '2025-11-08 08:15:00'),
('Waste', 'CO2 scrubbers functioning', '2025-11-08 08:30:00'),
('LifeSupport', 'Water recycling normal', '2025-11-08 09:00:00'),
('Power', 'Backup generators online', '2025-11-08 09:15:00'),
('Communication', 'All satellite links active', '2025-11-08 09:30:00'),
('Safety', 'No anomalies detected', '2025-11-08 10:00:00'),
('LifeSupport', 'Temperature stable at 22°C', '2025-11-08 10:30:00'),
('Power', 'Battery levels optimal', '2025-11-08 11:00:00'),
('Waste', 'Solid waste storage at 75% capacity', '2025-11-08 11:30:00');
SELECT * FROM SystemLog;



-- Trigger: Reduce resource level after consumption
DELIMITER //
CREATE TRIGGER trg_after_consumption
AFTER INSERT ON ConsumptionLog
FOR EACH ROW
BEGIN
    -- Decrease current level
    UPDATE ResourceLevel
    SET CurrentLevel = CurrentLevel - NEW.Quantity
    WHERE ResourceID = NEW.ResourceID;

    -- Log if below minimum threshold
    IF (SELECT CurrentLevel FROM ResourceLevel WHERE ResourceID = NEW.ResourceID) <
       (SELECT MinThreshold FROM ResourceLevel WHERE ResourceID = NEW.ResourceID) THEN
        INSERT INTO SystemLog(Type, StatusDetails, DateTime)
        VALUES ('Resource Alert',
                CONCAT('Resource ', NEW.ResourceID, ' below minimum threshold.'),
                NOW());
    END IF;
END;
//
DELIMITER ;

-- Trigger: Increase resource level when resupply delivered
DELIMITER //
CREATE TRIGGER trg_after_resupply_delivery
AFTER UPDATE ON ResupplySchedule
FOR EACH ROW
BEGIN
    IF NEW.Status = 'Delivered' AND OLD.Status != 'Delivered' THEN
        UPDATE ResourceLevel
        SET CurrentLevel = CurrentLevel + NEW.Quantity
        WHERE ResourceID = NEW.ResourceID;

        INSERT INTO SystemLog(Type, StatusDetails, DateTime)
        VALUES ('Resupply',
                CONCAT('Resource ', NEW.ResourceID, ' restocked with ', NEW.Quantity),
                NOW());
    END IF;
END;
//
DELIMITER ;


-- cursor : Cursor 1: Check All Resources and Log Low-Level Alerts
DELIMITER //
CREATE PROCEDURE Check_Resource_Levels()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE r_id INT;
    DECLARE curr_level FLOAT;
    DECLARE min_level FLOAT;
    -- Declare cursor to fetch resource levels
    DECLARE cur CURSOR FOR
        SELECT ResourceID, CurrentLevel, MinThreshold FROM ResourceLevel;
    -- Handle end of cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    resource_loop: LOOP
        FETCH cur INTO r_id, curr_level, min_level;
        IF done THEN
            LEAVE resource_loop;
        END IF;

        IF curr_level < min_level THEN
            INSERT INTO SystemLog(Type, StatusDetails, DateTime)
            VALUES ('Resource Alert',
                    CONCAT('Resource ', r_id, ' below minimum threshold (Current: ',
                           curr_level, ', Min: ', min_level, ').'),
                    NOW());
        END IF;
    END LOOP;

    CLOSE cur;
END;
//
DELIMITER ;

CALL Check_Resource_Levels();

-- cursor : Cursor 2: Check for Expired Medical Supplies

DELIMITER //
CREATE PROCEDURE Check_Expired_Medical_Supplies()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE med_id INT;
    DECLARE med_name VARCHAR(50);
    DECLARE exp_date DATE;

    -- Cursor to fetch all medical supplies
    DECLARE cur CURSOR FOR
        SELECT MedicalID, Name, ExpiryDate FROM MedicalSupply;

    -- Handle end of data
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    check_loop: LOOP
        FETCH cur INTO med_id, med_name, exp_date;
        IF done THEN
            LEAVE check_loop;
        END IF;

        IF exp_date < CURDATE() THEN
            INSERT INTO SystemLog(Type, StatusDetails, DateTime)
            VALUES ('Medical Alert',
                    CONCAT('Medical item "', med_name, '" (ID: ', med_id, ') has expired on ', exp_date),
                    NOW());
        END IF;
    END LOOP;

    CLOSE cur;
END;
//
DELIMITER ;

CALL Check_Expired_Medical_Supplies();


-- function 1 : Check the current level of a given resource and return whether it’s ‘LOW’, ‘NORMAL’, or ‘FULL’ based on thresholds.

DELIMITER //
CREATE FUNCTION GetResourceStatus(resID INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE curr FLOAT;
    DECLARE minT FLOAT;
    DECLARE maxT FLOAT;
    DECLARE status VARCHAR(20);

    SELECT CurrentLevel, MinThreshold, MaxThreshold
    INTO curr, minT, maxT
    FROM ResourceLevel
    WHERE ResourceID = resID;

    IF curr < minT THEN
        SET status = 'LOW';
    ELSEIF curr > maxT THEN
        SET status = 'FULL';
    ELSE
        SET status = 'NORMAL';
    END IF;

    RETURN status;
END;
//
DELIMITER ;
SELECT GetResourceStatus(101) AS Water_Status;

-- function 2 : Check if a medical item is expired and return 'Expired' or 'Valid'.

DELIMITER //
CREATE FUNCTION CheckMedicalExpiry(medID INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE exp DATE;
    DECLARE result VARCHAR(20);

    SELECT ExpiryDate INTO exp FROM MedicalSupply WHERE MedicalID = medID;

    IF exp < CURDATE() THEN
        SET result = 'Expired';
    ELSE
        SET result = 'Valid';
    END IF;

    RETURN result;
END;
//
DELIMITER ;

SELECT Name, CheckMedicalExpiry(MedicalID) AS ExpiryStatus
FROM MedicalSupply;



-- 1
SELECT ResourceID, CurrentLevel, MinThreshold, MaxThreshold
FROM ResourceLevel;

-- 2
SELECT CurrentLevel, MinThreshold
FROM ResourceLevel
WHERE CurrentLevel < MinThreshold;

-- 3
SELECT CrewID, Name, Role, AssignedModule
FROM CrewMember
WHERE Status = 'Active';


-- 4
SELECT cm.Name AS CrewName, SUM(cl.Quantity) AS TotalConsumed
FROM ConsumptionLog cl
JOIN CrewMember cm ON cl.CrewID = cm.CrewID
GROUP BY cm.Name
ORDER BY TotalConsumed DESC;


-- 5
SELECT t.TaskID, cm.Name AS AssignedTo, t.Description, t.Deadline
FROM MaintenanceTask t
JOIN CrewMember cm ON t.CrewID = cm.CrewID
WHERE t.Status = 'Pending'
ORDER BY t.Deadline;

-- 6
SELECT MedicalID, Name, Stock, ExpiryDate
FROM MedicalSupply
WHERE ExpiryDate < CURDATE();


-- 7
SELECT r.Name AS ResourceName, GetResourceStatus(r.ResourceID) AS ResourceStatus
FROM Resource r;


-- 8
SELECT cm.Name AS CrewName, ms.Name AS MedicalItem, ml.UsageDetails, ml.DateTime
FROM MedicalLog ml
JOIN CrewMember cm ON ml.CrewID = cm.CrewID
JOIN MedicalSupply ms ON ml.MedicalID = ms.MedicalID
ORDER BY ml.DateTime DESC;

-- 9
SELECT LogID, Type, StatusDetails, DateTime
FROM SystemLog
WHERE Type = 'Communication' AND StatusDetails LIKE '%Failure%'
ORDER BY DateTime DESC;

-- 10
SELECT Name, Role 
FROM CrewMember 
WHERE Status = 'Active' AND AssignedModule = 'Lab Module';



