ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY';

-- Drop tables --
DROP TABLE adoption CASCADE CONSTRAINTS;
DROP TABLE treatment CASCADE CONSTRAINTS;
DROP TABLE health_check CASCADE CONSTRAINTS;
DROP TABLE donation CASCADE CONSTRAINTS;
DROP TABLE vet_shift CASCADE CONSTRAINTS;
DROP TABLE personnel_shift CASCADE CONSTRAINTS;
DROP TABLE duty CASCADE CONSTRAINTS;
DROP TABLE task CASCADE CONSTRAINTS;
DROP TABLE transaction CASCADE CONSTRAINTS;
DROP TABLE animal CASCADE CONSTRAINTS;
DROP TABLE personnel CASCADE CONSTRAINTS;
DROP TABLE veterinarian CASCADE CONSTRAINTS;
DROP TABLE donor CASCADE CONSTRAINTS;
DROP TABLE adopter CASCADE CONSTRAINTS;

-- Creation of tables --
-- Adopter table
CREATE TABLE adopter(
    AdopterID VARCHAR2(6) PRIMARY KEY,
    Adopter_Name VARCHAR2(100) NOT NULL,
    Adopter_IC_No VARCHAR2(14) UNIQUE NOT NULL CONSTRAINT chk_adt_ic CHECK (REGEXP_LIKE(Adopter_IC_No, '^\d{6}-\d{2}-\d{4}$')),
    Adopter_ContactNumber VARCHAR2(15) NOT NULL CONSTRAINT chk_adt_contact CHECK (REGEXP_LIKE(Adopter_ContactNumber, '^(\+?60)?1[0-9]{8,9}$')),
    Adopter_EmailAddress VARCHAR2(100) CONSTRAINT chk_adt_email CHECK (REGEXP_LIKE(Adopter_EmailAddress, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')),
    Registration_Date DATE NOT NULL
);

-- Donor table
CREATE TABLE donor(
    DonorID VARCHAR2(6) PRIMARY KEY,
    Donor_Name VARCHAR2(100) NOT NULL,
    Donor_ContactNumber VARCHAR2(15) NOT NULL CONSTRAINT chk_donor_contact CHECK (REGEXP_LIKE(Donor_ContactNumber, '^(\+?60)?(1[0-9]{8,9}|[3-9][0-9]{7,8})$')),
    Donor_EmailAddress VARCHAR2(100) CONSTRAINT chk_donor_email CHECK (REGEXP_LIKE(Donor_EmailAddress, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')),
    Donor_Type VARCHAR2(30) CONSTRAINT chk_donor_type CHECK (Donor_Type IN ('Individual', 'Community', 'Organization'))
);

-- Veterinarian table
CREATE TABLE veterinarian(
    VetID VARCHAR2(6) PRIMARY KEY,
    Vet_Name VARCHAR2(100) NOT NULL,
    Vet_IC_No VARCHAR2(14) UNIQUE NOT NULL CONSTRAINT chk_vet_ic CHECK (REGEXP_LIKE(Vet_IC_No, '^\d{6}-\d{2}-\d{4}$')),
    Vet_Gender VARCHAR2(1) NOT NULL CONSTRAINT chk_vet_gender CHECK (Vet_Gender IN ('M', 'F')),
    Vet_CentreName VARCHAR2(100),
    Vet_ContactNumber VARCHAR2(15) NOT NULL CONSTRAINT chk_vet_contact CHECK (REGEXP_LIKE(Vet_ContactNumber, '^(\+?60)?1[0-9]{8,9}$')),
    Vet_EmailAddress VARCHAR2(100) CONSTRAINT chk_vet_email CHECK (REGEXP_LIKE(Vet_EmailAddress, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')),
    Specialty VARCHAR2(50) NOT NULL,
    Hiring_Date DATE NOT NULL
);

-- Personnel table
CREATE TABLE personnel(
    PersonnelID VARCHAR2(6) PRIMARY KEY,
    Personnel_Name VARCHAR2(100) NOT NULL,
    Personnel_IC_No VARCHAR2(14) UNIQUE NOT NULL CONSTRAINT chk_person_ic CHECK (REGEXP_LIKE(Personnel_IC_No, '^\d{6}-\d{2}-\d{4}$')),
    Personnel_Age NUMERIC(2) NOT NULL CONSTRAINT chk_person_age CHECK (Personnel_Age BETWEEN 15 AND 65),
    Personnel_Gender VARCHAR2(1) NOT NULL CONSTRAINT chk_person_gender CHECK (Personnel_Gender IN ('M', 'F')),
    Personnel_ContactNumber VARCHAR2(15) NOT NULL CONSTRAINT chk_person_contact CHECK (REGEXP_LIKE(Personnel_ContactNumber, '^(\+?60)?1[0-9]{8,9}$')),
    Personnel_EmailAddress VARCHAR2(100) CONSTRAINT chk_person_email CHECK (REGEXP_LIKE(Personnel_EmailAddress, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')),
    Personnel_Role VARCHAR2(50) NOT NULL,
    Hiring_Date DATE NOT NULL
);

-- Animal table
CREATE TABLE animal(
    AnimalID VARCHAR2(6) PRIMARY KEY,
    Animal_Name VARCHAR2(50) NOT NULL,
    Species VARCHAR2(30) NOT NULL,
    Breed VARCHAR2(50),
    Life_Stage VARCHAR2(30) NOT NULL,
    Gender VARCHAR2(1) NOT NULL CONSTRAINT chk_animal_gender CHECK (Gender IN ('M', 'F')),
    Age NUMERIC(2) CONSTRAINT chk_animal_age CHECK (Age BETWEEN 0 AND 30),
    Intake_Date DATE NOT NULL,
    Intake_Status VARCHAR2(50) NOT NULL CONSTRAINT chk_intake_status CHECK (Intake_Status IN ('Under Treatment', 'Available for Adoption', 'Deceased'))
);

-- Transaction table
CREATE TABLE transaction(
    TransactionID VARCHAR2(6) PRIMARY KEY,
    Amount NUMERIC(6,2) NOT NULL,
    Transaction_Method VARCHAR2(100) NOT NULL
);

-- Task table
CREATE TABLE task(
    TaskID VARCHAR2(6) PRIMARY KEY,
    Task_Description VARCHAR2(200) NOT NULL,
    Task_Type VARCHAR2(100) NOT NULL
);

-- Duty table
CREATE TABLE duty(
    TaskID VARCHAR2(6),
    AnimalID VARCHAR2(6),
    PersonnelID VARCHAR2(6),
    Scheduled_Date DATE NOT NULL,
    Scheduled_Time VARCHAR2(5) NOT NULL,
    Duty_Status VARCHAR2(30) NOT NULL CONSTRAINT chk_duty_status CHECK (Duty_Status IN ('Pending', 'Completed', 'Missed')),
    PRIMARY KEY (TaskID, AnimalID),
    FOREIGN KEY (TaskID) REFERENCES task(TaskID),
    FOREIGN KEY (AnimalID) REFERENCES animal(AnimalID),
    FOREIGN KEY (PersonnelID) REFERENCES personnel(PersonnelID)
);

-- Personnel_shift table
CREATE TABLE personnel_shift(
    PersonnelID VARCHAR2(6),
    Shift_Day VARCHAR2(3) NOT NULL CONSTRAINT chk_person_shift CHECK (Shift_Day IN ('Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun')),
    Shift_Start VARCHAR2(5) NOT NULL,
    Shift_End VARCHAR2(5) NOT NULL,
    PRIMARY KEY (PersonnelID, Shift_Day),
    FOREIGN KEY (PersonnelID) REFERENCES personnel(PersonnelID)
);

-- Vet_shift table
CREATE TABLE vet_shift(
    VetID VARCHAR2(6),
    Shift_Day VARCHAR2(3) NOT NULL CONSTRAINT chk_vet_shift CHECK (Shift_Day IN ('Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun')),
    Shift_Start VARCHAR2(5) NOT NULL,
    Shift_End VARCHAR2(5) NOT NULL,
    PRIMARY KEY (VetID, Shift_Day),
    FOREIGN KEY (VetID) REFERENCES veterinarian(VetID)
);

-- Donation table
CREATE TABLE donation(
    AnimalID VARCHAR2(6),
    DonorID VARCHAR2(6),
    PersonnelID VARCHAR2(6),
    Donation_Type VARCHAR2(50) NOT NULL,
    Donation_Description VARCHAR2(100),
    Donation_Date DATE NOT NULL,
    PRIMARY KEY (AnimalID, DonorID),
    FOREIGN KEY (AnimalID) REFERENCES animal(AnimalID),
    FOREIGN KEY (DonorID) REFERENCES donor(DonorID),
    FOREIGN KEY (PersonnelID) REFERENCES personnel(PersonnelID)
);

-- Health Check table
CREATE TABLE health_check(
    AnimalID VARCHAR2(6),
    VetID VARCHAR2(6),
    Check_Date DATE NOT NULL,
    Weight NUMERIC(5,2) NOT NULL CONSTRAINT chk_animal_weight CHECK (Weight >= 0),
    Temperature NUMERIC(4,1) NOT NULL,
    Health_Rating NUMERIC(1) NOT NULL CONSTRAINT chk_animal_health CHECK (Health_Rating BETWEEN 1 AND 5),
    PRIMARY KEY (AnimalID, VetID, Check_Date),
    FOREIGN KEY (AnimalID) REFERENCES animal(AnimalID),
    FOREIGN KEY (VetID) REFERENCES veterinarian(VetID)
);

-- Treatment table
CREATE TABLE treatment(
    AnimalID VARCHAR2(6),
    VetID VARCHAR2(6),
    Treatment_Date DATE NOT NULL,
    Treatment_Type VARCHAR2(100),
    PRIMARY KEY (AnimalID, VetID, Treatment_Date),
    FOREIGN KEY (AnimalID) REFERENCES animal(AnimalID),
    FOREIGN KEY (VetID) REFERENCES veterinarian(VetID)
);

-- Adoption table
CREATE TABLE adoption(
    AnimalID VARCHAR2(6),
    AdopterID VARCHAR2(6),
    PersonnelID VARCHAR2(6),
    Adoption_Date DATE NOT NULL,
    TransactionID VARCHAR2(6),
    PRIMARY KEY (AnimalID, AdopterID),
    FOREIGN KEY (AnimalID) REFERENCES animal(AnimalID),
    FOREIGN KEY (AdopterID) REFERENCES adopter(AdopterID),
    FOREIGN KEY (PersonnelID) REFERENCES personnel(PersonnelID),
    FOREIGN KEY (TransactionID) REFERENCES transaction(TransactionID)
);

-- Insertion of data into tables --
-- Insert data into Adopter table
INSERT INTO adopter VALUES ('ADT001', 'Yi Xin Lim', '010915-14-5768', '+60123456789', 'y1xin@gmail.com', TO_DATE('2023-01-15', 'YYYY-MM-DD'));
INSERT INTO adopter VALUES ('ADT002', 'Aisyah Hassan', '990312-10-4567', '+601112345678', 'aisyah.hassan@email.com', TO_DATE('2023-02-20', 'YYYY-MM-DD'));
INSERT INTO adopter VALUES ('ADT003', 'Daniel Wong', '870824-08-9981', '+60134567890', 'daniel.wong@gmail.com', TO_DATE('2023-05-14', 'YYYY-MM-DD'));
INSERT INTO adopter VALUES ('ADT004', 'Chloe Tan', '950630-07-3344', '+60175678901', 'chloe.tan@email.com', TO_DATE('2023-08-05', 'YYYY-MM-DD'));
INSERT INTO adopter VALUES ('ADT005', 'Arjun Kumar', '930412-04-1122', '+60123456789', 'arjun.kumar@gmail.com', TO_DATE('2023-11-27', 'YYYY-MM-DD'));
INSERT INTO adopter VALUES ('ADT006', 'Siti Nurhaliza', '800215-03-6789', '+60199887766', 'siti.nur@email.com', TO_DATE('2024-01-10', 'YYYY-MM-DD'));
INSERT INTO adopter VALUES ('ADT007', 'Jonathan Lee', '920101-05-4567', '+60136784521', 'jonathan.lee@gmail.com', TO_DATE('2024-04-22', 'YYYY-MM-DD'));
INSERT INTO adopter VALUES ('ADT008', 'Tan Mei Mei', '881230-06-1234', '+60182233445', 'mei.tan88@email.com', TO_DATE('2024-07-13', 'YYYY-MM-DD'));
INSERT INTO adopter VALUES ('ADT009', 'Muhammad Faiz', '960529-11-7788', '+60191234456', 'faiz.muhammad@gmail.com', TO_DATE('2025-01-06', 'YYYY-MM-DD'));
INSERT INTO adopter VALUES ('ADT010', 'Lim Jia Wei', '891114-09-2345', '+60122334455', 'jiawei.lim@email.com', TO_DATE('2025-02-18', 'YYYY-MM-DD'));

--Insert data into Donor table 
INSERT INTO donor VALUES ('D001', 'Alice Tan', '+60123456789', 'alice.t@gmail.com', 'Individual');
INSERT INTO donor VALUES ('D002', 'Bob Lee', '+60198765432', 'bob.lee@yahoo.com', 'Individual');
INSERT INTO donor VALUES ('D003', 'Chandra Devi', '+60131234567', 'chandra.d@gmail.com', 'Individual');
INSERT INTO donor VALUES ('D004', 'Daniel Wong', '+60176543210', 'daniel.w@gmail.com', 'Community');
INSERT INTO donor VALUES ('D005', 'Emily Lim', '+60398765432', 'emily.l@gmail.com', 'Individual');
INSERT INTO donor VALUES ('D006', 'Faris bin Adam', '+601122334455', 'faris.a@yahoo.com', 'Organization');
INSERT INTO donor VALUES ('D007', 'Grace Anne', '+60167890123', 'grace.a@gmail.com', 'Individual');
INSERT INTO donor VALUES ('D008', 'Harith Kumar', '+60456789012', 'harith.k@gmail.com', 'Organization');
INSERT INTO donor VALUES ('D009', 'Ivy Chan', '+60189988776', 'ivy.c@gmail.com', 'Individual');
INSERT INTO donor VALUES ('D010', 'Johan M. Said', '+60101001000', 'johan.s@yahoo.com', 'Community');

-- Insert data into Veterinarian table
INSERT INTO veterinarian VALUES ('V001', 'Lim Mei Ling', '900101-14-5678', 'F', 'PetCare Centre KL', '+60123456789', 'lim.meiling@gmail.com', 'Small Animal Medicine', TO_DATE('2023-01-15', 'YYYY-MM-DD'));
INSERT INTO veterinarian VALUES ('V002', 'Ahmad Rizal', '850412-10-2345', 'M', 'Shah Alam Animal Clinic', '+60112345678', 'ahmad.rizal@yahoo.com', 'Dermatology', TO_DATE('2023-02-10', 'YYYY-MM-DD'));
INSERT INTO veterinarian VALUES ('V003', 'Siti Nurhaliza', '920718-08-9876', 'F', 'Gombak Vet Centre', '+60132223344', 'siti.nurhaliza@gmail.com', 'Parasitology', TO_DATE('2023-03-20', 'YYYY-MM-DD'));
INSERT INTO veterinarian VALUES ('V004', 'John Tan', '870321-13-1111', 'M', 'Subang Jaya Vet Clinic', '+60134455666', 'john.tan@yahoo.com', 'Surgery', TO_DATE('2023-04-05', 'YYYY-MM-DD'));
INSERT INTO veterinarian VALUES ('V005', 'Alicia Wong', '931210-12-5678', 'F', 'Pet Wellness PJ', '+60199887766', 'alicia.wong@gmail.com', 'Small Animal Medicine', TO_DATE('2023-05-08', 'YYYY-MM-DD'));
INSERT INTO veterinarian VALUES ('V006', 'Faizal Ramli', '890605-01-1234', 'M', 'Ampang Veterinary Centre', '+60124567890', 'faizal.ramli@yahoo.com', 'Dermatology', TO_DATE('2023-06-18', 'YYYY-MM-DD'));
INSERT INTO veterinarian VALUES ('V007', 'Chong Wei Lin', '910812-06-6543', 'F', 'Cheras Happy Pets', '+60187654321', 'chong.weilin@gmail.com', 'Parasitology', TO_DATE('2023-07-22', 'YYYY-MM-DD'));
INSERT INTO veterinarian VALUES ('V008', 'Michael Lee', '880101-07-8888', 'M', 'KL Animal Hospital', '+60123334455', 'michael.lee@yahoo.com', 'Surgery', TO_DATE('2023-08-30', 'YYYY-MM-DD'));
INSERT INTO veterinarian VALUES ('V009', 'Nur Aina', '950912-03-1112', 'F', 'Setia Alam Vet Clinic', '+60191234567', 'nur.aina@gmail.com', 'Small Animal Medicine', TO_DATE('2023-09-12', 'YYYY-MM-DD'));
INSERT INTO veterinarian VALUES ('V010', 'Kevin Ng', '870404-05-2223', 'M', 'Damansara Pet Care', '+60143332211', 'kevin.ng@yahoo.com', 'Dermatology', TO_DATE('2023-10-11', 'YYYY-MM-DD'));
INSERT INTO veterinarian VALUES ('V011', 'Tan Hui Yee', '930530-13-3334', 'F', 'Puchong Animal Clinic', '+60187776655', 'tan.huiyee@gmail.com', 'Parasitology', TO_DATE('2023-11-25', 'YYYY-MM-DD'));
INSERT INTO veterinarian VALUES ('V012', 'Daniel Wong', '860718-02-4445', 'M', 'Bangsar Vet Centre', '+60186665544', 'daniel.wong@yahoo.com', 'Surgery', TO_DATE('2023-12-03', 'YYYY-MM-DD'));
INSERT INTO veterinarian VALUES ('V013', 'Yusri Hamdan', '840909-11-1122', 'M', 'Kajang EcoVet', '+60134445566', 'yusri.hamdan@gmail.com', 'Small Animal Medicine', TO_DATE('2023-12-15', 'YYYY-MM-DD'));
INSERT INTO veterinarian VALUES ('V014', 'Chin Mei Yee', '920220-09-2233', 'F', 'Serdang Paws & Claws', '+60197776655', 'chin.meiyee@yahoo.com', 'Dermatology', TO_DATE('2023-12-20', 'YYYY-MM-DD'));
INSERT INTO veterinarian VALUES ('V015', 'Hafiz Anuar', '900715-01-3344', 'M', 'Cyberjaya PetMed', '+60161112233', 'hafiz.anuar@gmail.com', 'Parasitology', TO_DATE('2023-12-28', 'YYYY-MM-DD'));

--Insert data into Personnel table 
INSERT INTO personnel VALUES ('P001', 'Nurul Huda binti Ali', '900101-14-1234', 35, 'F', '+60123456789', 'nurul.huda@gmail.com', 'Adoption Administrator', TO_DATE('2023-01-20', 'YYYY-MM-DD'));
INSERT INTO personnel VALUES ('P002', 'Priya Devi', '911120-08-9012', 33, 'F', '+60191234567', 'priya.d@gmail.com', 'Adoption Administrator', TO_DATE('2023-01-05', 'YYYY-MM-DD'));
INSERT INTO personnel VALUES ('P003', 'Ahmad Faizal bin Razali', '800303-01-2345', 45, 'M', '+60176543210', 'ahmad.f@yahoo.com', 'Adoption Administrator', TO_DATE('2023-03-01', 'YYYY-MM-DD'));
INSERT INTO personnel VALUES ('P004', 'Lim Siew Yen', '780707-14-6789', 47, 'F', '+60169876543', 'siew.yen.l@gmail.com', 'Manager', TO_DATE('2023-04-05', 'YYYY-MM-DD'));
INSERT INTO personnel VALUES ('P005', 'Muthu Krishnan', '820925-05-0123', 42, 'M', '+60112345678', 'muthu.k@yahoo.com', 'Receptionist', TO_DATE('2023-05-10', 'YYYY-MM-DD'));
INSERT INTO personnel VALUES ('P006', 'Siti Aisyah binti Omar', '950210-03-4567', 30, 'F', '+60135556677', 'siti.aisyah@gmail.com', 'Receptionist', TO_DATE('2023-07-01', 'YYYY-MM-DD'));
INSERT INTO personnel VALUES ('P007', 'Hafizuddin bin Kassim', '870818-01-9876', 38, 'M', '+60121112233', 'hafiz.k@gmail.com', 'Volunteer Supervisor', TO_DATE('2023-08-01', 'YYYY-MM-DD'));
INSERT INTO personnel VALUES ('P008', 'Amira binti Zulkifli', '000101-10-1000', 25, 'F', '+60111234567', 'amira.z@gmail.com', 'Volunteer', TO_DATE('2023-03-20', 'YYYY-MM-DD'));
INSERT INTO personnel VALUES ('P009', 'Bryan Lee', '010303-07-2000', 24, 'M', '+60132109876', 'bryan.l@yahoo.com', 'Volunteer', TO_DATE('2023-08-15', 'YYYY-MM-DD'));
INSERT INTO personnel VALUES ('P010', 'Chitra Subramaniam', '990505-08-3000', 26, 'F', '+60178765432', 'chitra.s@gmail.com', 'Volunteer', TO_DATE('2023-12-05', 'YYYY-MM-DD'));
INSERT INTO personnel VALUES ('P011', 'Kamal bin Daud', '980202-01-1111', 27, 'M', '+60129876543', 'kamal.d@gmail.com', 'Animal Care', TO_DATE('2023-04-10', 'YYYY-MM-DD'));
INSERT INTO personnel VALUES ('P012', 'Lina Abdullah', '970404-10-2222', 28, 'F', '+60134567890', 'lina.a@yahoo.com', 'Animal Care', TO_DATE('2023-06-25', 'YYYY-MM-DD'));
INSERT INTO personnel VALUES ('P013', 'Chong Kah Seng', '940628-07-8901', 31, 'M', '+60187778899', 'kah.seng.c@yahoo.com', 'Receptionist', TO_DATE('2024-02-14', 'YYYY-MM-DD'));
INSERT INTO personnel VALUES ('P014', 'Daniel Lim', '020707-14-4000', 23, 'M', '+60161234567', 'daniel.l@yahoo.com', 'Volunteer', TO_DATE('2024-02-10', 'YYYY-MM-DD'));
INSERT INTO personnel VALUES ('P015', 'Evelyn Tan', '030909-10-5000', 22, 'F', '+60199876543', 'evelyn.t@gmail.com', 'Volunteer', TO_DATE('2024-05-01', 'YYYY-MM-DD'));
INSERT INTO personnel VALUES ('P016', 'Fahmi bin Hassan', '041111-01-6000', 21, 'M', '+60125678901', 'fahmi.h@yahoo.com', 'Volunteer', TO_DATE('2024-07-25', 'YYYY-MM-DD'));
INSERT INTO personnel VALUES ('P017', 'Mark Cheng', '990606-07-3333', 26, 'M', '+60171234567', 'mark.c@gmail.com', 'Animal Care', TO_DATE('2024-09-12', 'YYYY-MM-DD'));
INSERT INTO personnel VALUES ('P018', 'Nadia binti Idris', '000808-03-4444', 25, 'F', '+60168765432', 'nadia.i@yahoo.com', 'Animal Care', TO_DATE('2025-01-01', 'YYYY-MM-DD'));
INSERT INTO personnel VALUES ('P019', 'Jason Lee', '080719-07-0000', 17, 'M', '+60167778899', 'jason.l@yahoo.com', 'Volunteer', TO_DATE('2025-07-01', 'YYYY-MM-DD'));

-- Insert data into Animal table
INSERT INTO animal VALUES ('A001', 'Max', 'Dog', 'Golden Retriever', 'Adult', 'M', 6, TO_DATE('2025-01-15', 'YYYY-MM-DD'), 'Available for Adoption');
INSERT INTO animal VALUES ('A002', 'Whiskers', 'Cat', 'Siamese', 'Kitten', 'F', 1, TO_DATE('2023-01-20', 'YYYY-MM-DD'), 'Available for Adoption');
INSERT INTO animal VALUES ('A003', 'Buddy', 'Dog', 'Mongrel', 'Senior', 'M', 9, TO_DATE('2023-02-10', 'YYYY-MM-DD'), 'Under Treatment');
INSERT INTO animal VALUES ('A004', 'Luna', 'Cat', 'American Shorthair', 'Adult', 'F', 8, TO_DATE('2025-02-20', 'YYYY-MM-DD'), 'Available for Adoption');
INSERT INTO animal VALUES ('A005', 'Rocky', 'Dog', 'Golden Retriever', 'Puppy', 'M', 1, TO_DATE('2023-04-05', 'YYYY-MM-DD'), 'Deceased');
INSERT INTO animal VALUES ('A006', 'Mittens', 'Cat', 'Bengal', 'Senior', 'F', 10, TO_DATE('2023-05-12', 'YYYY-MM-DD'), 'Under Treatment');
INSERT INTO animal VALUES ('A007', 'Charlie', 'Dog', 'Shih Tzu', 'Adult', 'M', 4, TO_DATE('2025-03-10', 'YYYY-MM-DD'), 'Available for Adoption');
INSERT INTO animal VALUES ('A008', 'Bella', 'Cat', 'Siamese', 'Adult', 'F', 9, TO_DATE('2023-07-22', 'YYYY-MM-DD'), 'Available for Adoption');
INSERT INTO animal VALUES ('A009', 'Simba', 'Dog', 'Telomian', 'Puppy', 'M', 1, TO_DATE('2023-08-25', 'YYYY-MM-DD'), 'Under Treatment');
INSERT INTO animal VALUES ('A010', 'Daisy', 'Cat', 'American Shorthair', 'Kitten', 'F', 0, TO_DATE('2025-04-01', 'YYYY-MM-DD'), 'Available for Adoption');
INSERT INTO animal VALUES ('A011', 'Sylus', 'Dog', 'Mongrel', 'Senior', 'M', 12, TO_DATE('2023-10-11', 'YYYY-MM-DD'), 'Available for Adoption');
INSERT INTO animal VALUES ('A012', 'Smokey', 'Cat', 'Bengal', 'Senior', 'M', 11, TO_DATE('2023-11-25', 'YYYY-MM-DD'), 'Under Treatment');
INSERT INTO animal VALUES ('A013', 'Cooper', 'Dog', 'Poodle', 'Puppy', 'M', 1, TO_DATE('2024-01-08', 'YYYY-MM-DD'), 'Available for Adoption');
INSERT INTO animal VALUES ('A014', 'Sophie', 'Cat', 'Siamese', 'Adult', 'F', 8, TO_DATE('2024-02-14', 'YYYY-MM-DD'), 'Under Treatment');
INSERT INTO animal VALUES ('A015', 'Bear', 'Dog', 'Golden Retriever', 'Senior', 'M', 9, TO_DATE('2024-03-20', 'YYYY-MM-DD'), 'Deceased');
INSERT INTO animal VALUES ('A016', 'Ginger', 'Cat', 'American Shorthair', 'Adult', 'F', 4, TO_DATE('2025-05-15', 'YYYY-MM-DD'), 'Available for Adoption');
INSERT INTO animal VALUES ('A017', 'Harry', 'Dog', 'Mongrel', 'Senior', 'M', 9, TO_DATE('2024-05-05', 'YYYY-MM-DD'), 'Available for Adoption');
INSERT INTO animal VALUES ('A018', 'Willow', 'Cat', 'Siamese', 'Kitten', 'F', 0, TO_DATE('2025-06-05', 'YYYY-MM-DD'), 'Available for Adoption');
INSERT INTO animal VALUES ('A019', 'Duke', 'Dog', 'Shih Tzu', 'Senior', 'M', 8, TO_DATE('2024-07-15', 'YYYY-MM-DD'), 'Under Treatment');
INSERT INTO animal VALUES ('A020', 'Cleo', 'Cat', 'Bengal', 'Adult', 'F', 8, TO_DATE('2024-08-20', 'YYYY-MM-DD'), 'Available for Adoption');

--Insert data into Transaction table 
INSERT INTO transaction VALUES ('TS001', 38.07, 'Google Pay');
INSERT INTO transaction VALUES ('TS002', 36.36, 'E-Wallet');
INSERT INTO transaction VALUES ('TS003', 36.02, 'Apple Pay');
INSERT INTO transaction VALUES ('TS004', 31.53, 'E-Wallet');
INSERT INTO transaction VALUES ('TS005', 48.11, 'Cash');
INSERT INTO transaction VALUES ('TS006', 44.15, 'Visa Pay');
INSERT INTO transaction VALUES ('TS007', 34.56, 'Cash');
INSERT INTO transaction VALUES ('TS008', 33.74, 'E-Wallet');
INSERT INTO transaction VALUES ('TS009', 40.08, 'Apple Pay');
INSERT INTO transaction VALUES ('TS010', 46.14, 'Cash');
INSERT INTO transaction VALUES ('TS011', 37.00, 'Visa Pay');
INSERT INTO transaction VALUES ('TS012', 32.07, 'Visa Pay');
INSERT INTO transaction VALUES ('TS013', 49.32, 'Visa Pay');
INSERT INTO transaction VALUES ('TS014', 39.32, 'Apple Pay');
INSERT INTO transaction VALUES ('TS015', 37.96, 'Apple Pay');

--Insert data into Task table 
INSERT INTO task VALUES ('T001', 'Morning animal feeding', 'Feeding');
INSERT INTO task VALUES ('T002', 'Evening animal feeding', 'Feeding');
INSERT INTO task VALUES ('T003', 'Refill water bowls', 'Hydration');
INSERT INTO task VALUES ('T004', 'Clean animal living spaces', 'Cleaning');
INSERT INTO task VALUES ('T005', 'Dog walking and outdoor exercise', 'Exercise');
INSERT INTO task VALUES ('T006', 'Cat playtime and enrichment', 'Enrichment');
INSERT INTO task VALUES ('T007', 'Animal grooming', 'Grooming');
INSERT INTO task VALUES ('T008', 'Animal socialization sessions', 'Enrichment');

--Insert data into Duty table 
INSERT INTO duty VALUES ('T001', 'A002', 'P008', TO_DATE('2023-03-25', 'YYYY-MM-DD'), '08:00', 'Completed');
INSERT INTO duty VALUES ('T001', 'A003', 'P011', TO_DATE('2023-06-10', 'YYYY-MM-DD'), '10:00', 'Missed');
INSERT INTO duty VALUES ('T004', 'A003', 'P011', TO_DATE('2023-03-12', 'YYYY-MM-DD'), '13:00', 'Completed');
INSERT INTO duty VALUES ('T007', 'A008', 'P008', TO_DATE('2023-07-25', 'YYYY-MM-DD'), '11:00', 'Completed');
INSERT INTO duty VALUES ('T002', 'A009', 'P008', TO_DATE('2023-08-27', 'YYYY-MM-DD'), '18:00', 'Completed');
INSERT INTO duty VALUES ('T003', 'A012', 'P011', TO_DATE('2023-11-28', 'YYYY-MM-DD'), '08:30', 'Missed');
INSERT INTO duty VALUES ('T008', 'A011', 'P012', TO_DATE('2023-10-15', 'YYYY-MM-DD'), '14:30', 'Completed');
INSERT INTO duty VALUES ('T004', 'A004', 'P011', TO_DATE('2023-03-12', 'YYYY-MM-DD'), '13:15', 'Completed');
INSERT INTO duty VALUES ('T001', 'A014', 'P010', TO_DATE('2024-02-15', 'YYYY-MM-DD'), '08:15', 'Missed');
INSERT INTO duty VALUES ('T006', 'A016', 'P008', TO_DATE('2024-05-18', 'YYYY-MM-DD'), '10:45', 'Completed');
INSERT INTO duty VALUES ('T005', 'A017', 'P008', TO_DATE('2024-06-01', 'YYYY-MM-DD'), '09:00', 'Missed');
INSERT INTO duty VALUES ('T007', 'A018', 'P014', TO_DATE('2024-07-20', 'YYYY-MM-DD'), '11:30', 'Completed');
INSERT INTO duty VALUES ('T008', 'A019', 'P010', TO_DATE('2025-07-18', 'YYYY-MM-DD'), '14:00', 'Missed');
INSERT INTO duty VALUES ('T002', 'A020', 'P012', TO_DATE('2025-07-26', 'YYYY-MM-DD'), '18:00', 'Pending');
INSERT INTO duty VALUES ('T004', 'A019', 'P015', TO_DATE('2025-07-26', 'YYYY-MM-DD'), '13:00', 'Pending');
INSERT INTO duty VALUES ('T008', 'A020', 'P014', TO_DATE('2025-07-26', 'YYYY-MM-DD'), '14:30', 'Pending');

--Insert data into Personnel_shift table 
INSERT INTO personnel_shift VALUES ('P005', 'Mon', '09:00', '17:00');
INSERT INTO personnel_shift VALUES ('P008', 'Mon', '09:00', '17:00'); 
INSERT INTO personnel_shift VALUES ('P009', 'Mon', '09:00', '17:00');
INSERT INTO personnel_shift VALUES ('P011', 'Mon', '09:00', '17:00'); 
INSERT INTO personnel_shift VALUES ('P001', 'Mon', '09:00', '17:00'); 
INSERT INTO personnel_shift VALUES ('P006', 'Tue', '09:00', '17:00'); 
INSERT INTO personnel_shift VALUES ('P010', 'Tue', '09:00', '17:00'); 
INSERT INTO personnel_shift VALUES ('P014', 'Tue', '09:00', '17:00'); 
INSERT INTO personnel_shift VALUES ('P012', 'Tue', '09:00', '17:00');
INSERT INTO personnel_shift VALUES ('P002', 'Tue', '09:00', '17:00'); 
INSERT INTO personnel_shift VALUES ('P013', 'Wed', '09:00', '17:00'); 
INSERT INTO personnel_shift VALUES ('P015', 'Wed', '09:00', '17:00'); 
INSERT INTO personnel_shift VALUES ('P017', 'Wed', '09:00', '17:00'); 
INSERT INTO personnel_shift VALUES ('P001', 'Wed', '09:00', '17:00'); 
INSERT INTO personnel_shift VALUES ('P005', 'Thu', '09:00', '17:00'); 
INSERT INTO personnel_shift VALUES ('P008', 'Thu', '09:00', '17:00');
INSERT INTO personnel_shift VALUES ('P018', 'Thu', '09:00', '17:00'); 
INSERT INTO personnel_shift VALUES ('P002', 'Thu', '09:00', '17:00'); 
INSERT INTO personnel_shift VALUES ('P006', 'Fri', '09:00', '17:00');
INSERT INTO personnel_shift VALUES ('P009', 'Fri', '09:00', '17:00');
INSERT INTO personnel_shift VALUES ('P011', 'Fri', '09:00', '17:00'); 
INSERT INTO personnel_shift VALUES ('P001', 'Fri', '09:00', '17:00'); 
INSERT INTO personnel_shift VALUES ('P013', 'Sat', '09:00', '17:00'); 
INSERT INTO personnel_shift VALUES ('P014', 'Sat', '09:00', '17:00'); 
INSERT INTO personnel_shift VALUES ('P015', 'Sat', '09:00', '17:00'); 
INSERT INTO personnel_shift VALUES ('P012', 'Sat', '09:00', '17:00'); 
INSERT INTO personnel_shift VALUES ('P002', 'Sat', '09:00', '17:00'); 
INSERT INTO personnel_shift VALUES ('P005', 'Sun', '09:00', '17:00'); 
INSERT INTO personnel_shift VALUES ('P016', 'Sun', '09:00', '17:00'); 
INSERT INTO personnel_shift VALUES ('P019', 'Sun', '09:00', '17:00'); 
INSERT INTO personnel_shift VALUES ('P017', 'Sun', '09:00', '17:00'); 
INSERT INTO personnel_shift VALUES ('P001', 'Sun', '09:00', '17:00'); 

-- Insert data into Vet_shift table
INSERT INTO vet_shift VALUES ('V001', 'Mon', '09:00', '17:00');
INSERT INTO vet_shift VALUES ('V005', 'Tue', '09:00', '17:00'); 
INSERT INTO vet_shift VALUES ('V009', 'Wed', '09:00', '17:00'); 
INSERT INTO vet_shift VALUES ('V013', 'Thu', '09:00', '17:00'); 
INSERT INTO vet_shift VALUES ('V001', 'Fri', '09:00', '17:00'); 
INSERT INTO vet_shift VALUES ('V005', 'Sat', '09:00', '17:00');
INSERT INTO vet_shift VALUES ('V009', 'Sun', '09:00', '17:00'); 
INSERT INTO vet_shift VALUES ('V002', 'Mon', '10:00', '18:00'); 
INSERT INTO vet_shift VALUES ('V003', 'Tue', '10:00', '18:00'); 
INSERT INTO vet_shift VALUES ('V004', 'Wed', '10:00', '18:00'); 
INSERT INTO vet_shift VALUES ('V006', 'Thu', '10:00', '18:00'); 
INSERT INTO vet_shift VALUES ('V007', 'Fri', '10:00', '18:00'); 
INSERT INTO vet_shift VALUES ('V008', 'Sat', '10:00', '18:00'); 
INSERT INTO vet_shift VALUES ('V010', 'Sun', '10:00', '18:00'); 
INSERT INTO vet_shift VALUES ('V013', 'Wed', '13:00', '17:00'); 
INSERT INTO vet_shift VALUES ('V005', 'Fri', '13:00', '17:00'); 
INSERT INTO vet_shift VALUES ('V011', 'Mon', '12:00', '16:00'); 
INSERT INTO vet_shift VALUES ('V012', 'Tue', '12:00', '16:00'); 
INSERT INTO vet_shift VALUES ('V014', 'Thu', '12:00', '16:00'); 
INSERT INTO vet_shift VALUES ('V015', 'Sat', '12:00', '16:00'); 

--Insert data into Donation table 
INSERT INTO donation VALUES ('A002', 'D001', 'P005', 'Monetary', 'fund donation of RM100', TO_DATE('2023-03-10', 'YYYY-MM-DD'));
INSERT INTO donation VALUES ('A003', 'D003', 'P006', 'Food', '3kg of dry pet food', TO_DATE('2023-04-01', 'YYYY-MM-DD'));
INSERT INTO donation VALUES ('A005', 'D004', 'P001', 'Supplies', 'Pet toys', TO_DATE('2023-05-15', 'YYYY-MM-DD'));
INSERT INTO donation VALUES ('A006', 'D005', 'P002', 'Medical', 'Vaccine sponsorship', TO_DATE('2023-07-01', 'YYYY-MM-DD'));
INSERT INTO donation VALUES ('A009', 'D007', 'P006', 'Monetary', 'Emergency medical fund of RM300', TO_DATE('2023-10-05', 'YYYY-MM-DD'));
INSERT INTO donation VALUES ('A012', 'D007', 'P001', 'Food', '12-pack of wet cat food (200g)', TO_DATE('2024-03-17', 'YYYY-MM-DD'));
INSERT INTO donation VALUES ('A012', 'D003', 'P006', 'Food', '20 tins of wet kitten food (200g)', TO_DATE('2024-05-28', 'YYYY-MM-DD'));
INSERT INTO donation VALUES ('A005', 'D009', 'P005', 'Medical', 'Medication contribution', TO_DATE('2024-05-30', 'YYYY-MM-DD'));
INSERT INTO donation VALUES ('A008', 'D001', 'P002', 'Monetary', 'Emergency medical fund', TO_DATE('2024-08-01', 'YYYY-MM-DD'));
INSERT INTO donation VALUES ('A014', 'D004', 'P001', 'Supplies', 'Blankets and towels', TO_DATE('2024-11-19', 'YYYY-MM-DD'));
INSERT INTO donation VALUES ('A002', 'D007', 'P006', 'Food', 'Wet pet food cans', TO_DATE('2025-02-26', 'YYYY-MM-DD'));
INSERT INTO donation VALUES ('A001', 'D007', 'P006', 'Supplies', 'Pet toys assortment', TO_DATE('2025-05-24', 'YYYY-MM-DD'));
INSERT INTO donation VALUES ('A003', 'D009', 'P002', 'Monetary', 'Emergency medical fund', TO_DATE('2025-06-03', 'YYYY-MM-DD'));
INSERT INTO donation VALUES ('A015', 'D003', 'P002', 'Monetary', 'Sponsorship for animal', TO_DATE('2025-06-04', 'YYYY-MM-DD'));
INSERT INTO donation VALUES ('A018', 'D004', 'P006', 'Food', 'Special diet food bags', TO_DATE('2025-06-09', 'YYYY-MM-DD'));
INSERT INTO donation VALUES ('A020', 'D001', 'P006', 'Medical', 'Surgical supplies', TO_DATE('2025-07-16', 'YYYY-MM-DD'));

-- Insert data into Health Check table
INSERT INTO health_check VALUES ('A001', 'V009', TO_DATE('2025-01-20', 'YYYY-MM-DD'), 14.02, 38.2, 1);
INSERT INTO health_check VALUES ('A001', 'V005', TO_DATE('2025-01-25', 'YYYY-MM-DD'), 5.77, 37.7, 3);
INSERT INTO health_check VALUES ('A002', 'V013', TO_DATE('2024-11-30', 'YYYY-MM-DD'), 14.54, 38.4, 4);
INSERT INTO health_check VALUES ('A003', 'V001', TO_DATE('2024-11-16', 'YYYY-MM-DD'), 4.79, 37.5, 2);
INSERT INTO health_check VALUES ('A004', 'V005', TO_DATE('2025-02-25', 'YYYY-MM-DD'), 18.01, 37.3, 5);
INSERT INTO health_check VALUES ('A004', 'V005', TO_DATE('2025-03-01', 'YYYY-MM-DD'), 9.4, 37.2, 5);
INSERT INTO health_check VALUES ('A006', 'V013', TO_DATE('2023-12-18', 'YYYY-MM-DD'), 19.95, 38.5, 1);
INSERT INTO health_check VALUES ('A007', 'V009', TO_DATE('2025-03-15', 'YYYY-MM-DD'), 19.77, 38.8, 2);
INSERT INTO health_check VALUES ('A008', 'V005', TO_DATE('2023-11-02', 'YYYY-MM-DD'), 13.06, 38.5, 2);
INSERT INTO health_check VALUES ('A008', 'V013', TO_DATE('2024-03-23', 'YYYY-MM-DD'), 24.15, 37.6, 2);
INSERT INTO health_check VALUES ('A009', 'V009', TO_DATE('2023-10-02', 'YYYY-MM-DD'), 5.3, 38.7, 3);
INSERT INTO health_check VALUES ('A009', 'V009', TO_DATE('2024-12-10', 'YYYY-MM-DD'), 13.88, 37.5, 5);
INSERT INTO health_check VALUES ('A010', 'V009', TO_DATE('2025-04-05', 'YYYY-MM-DD'), 12.99, 37.7, 3);
INSERT INTO health_check VALUES ('A011', 'V005', TO_DATE('2024-06-08', 'YYYY-MM-DD'), 14.29, 37.1, 3);
INSERT INTO health_check VALUES ('A012', 'V005', TO_DATE('2024-08-30', 'YYYY-MM-DD'), 16.34, 38.4, 3);
INSERT INTO health_check VALUES ('A012', 'V005', TO_DATE('2024-12-16', 'YYYY-MM-DD'), 5.63, 38.1, 3);
INSERT INTO health_check VALUES ('A013', 'V005', TO_DATE('2024-06-23', 'YYYY-MM-DD'), 17.7, 38.0, 3);
INSERT INTO health_check VALUES ('A014', 'V005', TO_DATE('2024-09-22', 'YYYY-MM-DD'), 6.2, 37.4, 3);
INSERT INTO health_check VALUES ('A014', 'V001', TO_DATE('2024-04-20', 'YYYY-MM-DD'), 13.48, 37.1, 1);
INSERT INTO health_check VALUES ('A016', 'V009', TO_DATE('2025-05-20', 'YYYY-MM-DD'), 14.34, 38.6, 5);
INSERT INTO health_check VALUES ('A016', 'V001', TO_DATE('2025-06-20', 'YYYY-MM-DD'), 15.04, 38.3, 2);
INSERT INTO health_check VALUES ('A017', 'V001', TO_DATE('2024-09-13', 'YYYY-MM-DD'), 12.73, 37.4, 5);
INSERT INTO health_check VALUES ('A018', 'V005', TO_DATE('2025-06-10', 'YYYY-MM-DD'), 8.38, 37.4, 1);
INSERT INTO health_check VALUES ('A018', 'V013', TO_DATE('2025-06-15', 'YYYY-MM-DD'), 24.38, 37.3, 5);
INSERT INTO health_check VALUES ('A019', 'V009', TO_DATE('2024-08-02', 'YYYY-MM-DD'), 18.64, 38.7, 4);
INSERT INTO health_check VALUES ('A019', 'V001', TO_DATE('2024-11-25', 'YYYY-MM-DD'), 18.75, 37.7, 5);
INSERT INTO health_check VALUES ('A020', 'V005', TO_DATE('2024-11-01', 'YYYY-MM-DD'), 8.27, 37.2, 5);

-- Insert data into Treatment Table
INSERT INTO treatment VALUES ('A003', 'V001', TO_DATE('2023-03-01', 'YYYY-MM-DD'), 'Routine Check-up');
INSERT INTO treatment VALUES ('A006', 'V002', TO_DATE('2023-06-10', 'YYYY-MM-DD'), 'Skin Rash Examination');
INSERT INTO treatment VALUES ('A009', 'V003', TO_DATE('2023-09-05', 'YYYY-MM-DD'), 'Deworming');
INSERT INTO treatment VALUES ('A012', 'V004', TO_DATE('2023-12-01', 'YYYY-MM-DD'), 'Leg Fracture Repair');
INSERT INTO treatment VALUES ('A014', 'V005', TO_DATE('2024-03-15', 'YYYY-MM-DD'), 'Vaccination');
INSERT INTO treatment VALUES ('A016', 'V006', TO_DATE('2024-06-15', 'YYYY-MM-DD'), 'Allergy Diagnosis');
INSERT INTO treatment VALUES ('A019', 'V007', TO_DATE('2024-08-01', 'YYYY-MM-DD'), 'Tick and Flea Treatment');
INSERT INTO treatment VALUES ('A003', 'V008', TO_DATE('2024-01-10', 'YYYY-MM-DD'), 'Tumor Removal');
INSERT INTO treatment VALUES ('A006', 'V009', TO_DATE('2024-02-05', 'YYYY-MM-DD'), 'General Health Exam');
INSERT INTO treatment VALUES ('A009', 'V010', TO_DATE('2024-03-10', 'YYYY-MM-DD'), 'Dermatitis Consultation');
INSERT INTO treatment VALUES ('A012', 'V011', TO_DATE('2024-04-15', 'YYYY-MM-DD'), 'Intestinal Parasite Check');
INSERT INTO treatment VALUES ('A014', 'V012', TO_DATE('2024-05-20', 'YYYY-MM-DD'), 'Dental Extraction');
INSERT INTO treatment VALUES ('A013', 'V013', TO_DATE('2025-01-10', 'YYYY-MM-DD'), 'Post-op Check-up');
INSERT INTO treatment VALUES ('A019', 'V014', TO_DATE('2025-02-15', 'YYYY-MM-DD'), 'Skin Biopsy');
INSERT INTO treatment VALUES ('A003', 'V015', TO_DATE('2025-05-01', 'YYYY-MM-DD'), 'Parasite Prevention Review');

--Insert data into Adoption table 
INSERT INTO adoption VALUES ('A002', 'ADT003', 'P001', TO_DATE('2023-04-06', 'YYYY-MM-DD'), 'TS001');
INSERT INTO adoption VALUES ('A011', 'ADT002', 'P002', TO_DATE('2023-11-11', 'YYYY-MM-DD'), 'TS002');
INSERT INTO adoption VALUES ('A013', 'ADT001', 'P003', TO_DATE('2024-02-08', 'YYYY-MM-DD'), 'TS003');
INSERT INTO adoption VALUES ('A017', 'ADT001', 'P003', TO_DATE('2024-06-05', 'YYYY-MM-DD'), 'TS004');
INSERT INTO adoption VALUES ('A006', 'ADT001', 'P001', TO_DATE('2024-05-22', 'YYYY-MM-DD'), 'TS005');
INSERT INTO adoption VALUES ('A007', 'ADT002', 'P001', TO_DATE('2025-04-10', 'YYYY-MM-DD'), 'TS006');
INSERT INTO adoption VALUES ('A001', 'ADT007', 'P002', TO_DATE('2025-04-22', 'YYYY-MM-DD'), 'TS007');
INSERT INTO adoption VALUES ('A010', 'ADT005', 'P002', TO_DATE('2025-05-01', 'YYYY-MM-DD'), 'TS008');
INSERT INTO adoption VALUES ('A016', 'ADT008', 'P001', TO_DATE('2025-06-15', 'YYYY-MM-DD'), 'TS009');
INSERT INTO adoption VALUES ('A018', 'ADT009', 'P003', TO_DATE('2025-07-05', 'YYYY-MM-DD'), 'TS010');
INSERT INTO adoption VALUES ('A003', 'ADT008', 'P004', TO_DATE('2025-07-09', 'YYYY-MM-DD'), 'TS011');
INSERT INTO adoption VALUES ('A004', 'ADT001', 'P002', TO_DATE('2024-07-09', 'YYYY-MM-DD'), 'TS012');
INSERT INTO adoption VALUES ('A008', 'ADT004', 'P005', TO_DATE('2025-07-13', 'YYYY-MM-DD'), 'TS013');
INSERT INTO adoption VALUES ('A009', 'ADT006', 'P006', TO_DATE('2025-07-15', 'YYYY-MM-DD'), 'TS014');
INSERT INTO adoption VALUES ('A012', 'ADT004', 'P007', TO_DATE('2025-07-21', 'YYYY-MM-DD'), 'TS015');

-- Display all tables --
SELECT * FROM animal;
SELECT * FROM veterinarian; 
SELECT * FROM vet_shift;
SELECT * FROM health_check;
SELECT * FROM treatment;
SELECT * FROM personnel;
SELECT * FROM personnel_shift;
SELECT * FROM duty;
SELECT * FROM task;
SELECT * FROM adopter;
SELECT * FROM adoption;
SELECT * FROM donor;
SELECT * FROM donation;
SELECT * FROM transaction;