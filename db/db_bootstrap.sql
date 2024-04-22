-- This file is to bootstrap a database for the CS3200 project. 

-- Create a new database.  You can change the name later.  You'll
-- need this name in the FLASK API file(s),  the AppSmith 
-- data source creation.
create database IF NOT EXISTS fittrack;

-- Via the Docker Compose file, a special user called webapp will 
-- be created in MySQL. We are going to grant that user 
-- all privilages to the new database we just created. 
-- TODO: If you changed the name of the database above, you need 
-- to change it here too.
grant all privileges on fittrack.* to 'webapp'@'%';
flush privileges;

-- Move into the database we just created.
-- TODO: If you changed the name of the database above, you need to
-- change it here too. 
use fittrack;

-- Put your DDL 

-- Create Gym table
CREATE TABLE IF NOT EXISTS Gym (
    Gym_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Address VARCHAR(255)
);

-- Create Gym_Affiliated_Employees table
CREATE TABLE Gym_Affiliated_Employees (
    Trainer_ID INT PRIMARY KEY,
    Employee_ID INT,
    Gym_ID INT,
    Phone_Number VARCHAR(15),
    Name VARCHAR(100),
    Certification VARCHAR(100),
    Position VARCHAR(50),
    Experience INT,
    Availability VARCHAR(255),
    FOREIGN KEY (Gym_ID) REFERENCES Gym(Gym_ID)
);

ALTER TABLE Gym_Affiliated_Employees
MODIFY Experience VARCHAR(50);



-- Create Workout_Plan table
CREATE TABLE Workout_Plan (
    Plan_ID INT PRIMARY KEY,
    Name VARCHAR(255),
    Description TEXT,
    Focus VARCHAR(50)
);

-- Create Member table
CREATE TABLE Member (
    Member_ID INT PRIMARY KEY,
    Plan_ID INT,
    Username VARCHAR(50),
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Password VARCHAR(50),
    Phone_Number VARCHAR(15),
    Date_of_Birth DATE,
    Address VARCHAR(255),
    Email VARCHAR(255),
    Focus VARCHAR(50),
    FOREIGN KEY (Plan_ID) REFERENCES Workout_Plan(Plan_ID)
);

-- Create Connect_Platform table
CREATE TABLE Connect_Platform (
    Member_ID INT PRIMARY KEY,
    UserName VARCHAR(50),
    FOREIGN KEY (Member_ID) REFERENCES Member(Member_ID)
);

-- Create Member_Profile table
CREATE TABLE Member_Profile (
    Member_ID INT,
    Home_Gym_ID INT,
    Fitness_Goals TEXT,
    UserName VARCHAR(50),
    Gender CHAR(1),
    Achievements TEXT,
    Preferences TEXT,
    Membership_State_Date DATE,
    PRIMARY KEY (Member_ID),
    FOREIGN KEY (Member_ID) REFERENCES Member(Member_ID),
    FOREIGN KEY (Home_Gym_ID) REFERENCES Gym(Gym_ID)
);

ALTER TABLE Member_Profile
RENAME COLUMN Membership_State_Date TO Membership_Start_Date;

ALTER TABLE Member_Profile
RENAME COLUMN Fitness_Goals TO Fitness_Goal;

-- Create Reminder table
CREATE TABLE Reminder (
    Reminder_ID INT PRIMARY KEY,
    Member_ID INT,
    Time_Sent DATETIME,
    Message TEXT,
    FOREIGN KEY (Member_ID) REFERENCES Member(Member_ID)
);

-- Create Connect_Platform_Friends table
CREATE TABLE Connect_Platform_Friends (
    Friends VARCHAR(50),
    Member_ID INT,
    PRIMARY KEY (Friends, Member_ID),
    FOREIGN KEY (Member_ID) REFERENCES Member(Member_ID)
);


ALTER TABLE Connect_Platform_Friends
MODIFY Friends VARCHAR(50);

-- Create Member_Workout_Plan table
CREATE TABLE Member_Workout_Plan (
    Member_ID INT,
    Plan_ID INT,
    PRIMARY KEY (Member_ID, Plan_ID),
    FOREIGN KEY (Member_ID) REFERENCES Member(Member_ID),
    FOREIGN KEY (Plan_ID) REFERENCES Workout_Plan(Plan_ID)
);

-- Create Progress_Tracker table
CREATE TABLE Progress_Tracker (
    Plan_ID INT,
    Member_ID INT,
    Date DATE,
    Achievements TEXT,
    Weight DECIMAL(5,2),
    PRIMARY KEY (Plan_ID, Member_ID),
    FOREIGN KEY (Plan_ID) REFERENCES Workout_Plan(Plan_ID),
    FOREIGN KEY (Member_ID) REFERENCES Member(Member_ID)
);

-- Create Member_Reminder table
CREATE TABLE Member_Reminder (
    Reminder_ID INT,
    Member_ID INT,
    PRIMARY KEY (Reminder_ID, Member_ID),
    FOREIGN KEY (Reminder_ID) REFERENCES Reminder(Reminder_ID),
    FOREIGN KEY (Member_ID) REFERENCES Member(Member_ID)
);

-- Create Attendance table
CREATE TABLE Attendance (
    Member_ID INT,
    Gym_ID INT,
    Date DATE,
    Workout_Freq INT,
    PRIMARY KEY (Member_ID, Gym_ID, Date),
    FOREIGN KEY (Member_ID) REFERENCES Member(Member_ID),
    FOREIGN KEY (Gym_ID) REFERENCES Gym(Gym_ID)
);

ALTER TABLE Attendance
MODIFY Workout_Freq VARCHAR(50);

-- Create Records table
CREATE TABLE Records (
    Member_ID INT,
    Gym_ID INT,
    Date DATE,
    PRIMARY KEY (Member_ID, Gym_ID, Date),
    FOREIGN KEY (Member_ID) REFERENCES Member(Member_ID),
    FOREIGN KEY (Gym_ID) REFERENCES Gym(Gym_ID)
);

-- Create Social_Events table
CREATE TABLE Social_Events (
    Event_ID INT PRIMARY KEY,
    Gym_ID INT,
    Location VARCHAR(255),
    Time TIME,
    Date DATE,
    Organizer VARCHAR(100),
    Description TEXT,
    Attendance_Limit INT,
    Event_Name VARCHAR(100),
    FOREIGN KEY (Gym_ID) REFERENCES Gym(Gym_ID)
);

-- Create Gym_Members table
CREATE TABLE Gym_Members (
    Member_ID INT,
    Gym_ID INT,
    PRIMARY KEY (Member_ID, Gym_ID),
    FOREIGN KEY (Member_ID) REFERENCES Member(Member_ID),
    FOREIGN KEY (Gym_ID) REFERENCES Gym(Gym_ID)
);

-- Create Gym_Events table
CREATE TABLE Gym_Events (
    Gym_ID INT,
    Event_ID INT,
    PRIMARY KEY (Gym_ID, Event_ID),
    FOREIGN KEY (Gym_ID) REFERENCES Gym(Gym_ID),
    FOREIGN KEY (Event_ID) REFERENCES Social_Events(Event_ID)
);

-- Create Equipment table
CREATE TABLE Equipment (
    Equipment_ID INT PRIMARY KEY,
    Gym_ID INT,
    Name VARCHAR(100),
    Target_Muscle VARCHAR(50),
    FOREIGN KEY (Gym_ID) REFERENCES Gym(Gym_ID)
);

-- Create Fitness_Class table
CREATE TABLE Fitness_Class (
    Class_ID INT PRIMARY KEY,
    Gym_ID INT,
    Instructor_ID INT,
    Name VARCHAR(100),
    Description TEXT,
    Focus VARCHAR(50),
    FOREIGN KEY (Gym_ID) REFERENCES Gym(Gym_ID),
    FOREIGN KEY (Instructor_ID) REFERENCES Gym_Affiliated_Employees(Trainer_ID)
);

-- Create Occupancy table
CREATE TABLE Occupancy (
    Gym_ID INT,
    Occupancy_Level INT,
    Max_Occupancy INT,
    Time TIME,
    Date DATE,
    PRIMARY KEY (Gym_ID, Time, Date),
    FOREIGN KEY (Gym_ID) REFERENCES Gym(Gym_ID)
);




-- SAMPLE DATA MOCKAROO

insert into Gym (gym_id, name, address) values (1, 'FitZone', '67 Jackson Road');
insert into Gym (gym_id, name, address) values (2, 'Body Blast', '78 Moulton Plaza');
insert into Gym (gym_id, name, address) values (3, 'Peak Physique', '269 Fair Oaks Street');
insert into Gym (gym_id, name, address) values (4, 'Body Blast', '6 Basil Park');
insert into Gym (gym_id, name, address) values (5, 'Flex Fitness', '60927 Carpenter Plaza');
insert into Gym (gym_id, name, address) values (6, 'FitZone', '2824 Vahlen Terrace');
insert into Gym (gym_id, name, address) values (7, 'FitZone', '7522 Union Trail');
insert into Gym (gym_id, name, address) values (8, 'FitZone', '49225 Sage Road');
insert into Gym (gym_id, name, address) values (9, 'Iron Strong Gym', '1 Pankratz Crossing');
insert into Gym (gym_id, name, address) values (10, 'Muscle Haven', '24 Thompson Place');
insert into Gym (gym_id, name, address) values (11, 'FitZone', '9789 Hovde Junction');
insert into Gym (gym_id, name, address) values (12, 'Body Blast', '438 West Hill');
insert into Gym (gym_id, name, address) values (13, 'Gymfinity', '5037 Twin Pines Road');
insert into Gym (gym_id, name, address) values (14, 'Peak Physique', '29 Fairfield Crossing');
insert into Gym (gym_id, name, address) values (15, 'Elite Performance', '346 Forster Hill');
insert into Gym (gym_id, name, address) values (16, 'Peak Physique', '4 Melrose Parkway');
insert into Gym (gym_id, name, address) values (17, 'Peak Physique', '0 Golden Leaf Street');
insert into Gym (gym_id, name, address) values (18, 'Iron Strong Gym', '5696 Scoville Avenue');
insert into Gym (gym_id, name, address) values (19, 'Peak Physique', '74 Butterfield Junction');
insert into Gym (gym_id, name, address) values (20, 'Sweat City', '92371 Goodland Terrace');
insert into Gym (gym_id, name, address) values (21, 'Powerhouse Gym', '48970 Straubel Lane');
insert into Gym (gym_id, name, address) values (22, 'FitZone', '62 Service Pass');
insert into Gym (gym_id, name, address) values (23, 'Flex Fitness', '866 Washington Trail');
insert into Gym (gym_id, name, address) values (24, 'Elite Performance', '2110 West Terrace');
insert into Gym (gym_id, name, address) values (25, 'Peak Physique', '083 Warrior Alley');
insert into Gym (gym_id, name, address) values (26, 'Body Blast', '61 Mallory Avenue');
insert into Gym (gym_id, name, address) values (27, 'Elite Performance', '7989 Leroy Park');
insert into Gym (gym_id, name, address) values (28, 'Muscle Haven', '730 Mariners Cove Alley');
insert into Gym (gym_id, name, address) values (29, 'Sweat City', '1 Nelson Point');
insert into Gym (gym_id, name, address) values (30, 'Muscle Haven', '231 Sommers Place');
insert into Gym (gym_id, name, address) values (31, 'Iron Strong Gym', '986 Brown Terrace');
insert into Gym (gym_id, name, address) values (32, 'Iron Strong Gym', '230 Express Trail');
insert into Gym (gym_id, name, address) values (33, 'Gymfinity', '89 Summit Trail');
insert into Gym (gym_id, name, address) values (34, 'Muscle Haven', '460 Orin Avenue');
insert into Gym (gym_id, name, address) values (35, 'Sweat City', '54 Vernon Plaza');
insert into Gym (gym_id, name, address) values (36, 'Flex Fitness', '4 Arrowood Pass');
insert into Gym (gym_id, name, address) values (37, 'Sweat City', '4755 Texas Street');
insert into Gym (gym_id, name, address) values (38, 'Flex Fitness', '67668 Maryland Place');
insert into Gym (gym_id, name, address) values (39, 'Elite Performance', '826 Iowa Place');
insert into Gym (gym_id, name, address) values (40, 'FitZone', '730 Becker Drive');
insert into Gym (gym_id, name, address) values (41, 'Body Blast', '8832 Transport Terrace');


insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (1, 1, 1, '714-733-6937', 'Olivia Taylor', 'CPR Certified', 'receptionist', '5 years', 'Full-time');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (2, 2, 2, '736-687-9859', 'Jane Smith', 'Fitness Nutrition Certification', 'trainer', '4 years', 'Vacation');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (3, 3, 3, '617-630-4437', 'Emily Davis', 'Personal Trainer Certification', 'trainer', '3 years', 'Remote');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (4, 4, 4, '331-709-0567', 'Michael Johnson', 'CPR Certified', 'manager', '3 years', 'Part-time');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (5, 5, 5, '210-266-6693', 'Kevin Martinez', 'CPR Certified', 'trainer', '3 years', 'Full-time');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (6, 6, 6, '916-817-3217', 'David Lee', 'CPR Certified', 'trainer', '4 years', 'Part-time');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (7, 7, 7, '712-456-4825', 'Sarah Wilson', 'Personal Trainer Certification', 'manager', '2 years', 'Full-time');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (8, 8, 8, '872-384-3756', 'Rachel Miller', 'Fitness Nutrition Certification', 'trainer', '4 years', 'Full-time');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (9, 9, 9, '933-918-0335', 'John Doe', 'CPR Certified', 'trainer', '4 years', 'Part-time');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (10, 10, 10, '429-779-3911', 'John Doe', 'CPR Certified', 'trainer', '5 years', 'Part-time');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (11, 11, 11, '282-585-8475', 'Kevin Martinez', 'Personal Trainer Certification', 'cleaner', '4 years', 'Sick leave');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (12, 12, 12, '313-354-9526', 'Kevin Martinez', 'First Aid Certified', 'manager', '1 year', 'Remote');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (13, 13, 13, '647-523-6066', 'Sarah Wilson', 'Fitness Nutrition Certification', 'trainer', '4 years', 'Part-time');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (14, 14, 14, '588-459-3895', 'Olivia Taylor', 'Personal Trainer Certification', 'trainer', '3 years', 'Part-time');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (15, 15, 15, '681-507-9036', 'Olivia Taylor', 'First Aid Certified', 'receptionist', '3 years', 'Part-time');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (16, 16, 16, '674-932-0629', 'Michael Johnson', 'First Aid Certified', 'coach', '1 year', 'Remote');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (17, 17, 17, '358-229-1779', 'Olivia Taylor', 'CPR Certified', 'coach', '3 years', 'Sick leave');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (18, 18, 18, '419-849-1049', 'David Lee', 'Personal Trainer Certification', 'manager', '4 years', 'Remote');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (19, 19, 19, '573-636-4752', 'Kevin Martinez', 'First Aid Certified', 'cleaner', '4 years', 'Full-time');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (20, 20, 20, '230-926-7960', 'Sarah Wilson', 'Personal Trainer Certification', 'trainer', '3 years', 'Remote');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (21, 21, 21, '158-669-6649', 'Jane Smith', 'CPR Certified', 'cleaner', '2 years', 'On-call');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (22, 22, 22, '247-437-0877', 'Michael Johnson', 'Fitness Nutrition Certification', 'receptionist', '1 year', 'Part-time');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (23, 23, 23, '134-489-1858', 'Emily Davis', 'Fitness Nutrition Certification', 'trainer', '3 years', 'Sick leave');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (24, 24, 24, '429-297-6369', 'Alex Brown', 'First Aid Certified', 'cleaner', '4 years', 'Part-time');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (25, 25, 25, '109-743-3955', 'David Lee', 'CPR Certified', 'coach', '5 years', 'On-call');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (26, 26, 26, '145-354-5788', 'John Doe', 'Personal Trainer Certification', 'coach', '4 years', 'Sick leave');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (27, 27, 27, '536-428-7492', 'Rachel Miller', 'First Aid Certified', 'cleaner', '1 year', 'On-call');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (28, 28, 28, '525-716-0168', 'David Lee', 'First Aid Certified', 'coach', '5 years', 'Part-time');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (29, 29, 29, '862-533-2714', 'Alex Brown', 'First Aid Certified', 'coach', '1 year', 'Sick leave');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (30, 30, 30, '891-278-2146', 'Olivia Taylor', 'Fitness Nutrition Certification', 'receptionist', '1 year', 'Vacation');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (31, 31, 31, '709-548-8059', 'David Lee', 'Personal Trainer Certification', 'manager', '4 years', 'Full-time');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (32, 32, 32, '420-190-5134', 'Rachel Miller', 'Personal Trainer Certification', 'coach', '4 years', 'Sick leave');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (33, 33, 33, '784-670-9726', 'Kevin Martinez', 'Fitness Nutrition Certification', 'trainer', '1 year', 'On-call');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (34, 34, 34, '411-502-2070', 'Michael Johnson', 'CPR Certified', 'cleaner', '5 years', 'Sick leave');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (35, 35, 35, '800-243-7457', 'Alex Brown', 'Fitness Nutrition Certification', 'coach', '3 years', 'Sick leave');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (36, 36, 36, '865-890-4251', 'Alex Brown', 'First Aid Certified', 'cleaner', '3 years', 'Vacation');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (37, 37, 37, '436-120-8360', 'Alex Brown', 'Fitness Nutrition Certification', 'cleaner', '2 years', 'Vacation');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (38, 38, 38, '462-384-2710', 'Rachel Miller', 'CPR Certified', 'manager', '2 years', 'Remote');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (39, 39, 39, '448-795-2836', 'Michael Johnson', 'Fitness Nutrition Certification', 'coach', '3 years', 'Remote');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (40, 40, 40, '347-760-4339', 'Jane Smith', 'CPR Certified', 'trainer', '2 years', 'Vacation');
insert into Gym_Affiliated_Employees (Trainer_ID, Employee_ID, Gym_ID, Phone_Number, Name, Certification, Position, Experience, Availability) values (41, 41, 41, '315-574-7794', 'Michael Johnson', 'Fitness Nutrition Certification', 'trainer', '4 years', 'On-call');



insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (1, 'HIIT Circuit', 'CrossFit challenge', 'back');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (2, 'Pilates Fusion', 'Cardio-focused plan', 'shoulders');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (3, 'Yoga Flow', 'HIIT workout routine', 'core');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (4, 'Pilates Fusion', 'Strength training program', 'core');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (5, 'Strength Training', 'Yoga and meditation schedule', 'legs');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (6, 'Pilates Fusion', 'Strength training program', 'arms');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (7, 'Strength Training', 'Cardio-focused plan', 'arms');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (8, 'Cardio Blast', 'Strength training program', 'shoulders');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (9, 'Yoga Flow', 'Yoga and meditation schedule', 'chest');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (10, 'Yoga Flow', 'CrossFit challenge', 'legs');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (11, 'Strength Training', 'Yoga and meditation schedule', 'chest');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (12, 'Cardio Blast', 'CrossFit challenge', 'back');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (13, 'Strength Training', 'Cardio-focused plan', 'back');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (14, 'HIIT Circuit', 'Yoga and meditation schedule', 'back');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (15, 'Cardio Blast', 'Cardio-focused plan', 'back');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (16, 'Pilates Fusion', 'Cardio-focused plan', 'legs');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (17, 'Yoga Flow', 'Cardio-focused plan', 'core');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (18, 'Cardio Blast', 'HIIT workout routine', 'legs');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (19, 'Strength Training', 'Strength training program', 'shoulders');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (20, 'Yoga Flow', 'Strength training program', 'back');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (21, 'Pilates Fusion', 'HIIT workout routine', 'back');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (22, 'Pilates Fusion', 'CrossFit challenge', 'shoulders');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (23, 'Yoga Flow', 'HIIT workout routine', 'arms');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (24, 'Strength Training', 'Cardio-focused plan', 'legs');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (25, 'Yoga Flow', 'CrossFit challenge', 'legs');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (26, 'Strength Training', 'CrossFit challenge', 'arms');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (27, 'HIIT Circuit', 'Strength training program', 'chest');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (28, 'HIIT Circuit', 'Yoga and meditation schedule', 'arms');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (29, 'Strength Training', 'Yoga and meditation schedule', 'chest');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (30, 'Cardio Blast', 'Cardio-focused plan', 'core');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (31, 'Cardio Blast', 'HIIT workout routine', 'core');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (32, 'Yoga Flow', 'Cardio-focused plan', 'back');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (33, 'HIIT Circuit', 'CrossFit challenge', 'shoulders');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (34, 'Strength Training', 'CrossFit challenge', 'core');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (35, 'Yoga Flow', 'Strength training program', 'arms');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (36, 'HIIT Circuit', 'HIIT workout routine', 'back');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (37, 'Cardio Blast', 'CrossFit challenge', 'back');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (38, 'Strength Training', 'HIIT workout routine', 'arms');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (39, 'Cardio Blast', 'HIIT workout routine', 'chest');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (40, 'Pilates Fusion', 'Cardio-focused plan', 'shoulders');
insert into Workout_Plan (Plan_ID, Name, Description, Focus) values (41, 'HIIT Circuit', 'HIIT workout routine', 'chest');


insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (2, null, 'araistrick1', 'Ave', 'Raistrick', 'oW3~jP3,FM+6"&_<', '473-906-4785', '1955-10-11', '58423 Pepper Wood Park', 'araistrick1@1688.com', 'triceps');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (3, null, 'eattlee2', 'Ebonee', 'Attlee', 'xN9*)HbH=qx', '816-926-1232', '1974-01-31', '65098 Pleasure Avenue', 'eattlee2@sun.com', 'biceps');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (4, null, 'adecort3', 'Angelo', 'Decort', 'sZ7\ptF,"r@K%rIA', '400-886-1895', '1950-11-25', '5 Northridge Circle', 'adecort3@cmu.edu', 'triceps');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (5, null, 'clavender4', 'Celisse', 'Lavender', 'lB9!H)DftU(YXZbN', '693-420-7843', '1953-05-25', '338 Lawn Terrace', 'clavender4@wp.com', 'biceps');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (6, null, 'jcomben5', 'Jarvis', 'Comben', 'kP1)n`c|TIp3ZYdu', '317-659-0769', '1971-02-06', '021 American Park', 'jcomben5@uol.com.br', 'hamstrings');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (7, null, 'mpetrollo6', 'Maiga', 'Petrollo', 'oO0>HkYhX', '986-803-2542', '1996-05-17', '4257 Knutson Road', 'mpetrollo6@printfriendly.com', 'triceps');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (8, null, 'rwheeler7', 'Rosamund', 'Wheeler', 'rT2/ga1U"KkjG', '709-308-5460', '1966-08-29', '81724 Nancy Trail', 'rwheeler7@creativecommons.org', 'calves');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (9, null, 'hsciusscietto8', 'Hadlee', 'Sciusscietto', 'fO1&@Pw`Ld)yr', '827-930-4535', '2002-10-31', '59954 Mendota Trail', 'hsciusscietto8@nps.gov', 'calves');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (10, null, 'dbadwick9', 'Dita', 'Badwick', 'cM0`gztfczhI#7?', '844-594-9984', '1954-10-30', '48508 Mariners Cove Drive', 'dbadwick9@mit.edu', 'hamstrings');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (11, null, 'cabramamova', 'Charmion', 'Abramamov', 'iM3<xp&OsP12(c*L', '116-528-3828', '1955-08-14', '689 Fair Oaks Pass', 'cabramamova@yahoo.com', 'hamstrings');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (12, null, 'ddaniellob', 'Doug', 'Daniello', 'cV2,D\MkVPQ@F', '478-413-3361', '1970-01-30', '0 4th Lane', 'ddaniellob@discovery.com', 'biceps');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (13, null, 'mroebuckc', 'Meade', 'Roebuck', 'hU3#ALWr0', '757-772-1266', '1961-07-25', '9346 Lakewood Gardens Court', 'mroebuckc@ucoz.ru', 'calves');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (14, null, 'rpahlerd', 'Rakel', 'Pahler', 'dL7$XSq}cj', '768-471-5532', '1956-02-11', '85586 Coleman Road', 'rpahlerd@ebay.com', 'triceps');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (15, null, 'mhardwickee', 'Marne', 'Hardwicke', 'uM0"j4v|', '299-734-1935', '1998-04-12', '5 Texas Alley', 'mhardwickee@goo.ne.jp', 'hamstrings');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (16, null, 'asaffillf', 'Adiana', 'Saffill', 'iM1}IW&>5h?=j', '784-514-9221', '1950-02-25', '2 Kedzie Street', 'asaffillf@npr.org', 'triceps');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (17, null, 'csailesg', 'Candace', 'Sailes', 'mM6''M4.a/ONXQ', '502-856-1198', '1964-09-04', '190 Corry Park', 'csailesg@feedburner.com', 'triceps');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (18, null, 'ltomasikh', 'Lavena', 'Tomasik', 'tN0,8japm1pFeUx#', '586-488-0641', '1963-02-28', '492 Kropf Alley', 'ltomasikh@discovery.com', 'calves');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (19, null, 'heddowesi', 'Herve', 'Eddowes', 'sM2@B9_RVO@B)r=', '758-973-4335', '2003-12-26', '52729 Center Road', 'heddowesi@yelp.com', 'quadriceps');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (20, null, 'kfingletonj', 'Kelci', 'Fingleton', 'zN8=FG.XTD', '408-372-7466', '1969-11-08', '0903 Meadow Valley Parkway', 'kfingletonj@dyndns.org', 'quadriceps');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (21, null, 'vupcraftk', 'Vaughan', 'Upcraft', 'oP7)g|VTvjit', '400-259-4379', '1978-07-16', '51103 Nelson Street', 'vupcraftk@discuz.net', 'calves');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (22, null, 'hpaulitschkel', 'Hilarius', 'Paulitschke', 'kN8#R''K>&', '790-608-9929', '2000-10-28', '14 Huxley Way', 'hpaulitschkel@miitbeian.gov.cn', 'hamstrings');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (23, null, 'hbenadettem', 'Hanan', 'Benadette', 'cE1(VFzw<i+5CfaZ', '230-398-1674', '1967-05-20', '95695 Maple Wood Avenue', 'hbenadettem@java.com', 'biceps');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (24, null, 'tconroyn', 'Tiertza', 'Conroy', 'bT6%B\_hu''!', '464-965-3447', '2001-08-17', '061 Algoma Center', 'tconroyn@skype.com', 'calves');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (25, null, 'tfearyo', 'Trisha', 'Feary', 'pJ6<hU$C@', '360-572-2746', '1956-06-24', '82966 Forest Dale Avenue', 'tfearyo@disqus.com', 'triceps');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (26, null, 'nmccloyp', 'Neely', 'McCloy', 'oW7$3zE,E5$9', '201-426-0048', '1954-05-22', '31837 Dryden Center', 'nmccloyp@moonfruit.com', 'calves');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (27, null, 'fnuzziq', 'Felicity', 'Nuzzi', 'pS8)5Fd&@`', '307-513-4583', '1984-12-13', '1291 Grayhawk Place', 'fnuzziq@discuz.net', 'triceps');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (28, null, 'azanrer', 'Ashton', 'Zanre', 'yF1#_<@F', '419-444-9750', '1975-04-20', '31031 Holy Cross Drive', 'azanrer@youtu.be', 'hamstrings');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (29, null, 'bjobs', 'Beatrix', 'Job', 'aQ8%v8qC|,&', '934-493-0001', '1966-06-08', '3617 Anniversary Junction', 'bjobs@com.com', 'quadriceps');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (30, null, 'smeiklet', 'Sharity', 'Meikle', 'zS3?gbd\CWs$QU_', '104-748-9110', '1979-09-07', '1 Manitowish Avenue', 'smeiklet@php.net', 'triceps');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (31, null, 'blevingsu', 'Bastien', 'Levings', 'kR2`dKd"a#Yk)rvm', '498-859-8790', '1972-10-25', '064 Vidon Avenue', 'blevingsu@harvard.edu', 'biceps');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (32, null, 'hstrangewayv', 'Homer', 'Strangeway', 'eB7_%AQJ_zut_D|', '475-484-8350', '2002-07-19', '1590 Darwin Terrace', 'hstrangewayv@paypal.com', 'triceps');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (33, null, 'kdrakew', 'Klement', 'Drake', 'fZ7#5{@IUMJbpjc', '926-605-2802', '1978-04-15', '8 Elmside Court', 'kdrakew@wordpress.org', 'triceps');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (34, null, 'fbrideaux', 'Fara', 'Brideau', 'vW4>ssz%T', '622-955-3544', '1972-10-14', '4158 Delladonna Center', 'fbrideaux@mtv.com', 'biceps');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (35, null, 'dgilkisony', 'Deanne', 'Gilkison', 'vG6#mN4F`', '572-495-3981', '1968-12-05', '760 Katie Way', 'dgilkisony@yolasite.com', 'biceps');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (36, null, 'gastlettz', 'Gena', 'Astlett', 'iF7|8"87*N7zQ', '525-837-5968', '1972-05-27', '31614 Lunder Lane', 'gastlettz@photobucket.com', 'quadriceps');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (37, null, 'tgilliat10', 'Tony', 'Gilliat', 'wH7(`7VI%', '636-875-2129', '1995-11-06', '18 Springs Circle', 'tgilliat10@cdc.gov', 'biceps');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (38, null, 'warundale11', 'Wini', 'Arundale', 'aB4+mb)B*%c1g8', '426-450-6249', '1977-09-08', '514 Larry Hill', 'warundale11@topsy.com', 'calves');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (39, null, 'edeelay12', 'Etti', 'Deelay', 'zA9<LP.xe*1*Z>R', '446-870-1178', '1967-06-28', '4330 Alpine Trail', 'edeelay12@hugedomains.com', 'calves');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (40, null, 'pcoleford13', 'Portie', 'Coleford', 'tJ8#Hcz.|Mfm', '363-630-0913', '1993-04-23', '9 Shoshone Crossing', 'pcoleford13@sciencedaily.com', 'biceps');
insert into Member (Member_ID, Plan_ID, Username, First_Name, Last_Name, Password, Phone_Number, Date_of_Birth, Address, Email, Focus) values (41, null, 'bambroise14', 'Beatriz', 'Ambroise', 'sE7?(|`tK>1OBn', '786-986-1772', '1973-05-08', '97131 Nevada Circle', 'bambroise14@blogs.com', 'quadriceps');


insert into Connect_Platform (Member_ID, Username) values ('30', 'rimlawt');
insert into Connect_Platform (Member_ID, Username) values ('41', 'jarnaldy14');
insert into Connect_Platform (Member_ID, Username) values ('20', 'sisaacsj');
insert into Connect_Platform (Member_ID, Username) values ('29', 'cpepineauxs');
insert into Connect_Platform (Member_ID, Username) values ('3', 'epetrashov2');
insert into Connect_Platform (Member_ID, Username) values ('18', 'tdinkinh');
insert into Connect_Platform (Member_ID, Username) values ('32', 'dbraniganv');
insert into Connect_Platform (Member_ID, Username) values ('36', 'ethornhamz');
insert into Connect_Platform (Member_ID, Username) values ('27', 'scabenaq');
insert into Connect_Platform (Member_ID, Username) values ('8', 'lfieldstone7');
insert into Connect_Platform (Member_ID, Username) values ('6', 'kcarbett5');
insert into Connect_Platform (Member_ID, Username) values ('24', 'wkleinn');
insert into Connect_Platform (Member_ID, Username) values ('19', 'rchalcrofti');
insert into Connect_Platform (Member_ID, Username) values ('14', 'xmilvarnied');
insert into Connect_Platform (Member_ID, Username) values ('21', 'mbartolomeok');
insert into Connect_Platform (Member_ID, Username) values ('2', 'fvockings1');
insert into Connect_Platform (Member_ID, Username) values ('13', 'jmacmoyerc');
insert into Connect_Platform (Member_ID, Username) values ('16', 'aoswalf');
insert into Connect_Platform (Member_ID, Username) values ('10', 'kswitland9');
insert into Connect_Platform (Member_ID, Username) values ('17', 'mmaffinig');
insert into Connect_Platform (Member_ID, Username) values ('35', 'lhanrotty');
insert into Connect_Platform (Member_ID, Username) values ('33', 'rlanganw');
insert into Connect_Platform (Member_ID, Username) values ('5', 'mvarren4');
insert into Connect_Platform (Member_ID, Username) values ('11', 'wella');
insert into Connect_Platform (Member_ID, Username) values ('37', 'kping10');
insert into Connect_Platform (Member_ID, Username) values ('34', 'joneilx');
insert into Connect_Platform (Member_ID, Username) values ('26', 'zwaszkiewiczp');
insert into Connect_Platform (Member_ID, Username) values ('23', 'llinsterm');
insert into Connect_Platform (Member_ID, Username) values ('39', 'jespinel12');
insert into Connect_Platform (Member_ID, Username) values ('38', 'bfitch11');
insert into Connect_Platform (Member_ID, Username) values ('22', 'rstuckesl');
insert into Connect_Platform (Member_ID, Username) values ('9', 'dhewson8');
insert into Connect_Platform (Member_ID, Username) values ('31', 'lwaddupu');
insert into Connect_Platform (Member_ID, Username) values ('7', 'alyddyard6');
insert into Connect_Platform (Member_ID, Username) values ('40', 'ezoren13');
insert into Connect_Platform (Member_ID, Username) values ('12', 'sparnhamb');
insert into Connect_Platform (Member_ID, Username) values ('28', 'ojursr');
insert into Connect_Platform (Member_ID, Username) values ('15', 'mpoytherase');
insert into Connect_Platform (Member_ID, Username) values ('25', 'hmacgettigeno');
insert into Connect_Platform (Member_ID, Username) values ('4', 'cmaltster3');
insert into Connect_Platform (Member_ID, Username) values ('1', 'bblatchford0');


insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('6', '25', 'lose 10 pounds', 'kcarbett5', 'M', 'Achieved personal best in deadlift', 'spin class', '2019-11-15');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('24', '28', 'increase bench press by 20 lbs', 'wkleinn', 'F', 'Ran a 5k', 'crossfit', '2010-07-07');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('23', '6', 'complete a fitness challenge', 'llinsterm', 'F', 'Achieved personal best in deadlift', 'yoga', '2020-08-12');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('25', '3', 'complete a fitness challenge', 'hmacgettigeno', 'F', 'Lost 10 lbs', 'cardio', '2016-01-28');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('11', '20', 'attend gym 3 times a week', 'wella', 'M', 'Lost 10 lbs', 'yoga', '2012-10-09');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('28', '14', 'complete a fitness challenge', 'ojursr', 'F', 'Attended 50 classes', 'weightlifting', '2010-10-08');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('36', '22', 'complete a fitness challenge', 'ethornhamz', 'M', 'Ran a 5k', 'yoga', '2013-11-28');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('33', '32', 'lose 10 pounds', 'rlanganw', 'F', 'Attended 50 classes', 'yoga', '2018-06-30');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('20', '29', 'attend gym 3 times a week', 'sisaacsj', 'F', 'Lost 10 lbs', 'spin class', '2010-11-27');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('15', '34', 'lose 10 pounds', 'mpoytherase', 'F', 'Ran a 5k', 'crossfit', '2017-08-18');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('21', '23', 'attend gym 3 times a week', 'mbartolomeok', 'M', 'Lost 10 lbs', 'cardio', '2017-06-08');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('12', '16', 'complete a fitness challenge', 'sparnhamb', 'M', 'Ran a 5k', 'weightlifting', '2010-03-18');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('17', '11', 'run a 5k', 'mmaffinig', 'F', 'Increased bench press by 20 lbs', 'spin class', '2014-08-26');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('26', '8', 'lose 10 pounds', 'zwaszkiewiczp', 'M', 'Lost 10 lbs', 'cardio', '2012-11-07');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('27', '7', 'attend gym 3 times a week', 'scabenaq', 'F', 'Ran a 5k', 'weightlifting', '2010-06-01');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('41', '4', 'attend gym 3 times a week', 'jarnaldy14', 'M', 'Ran a 5k', 'yoga', '2015-05-12');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('7', '39', 'run a 5k', 'alyddyard6', 'F', 'Ran a 5k', 'spin class', '2018-08-06');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('18', '26', 'run a 5k', 'tdinkinh', 'M', 'Ran a 5k', 'crossfit', '2013-06-10');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('19', '2', 'complete a fitness challenge', 'rchalcrofti', 'F', 'Lost 10 lbs', 'weightlifting', '2011-12-26');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('5', '38', 'lose 10 pounds', 'mvarren4', 'F', 'Attended 50 classes', 'cardio', '2018-09-15');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('35', '9', 'increase bench press by 20 lbs', 'lhanrotty', 'F', 'Lost 10 lbs', 'spin class', '2012-06-23');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('3', '15', 'attend gym 3 times a week', 'epetrashov2', 'F', 'Lost 10 lbs', 'crossfit', '2020-08-18');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('39', '37', 'lose 10 pounds', 'jespinel12', 'F', 'Lost 10 lbs', 'weightlifting', '2011-03-19');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('1', '12', 'increase bench press by 20 lbs', 'bblatchford0', 'F', 'Attended 50 classes', 'yoga', '2013-08-13');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('31', '24', 'increase bench press by 20 lbs', 'lwaddupu', 'M', 'Achieved personal best in deadlift', 'crossfit', '2015-06-19');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('40', '5', 'run a 5k', 'ezoren13', 'F', 'Lost 10 lbs', 'cardio', '2020-11-11');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('30', '30', 'attend gym 3 times a week', 'rimlawt', 'F', 'Increased bench press by 20 lbs', 'yoga', '2018-01-03');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('4', '21', 'complete a fitness challenge', 'cmaltster3', 'M', 'Lost 10 lbs', 'yoga', '2021-01-29');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('16', '35', 'run a 5k', 'aoswalf', 'F', 'Attended 50 classes', 'cardio', '2011-03-20');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('38', '18', 'increase bench press by 20 lbs', 'bfitch11', 'F', 'Lost 10 lbs', 'cardio', '2014-08-26');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('8', '31', 'lose 10 pounds', 'lfieldstone7', 'F', 'Increased bench press by 20 lbs', 'crossfit', '2015-12-17');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('32', '41', 'lose 10 pounds', 'dbraniganv', 'F', 'Ran a 5k', 'spin class', '2010-08-12');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('10', '19', 'lose 10 pounds', 'kswitland9', 'M', 'Achieved personal best in deadlift', 'crossfit', '2021-03-19');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('34', '27', 'attend gym 3 times a week', 'joneilx', 'M', 'Attended 50 classes', 'crossfit', '2020-01-17');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('22', '17', 'run a 5k', 'rstuckesl', 'M', 'Increased bench press by 20 lbs', 'weightlifting', '2019-10-17');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('2', '13', 'lose 10 pounds', 'fvockings1', 'F', 'Achieved personal best in deadlift', 'yoga', '2020-10-08');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('29', '1', 'complete a fitness challenge', 'cpepineauxs', 'F', 'Ran a 5k', 'cardio', '2017-09-25');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('14', '33', 'lose 10 pounds', 'xmilvarnied', 'F', 'Lost 10 lbs', 'cardio', '2018-05-04');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('37', '36', 'run a 5k', 'kping10', 'F', 'Lost 10 lbs', 'cardio', '2015-10-23');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('9', '10', 'complete a fitness challenge', 'dhewson8', 'M', 'Lost 10 lbs', 'cardio', '2013-08-10');
insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, Username, Gender, Achievements, Preferences, Membership_Start_Date) values ('13', '40', 'run a 5k', 'jmacmoyerc', 'M', 'Achieved personal best in deadlift', 'cardio', '2012-11-19');



insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (1, '33', '2023-10-30', 'Monday: Cardio');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (2, '1', '2023-10-19', 'Friday: Yoga');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (3, '22', '2023-12-02', 'Friday: Yoga');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (4, '39', '2024-03-04', 'Saturday: Zumba');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (5, '21', '2023-12-14', 'Friday: Yoga');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (6, '13', '2024-02-28', 'Saturday: Zumba');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (7, '12', '2023-12-28', 'Wednesday: Weightlifting');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (8, '7', '2024-04-01', 'Friday: Yoga');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (9, '8', '2023-07-16', 'Saturday: Zumba');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (10, '37', '2023-12-04', 'Monday: Cardio');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (11, '16', '2023-11-29', 'Monday: Cardio');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (12, '24', '2023-10-02', 'Saturday: Zumba');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (13, '3', '2023-07-13', 'Monday: Cardio');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (14, '18', '2024-01-09', 'Friday: Yoga');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (15, '6', '2023-06-06', 'Friday: Yoga');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (16, '2', '2024-04-08', 'Wednesday: Weightlifting');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (17, '31', '2023-05-27', 'Monday: Cardio');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (18, '26', '2023-10-15', 'Friday: Yoga');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (19, '4', '2024-04-17', 'Friday: Yoga');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (20, '11', '2024-04-09', 'Monday: Cardio');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (21, '14', '2023-04-23', 'Wednesday: Weightlifting');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (22, '28', '2023-06-16', 'Saturday: Zumba');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (23, '30', '2024-02-07', 'Friday: Yoga');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (24, '15', '2023-07-23', 'Wednesday: Weightlifting');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (25, '27', '2023-11-16', 'Wednesday: Weightlifting');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (26, '40', '2023-08-23', 'Saturday: Zumba');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (27, '35', '2023-09-05', 'Friday: Yoga');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (28, '32', '2023-08-17', 'Monday: Cardio');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (29, '9', '2023-12-02', 'Friday: Yoga');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (30, '38', '2024-03-20', 'Wednesday: Weightlifting');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (31, '34', '2023-08-21', 'Wednesday: Weightlifting');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (32, '10', '2023-12-14', 'Friday: Yoga');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (33, '19', '2024-03-01', 'Wednesday: Weightlifting');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (34, '5', '2023-06-17', 'Monday: Cardio');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (35, '25', '2023-11-11', 'Saturday: Zumba');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (36, '17', '2023-04-29', 'Wednesday: Weightlifting');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (37, '23', '2023-07-04', 'Saturday: Zumba');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (38, '36', '2023-10-24', 'Saturday: Zumba');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (39, '41', '2023-05-24', 'Wednesday: Weightlifting');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (40, '20', '2023-07-01', 'Wednesday: Weightlifting');
insert into Reminder (Reminder_ID, Member_ID, Time_Sent, Message) values (41, '29', '2023-07-30', 'Friday: Yoga');


insert into Connect_Platform_Friends (Friends, Member_ID) values ('Ivy', '1');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Ivy', '14');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Bob', '29');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Frank', '37');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Eve', '28');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Frank', '12');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Eve', '20');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Eve', '25');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Charlie', '34');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Grace', '33');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Jack', '19');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('David', '13');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('David', '35');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Grace', '26');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Henry', '2');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Henry', '36');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Alice', '4');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Charlie', '6');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Ivy', '27');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Jack', '17');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Alice', '31');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Ivy', '21');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Grace', '30');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Bob', '18');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Henry', '23');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Ivy', '11');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Eve', '24');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Ivy', '7');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Henry', '10');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Jack', '38');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Henry', '8');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Frank', '40');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Grace', '16');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Grace', '3');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('David', '5');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Bob', '9');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Grace', '22');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Henry', '15');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Eve', '32');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Frank', '39');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Frank', '14');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Henry', '13');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Alice', '19');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Frank', '34');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Eve', '8');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Frank', '4');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Ivy', '18');
insert into Connect_Platform_Friends (Friends, Member_ID) values ('Bob', '33');


insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('38', '3');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('13', '30');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('25', '14');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('39', '37');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('9', '28');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('1', '5');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('31', '27');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('16', '16');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('15', '9');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('20', '20');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('41', '40');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('19', '35');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('34', '13');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('17', '10');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('35', '25');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('5', '17');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('8', '29');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('24', '39');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('21', '31');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('29', '19');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('18', '15');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('32', '33');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('26', '22');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('36', '7');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('7', '32');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('37', '6');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('14', '4');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('10', '36');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('33', '39');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('4', '1');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('3', '26');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('30', '23');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('40', '21');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('23', '18');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('11', '2');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('22', '11');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('12', '34');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('6', '12');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('27', '41');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('28', '24');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('2', '8');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('19', '21');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('29', '29');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('3', '33');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('21', '25');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('32', '35');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('41', '30');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('13', '23');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('31', '9');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('37', '19');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('40', '13');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('10', '7');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('4', '28');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('1', '27');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('23', '14');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('39', '31');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('28', '17');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('8', '18');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('5', '12');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('36', '37');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('20', '26');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('24', '15');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('33', '38');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('9', '41');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('14', '36');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('22', '2');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('25', '6');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('15', '11');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('30', '20');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('26', '24');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('38', '40');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('2', '3');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('11', '32');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('18', '1');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('34', '10');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('35', '8');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('16', '16');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('27', '34');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('17', '22');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('12', '39');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('6', '4');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('7', '5');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('34', '18');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('24', '27');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('40', '8');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('17', '29');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('7', '32');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('33', '14');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('2', '23');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('9', '24');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('18', '5');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('8', '28');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('35', '35');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('6', '34');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('38', '21');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('22', '11');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('27', '30');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('19', '10');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('10', '12');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('41', '2');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('25', '40');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('30', '16');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('20', '33');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('14', '9');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('16', '15');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('12', '3');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('15', '37');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('37', '13');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('32', '39');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('29', '7');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('31', '41');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('13', '22');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('3', '36');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('4', '17');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('21', '25');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('23', '38');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('28', '26');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('5', '31');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('11', '1');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('26', '4');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('39', '6');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('1', '19');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('36', '20');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('36', '40');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('32', '11');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('26', '7');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('40', '24');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('29', '19');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('31', '33');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('5', '18');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('28', '10');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('23', '30');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('16', '39');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('2', '28');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('41', '29');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('22', '32');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('34', '38');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('4', '12');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('13', '17');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('25', '1');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('19', '13');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('1', '14');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('12', '41');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('18', '16');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('9', '25');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('10', '15');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('6', '4');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('15', '21');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('17', '31');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('3', '27');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('11', '5');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('38', '22');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('33', '26');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('30', '34');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('14', '6');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('39', '8');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('35', '23');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('24', '35');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('37', '36');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('20', '37');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('8', '2');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('27', '3');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('21', '9');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('7', '20');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('13', '14');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('24', '29');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('17', '40');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('41', '6');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('16', '11');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('2', '4');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('18', '2');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('39', '24');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('5', '33');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('30', '36');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('12', '5');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('8', '37');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('6', '30');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('35', '32');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('11', '16');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('9', '21');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('27', '31');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('1', '23');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('29', '13');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('33', '39');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('20', '3');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('3', '38');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('38', '35');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('40', '22');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('21', '12');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('26', '27');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('22', '18');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('7', '10');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('34', '25');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('10', '8');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('19', '34');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('4', '17');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('28', '41');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('37', '1');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('15', '28');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('31', '26');
insert into Member_Workout_Plan (Member_ID, Plan_ID) values ('25', '9');


insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('3', '39', '2023-08-11', 'On Hold', 153.2);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('19', '40', '2023-06-07', 'Not Started', 75.02);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('2', '19', '2023-04-27', 'Not Started', 285.02);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('12', '32', '2023-09-26', 'On Hold', 105.78);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('22', '13', '2023-06-10', 'Completed', 92.92);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('24', '31', '2024-03-16', 'Completed', 197.76);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('15', '23', '2023-06-29', 'Not Started', 265.95);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('35', '12', '2023-09-16', 'Completed', 193.28);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('6', '28', '2024-03-23', 'On Hold', 124.42);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('30', '14', '2024-01-28', 'Not Started', 223.43);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('16', '33', '2023-09-15', 'In Progress', 127.86);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('36', '15', '2023-08-13', 'On Hold', 112.75);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('21', '7', '2023-11-01', 'Not Started', 172.39);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('20', '8', '2024-03-07', 'In Progress', 211.93);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('39', '22', '2024-03-08', 'Not Started', 137.17);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('14', '34', '2023-06-24', 'Not Started', 284.67);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('38', '5', '2023-05-21', 'In Progress', 217.33);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('13', '9', '2024-03-23', 'Not Started', 164.36);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('18', '2', '2023-11-11', 'On Hold', 56.81);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('32', '35', '2024-04-11', 'Not Started', 268.11);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('8', '18', '2023-11-01', 'Completed', 130.3);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('27', '38', '2023-07-04', 'Completed', 277.93);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('41', '20', '2023-06-30', 'Not Started', 204.2);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('1', '1', '2023-10-28', 'On Hold', 177.32);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('5', '6', '2023-05-27', 'Completed', 167.33);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('26', '37', '2024-02-01', 'On Hold', 85.4);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('33', '4', '2023-09-25', 'Not Started', 119.02);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('25', '29', '2023-08-31', 'On Hold', 144.86);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('23', '17', '2023-12-16', 'Completed', 297.2);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('29', '3', '2023-06-02', 'Completed', 292.5);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('11', '25', '2023-08-01', 'Not Started', 226.25);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('28', '41', '2024-01-17', 'On Hold', 261.28);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('10', '30', '2024-01-09', 'Not Started', 195.5);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('4', '16', '2024-01-12', 'In Progress', 95.03);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('37', '21', '2023-12-16', 'Completed', 248.99);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('34', '24', '2023-09-09', 'Completed', 169.02);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('9', '26', '2024-02-21', 'In Progress', 286.54);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('31', '10', '2023-06-13', 'Completed', 239.34);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('17', '27', '2023-06-14', 'Completed', 182.34);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('7', '36', '2024-01-01', 'Completed', 101.57);
insert into Progress_Tracker (Plan_ID, Member_ID, Date, Achievements, Weight) values ('40', '11', '2023-10-04', 'On Hold', 280.52);


insert into Member_Reminder (Reminder_ID, Member_ID) values ('20', '14');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('24', '9');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('32', '7');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('41', '23');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('7', '10');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('23', '31');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('13', '5');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('35', '6');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('27', '28');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('25', '39');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('5', '29');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('6', '25');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('34', '37');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('18', '3');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('36', '34');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('12', '15');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('4', '41');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('16', '22');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('37', '40');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('9', '13');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('22', '32');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('19', '2');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('8', '11');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('33', '33');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('15', '27');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('30', '18');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('39', '1');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('10', '8');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('28', '30');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('26', '26');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('3', '21');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('38', '12');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('1', '17');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('40', '16');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('11', '20');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('31', '35');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('14', '4');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('17', '19');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('2', '38');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('29', '24');
insert into Member_Reminder (Reminder_ID, Member_ID) values ('21', '36');



insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('6', '16', '2024-01-13', '1-2 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('31', '29', '2023-10-19', 'daily');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('27', '21', '2024-02-03', 'daily');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('30', '15', '2023-10-28', '1-2 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('17', '36', '2024-03-11', '5-6 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('29', '18', '2024-04-17', '5-6 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('1', '30', '2024-04-12', 'daily');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('28', '24', '2023-10-04', '5-6 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('16', '19', '2023-11-18', 'daily');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('25', '3', '2023-05-07', '1-2 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('40', '22', '2024-01-03', '5-6 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('13', '23', '2023-09-04', '3-4 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('32', '35', '2023-06-25', '5-6 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('34', '7', '2024-03-27', 'daily');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('36', '13', '2024-02-14', 'daily');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('39', '4', '2023-11-01', 'daily');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('9', '1', '2023-05-30', '1-2 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('12', '11', '2023-11-01', '3-4 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('20', '8', '2023-07-01', '5-6 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('10', '33', '2023-05-30', '3-4 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('33', '41', '2023-08-22', '3-4 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('4', '9', '2023-12-23', 'daily');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('2', '32', '2023-12-02', '5-6 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('38', '39', '2024-04-09', '3-4 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('22', '12', '2024-01-15', '5-6 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('14', '37', '2023-09-11', '3-4 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('23', '26', '2024-04-17', '1-2 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('41', '38', '2023-12-04', 'daily');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('37', '2', '2024-02-17', '1-2 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('7', '14', '2023-08-24', '5-6 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('5', '28', '2023-09-03', '3-4 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('26', '10', '2023-07-12', 'daily');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('8', '20', '2024-04-02', '5-6 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('24', '25', '2023-05-30', '3-4 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('18', '6', '2024-03-01', '5-6 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('19', '27', '2024-02-18', '5-6 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('15', '40', '2023-09-20', '1-2 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('11', '34', '2024-02-26', '1-2 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('35', '5', '2024-02-10', '1-2 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('3', '31', '2024-01-22', '5-6 times per week');
insert into Attendance (Member_ID, Gym_ID, Date, Workout_Freq) values ('21', '17', '2023-09-16', '1-2 times per week');

insert into Records (Member_ID, Gym_ID, Date) values ('21', '31', '2023-08-29');
insert into Records (Member_ID, Gym_ID, Date) values ('38', '30', '2023-05-11');
insert into Records (Member_ID, Gym_ID, Date) values ('18', '38', '2024-02-28');
insert into Records (Member_ID, Gym_ID, Date) values ('29', '36', '2024-02-29');
insert into Records (Member_ID, Gym_ID, Date) values ('31', '24', '2023-06-03');
insert into Records (Member_ID, Gym_ID, Date) values ('6', '22', '2023-05-30');
insert into Records (Member_ID, Gym_ID, Date) values ('39', '33', '2023-06-08');
insert into Records (Member_ID, Gym_ID, Date) values ('17', '15', '2023-05-18');
insert into Records (Member_ID, Gym_ID, Date) values ('14', '4', '2023-09-22');
insert into Records (Member_ID, Gym_ID, Date) values ('9', '8', '2023-06-14');
insert into Records (Member_ID, Gym_ID, Date) values ('19', '35', '2023-10-24');
insert into Records (Member_ID, Gym_ID, Date) values ('2', '20', '2023-04-25');
insert into Records (Member_ID, Gym_ID, Date) values ('34', '18', '2023-09-22');
insert into Records (Member_ID, Gym_ID, Date) values ('32', '34', '2024-03-01');
insert into Records (Member_ID, Gym_ID, Date) values ('36', '14', '2023-05-03');
insert into Records (Member_ID, Gym_ID, Date) values ('20', '25', '2024-01-25');
insert into Records (Member_ID, Gym_ID, Date) values ('10', '13', '2023-06-09');
insert into Records (Member_ID, Gym_ID, Date) values ('27', '16', '2023-11-09');
insert into Records (Member_ID, Gym_ID, Date) values ('23', '6', '2024-02-13');
insert into Records (Member_ID, Gym_ID, Date) values ('1', '5', '2023-08-22');
insert into Records (Member_ID, Gym_ID, Date) values ('4', '11', '2024-04-02');
insert into Records (Member_ID, Gym_ID, Date) values ('5', '7', '2024-02-03');
insert into Records (Member_ID, Gym_ID, Date) values ('33', '9', '2024-03-11');
insert into Records (Member_ID, Gym_ID, Date) values ('11', '27', '2023-08-24');
insert into Records (Member_ID, Gym_ID, Date) values ('30', '39', '2024-03-16');
insert into Records (Member_ID, Gym_ID, Date) values ('3', '21', '2023-10-11');
insert into Records (Member_ID, Gym_ID, Date) values ('25', '19', '2023-06-01');
insert into Records (Member_ID, Gym_ID, Date) values ('15', '10', '2023-07-15');
insert into Records (Member_ID, Gym_ID, Date) values ('28', '17', '2023-06-09');
insert into Records (Member_ID, Gym_ID, Date) values ('35', '40', '2023-12-07');
insert into Records (Member_ID, Gym_ID, Date) values ('41', '26', '2024-02-21');
insert into Records (Member_ID, Gym_ID, Date) values ('40', '1', '2023-08-29');
insert into Records (Member_ID, Gym_ID, Date) values ('26', '23', '2024-03-16');
insert into Records (Member_ID, Gym_ID, Date) values ('16', '12', '2023-10-28');
insert into Records (Member_ID, Gym_ID, Date) values ('22', '41', '2023-12-29');
insert into Records (Member_ID, Gym_ID, Date) values ('24', '32', '2023-06-07');
insert into Records (Member_ID, Gym_ID, Date) values ('13', '2', '2024-03-02');
insert into Records (Member_ID, Gym_ID, Date) values ('7', '28', '2023-07-29');
insert into Records (Member_ID, Gym_ID, Date) values ('8', '29', '2023-11-07');
insert into Records (Member_ID, Gym_ID, Date) values ('37', '37', '2023-09-19');
insert into Records (Member_ID, Gym_ID, Date) values ('12', '3', '2023-07-02');
insert into Records (Member_ID, Gym_ID, Date) values ('15', '12', '2024-03-13');
insert into Records (Member_ID, Gym_ID, Date) values ('30', '25', '2023-09-27');
insert into Records (Member_ID, Gym_ID, Date) values ('4', '16', '2023-10-09');
insert into Records (Member_ID, Gym_ID, Date) values ('28', '11', '2023-08-17');
insert into Records (Member_ID, Gym_ID, Date) values ('2', '36', '2023-10-18');
insert into Records (Member_ID, Gym_ID, Date) values ('6', '31', '2023-10-01');
insert into Records (Member_ID, Gym_ID, Date) values ('34', '33', '2023-12-29');
insert into Records (Member_ID, Gym_ID, Date) values ('12', '4', '2023-07-06');
insert into Records (Member_ID, Gym_ID, Date) values ('25', '15', '2024-02-14');
insert into Records (Member_ID, Gym_ID, Date) values ('11', '18', '2023-07-26');
insert into Records (Member_ID, Gym_ID, Date) values ('33', '27', '2023-04-25');
insert into Records (Member_ID, Gym_ID, Date) values ('13', '23', '2023-11-15');
insert into Records (Member_ID, Gym_ID, Date) values ('38', '10', '2023-05-19');
insert into Records (Member_ID, Gym_ID, Date) values ('7', '8', '2023-08-02');
insert into Records (Member_ID, Gym_ID, Date) values ('18', '38', '2023-10-26');
insert into Records (Member_ID, Gym_ID, Date) values ('27', '6', '2023-05-03');
insert into Records (Member_ID, Gym_ID, Date) values ('41', '14', '2023-10-29');
insert into Records (Member_ID, Gym_ID, Date) values ('5', '19', '2023-08-03');
insert into Records (Member_ID, Gym_ID, Date) values ('31', '2', '2023-09-09');
insert into Records (Member_ID, Gym_ID, Date) values ('1', '22', '2023-08-08');
insert into Records (Member_ID, Gym_ID, Date) values ('32', '41', '2023-10-14');
insert into Records (Member_ID, Gym_ID, Date) values ('40', '21', '2023-05-30');
insert into Records (Member_ID, Gym_ID, Date) values ('10', '30', '2024-03-27');
insert into Records (Member_ID, Gym_ID, Date) values ('19', '39', '2023-12-14');
insert into Records (Member_ID, Gym_ID, Date) values ('37', '29', '2023-08-18');
insert into Records (Member_ID, Gym_ID, Date) values ('26', '1', '2023-07-01');
insert into Records (Member_ID, Gym_ID, Date) values ('39', '40', '2023-10-19');
insert into Records (Member_ID, Gym_ID, Date) values ('35', '26', '2024-04-17');
insert into Records (Member_ID, Gym_ID, Date) values ('16', '28', '2023-08-07');
insert into Records (Member_ID, Gym_ID, Date) values ('22', '20', '2024-03-22');
insert into Records (Member_ID, Gym_ID, Date) values ('17', '9', '2024-04-07');
insert into Records (Member_ID, Gym_ID, Date) values ('23', '17', '2023-07-18');
insert into Records (Member_ID, Gym_ID, Date) values ('21', '24', '2024-02-26');
insert into Records (Member_ID, Gym_ID, Date) values ('20', '7', '2024-04-05');
insert into Records (Member_ID, Gym_ID, Date) values ('9', '3', '2024-01-29');
insert into Records (Member_ID, Gym_ID, Date) values ('8', '32', '2024-04-06');
insert into Records (Member_ID, Gym_ID, Date) values ('3', '13', '2023-11-17');
insert into Records (Member_ID, Gym_ID, Date) values ('29', '34', '2024-02-09');
insert into Records (Member_ID, Gym_ID, Date) values ('24', '37', '2024-01-16');
insert into Records (Member_ID, Gym_ID, Date) values ('36', '5', '2024-02-12');
insert into Records (Member_ID, Gym_ID, Date) values ('14', '35', '2023-07-06');
insert into Records (Member_ID, Gym_ID, Date) values ('32', '30', '2023-08-25');
insert into Records (Member_ID, Gym_ID, Date) values ('14', '36', '2023-10-14');
insert into Records (Member_ID, Gym_ID, Date) values ('9', '33', '2023-12-08');
insert into Records (Member_ID, Gym_ID, Date) values ('26', '25', '2023-06-05');
insert into Records (Member_ID, Gym_ID, Date) values ('15', '40', '2023-12-11');
insert into Records (Member_ID, Gym_ID, Date) values ('24', '19', '2023-10-25');
insert into Records (Member_ID, Gym_ID, Date) values ('29', '12', '2023-12-21');
insert into Records (Member_ID, Gym_ID, Date) values ('22', '10', '2024-03-08');
insert into Records (Member_ID, Gym_ID, Date) values ('37', '4', '2024-01-20');
insert into Records (Member_ID, Gym_ID, Date) values ('20', '18', '2023-08-28');
insert into Records (Member_ID, Gym_ID, Date) values ('23', '38', '2024-03-26');
insert into Records (Member_ID, Gym_ID, Date) values ('36', '21', '2023-05-19');
insert into Records (Member_ID, Gym_ID, Date) values ('28', '6', '2023-06-02');
insert into Records (Member_ID, Gym_ID, Date) values ('21', '31', '2023-11-20');
insert into Records (Member_ID, Gym_ID, Date) values ('5', '41', '2023-11-26');
insert into Records (Member_ID, Gym_ID, Date) values ('7', '20', '2023-12-15');
insert into Records (Member_ID, Gym_ID, Date) values ('2', '11', '2024-03-02');
insert into Records (Member_ID, Gym_ID, Date) values ('6', '29', '2023-05-01');
insert into Records (Member_ID, Gym_ID, Date) values ('16', '22', '2024-03-14');
insert into Records (Member_ID, Gym_ID, Date) values ('31', '28', '2023-11-17');
insert into Records (Member_ID, Gym_ID, Date) values ('33', '15', '2023-08-13');
insert into Records (Member_ID, Gym_ID, Date) values ('17', '3', '2024-03-17');
insert into Records (Member_ID, Gym_ID, Date) values ('40', '16', '2024-01-11');
insert into Records (Member_ID, Gym_ID, Date) values ('3', '35', '2024-03-27');
insert into Records (Member_ID, Gym_ID, Date) values ('34', '27', '2023-06-19');
insert into Records (Member_ID, Gym_ID, Date) values ('25', '26', '2023-11-29');
insert into Records (Member_ID, Gym_ID, Date) values ('1', '9', '2023-12-06');
insert into Records (Member_ID, Gym_ID, Date) values ('13', '5', '2023-10-12');
insert into Records (Member_ID, Gym_ID, Date) values ('10', '17', '2023-12-20');
insert into Records (Member_ID, Gym_ID, Date) values ('30', '24', '2023-06-16');
insert into Records (Member_ID, Gym_ID, Date) values ('27', '7', '2023-08-06');
insert into Records (Member_ID, Gym_ID, Date) values ('18', '32', '2023-10-14');
insert into Records (Member_ID, Gym_ID, Date) values ('12', '39', '2024-03-08');
insert into Records (Member_ID, Gym_ID, Date) values ('4', '14', '2023-05-12');
insert into Records (Member_ID, Gym_ID, Date) values ('8', '34', '2023-11-01');
insert into Records (Member_ID, Gym_ID, Date) values ('39', '37', '2023-07-21');
insert into Records (Member_ID, Gym_ID, Date) values ('41', '13', '2024-01-07');
insert into Records (Member_ID, Gym_ID, Date) values ('19', '1', '2023-06-12');
insert into Records (Member_ID, Gym_ID, Date) values ('11', '2', '2023-10-25');
insert into Records (Member_ID, Gym_ID, Date) values ('38', '23', '2023-08-14');
insert into Records (Member_ID, Gym_ID, Date) values ('35', '8', '2024-01-02');
insert into Records (Member_ID, Gym_ID, Date) values ('41', '28', '2023-06-22');
insert into Records (Member_ID, Gym_ID, Date) values ('20', '12', '2024-01-24');
insert into Records (Member_ID, Gym_ID, Date) values ('29', '21', '2023-12-02');
insert into Records (Member_ID, Gym_ID, Date) values ('16', '6', '2023-07-19');
insert into Records (Member_ID, Gym_ID, Date) values ('33', '39', '2023-10-03');
insert into Records (Member_ID, Gym_ID, Date) values ('11', '26', '2023-12-15');
insert into Records (Member_ID, Gym_ID, Date) values ('38', '37', '2023-08-05');
insert into Records (Member_ID, Gym_ID, Date) values ('7', '7', '2023-07-02');
insert into Records (Member_ID, Gym_ID, Date) values ('13', '9', '2023-11-23');
insert into Records (Member_ID, Gym_ID, Date) values ('9', '24', '2023-10-03');
insert into Records (Member_ID, Gym_ID, Date) values ('5', '36', '2023-12-04');
insert into Records (Member_ID, Gym_ID, Date) values ('12', '19', '2023-05-12');
insert into Records (Member_ID, Gym_ID, Date) values ('24', '3', '2024-04-10');
insert into Records (Member_ID, Gym_ID, Date) values ('14', '8', '2023-10-19');
insert into Records (Member_ID, Gym_ID, Date) values ('3', '32', '2024-01-09');
insert into Records (Member_ID, Gym_ID, Date) values ('40', '16', '2023-10-22');
insert into Records (Member_ID, Gym_ID, Date) values ('34', '18', '2023-11-28');
insert into Records (Member_ID, Gym_ID, Date) values ('19', '22', '2023-10-21');
insert into Records (Member_ID, Gym_ID, Date) values ('32', '2', '2024-04-05');
insert into Records (Member_ID, Gym_ID, Date) values ('4', '5', '2023-12-12');
insert into Records (Member_ID, Gym_ID, Date) values ('39', '34', '2023-12-28');
insert into Records (Member_ID, Gym_ID, Date) values ('18', '10', '2024-03-24');
insert into Records (Member_ID, Gym_ID, Date) values ('1', '20', '2023-12-06');
insert into Records (Member_ID, Gym_ID, Date) values ('22', '14', '2023-05-07');
insert into Records (Member_ID, Gym_ID, Date) values ('30', '13', '2023-12-31');
insert into Records (Member_ID, Gym_ID, Date) values ('2', '31', '2023-06-05');
insert into Records (Member_ID, Gym_ID, Date) values ('10', '41', '2024-01-10');
insert into Records (Member_ID, Gym_ID, Date) values ('8', '40', '2023-05-08');
insert into Records (Member_ID, Gym_ID, Date) values ('25', '23', '2024-01-17');
insert into Records (Member_ID, Gym_ID, Date) values ('28', '35', '2024-03-23');
insert into Records (Member_ID, Gym_ID, Date) values ('35', '15', '2023-11-01');
insert into Records (Member_ID, Gym_ID, Date) values ('26', '4', '2023-07-02');
insert into Records (Member_ID, Gym_ID, Date) values ('37', '33', '2023-09-25');
insert into Records (Member_ID, Gym_ID, Date) values ('23', '30', '2023-11-14');
insert into Records (Member_ID, Gym_ID, Date) values ('15', '17', '2024-01-08');
insert into Records (Member_ID, Gym_ID, Date) values ('21', '27', '2023-10-17');
insert into Records (Member_ID, Gym_ID, Date) values ('31', '11', '2023-06-02');
insert into Records (Member_ID, Gym_ID, Date) values ('17', '25', '2024-03-25');
insert into Records (Member_ID, Gym_ID, Date) values ('6', '1', '2023-07-18');
insert into Records (Member_ID, Gym_ID, Date) values ('36', '29', '2024-04-04');
insert into Records (Member_ID, Gym_ID, Date) values ('27', '38', '2024-03-15');
insert into Records (Member_ID, Gym_ID, Date) values ('40', '12', '2023-11-06');
insert into Records (Member_ID, Gym_ID, Date) values ('9', '33', '2023-04-27');
insert into Records (Member_ID, Gym_ID, Date) values ('28', '6', '2024-04-09');
insert into Records (Member_ID, Gym_ID, Date) values ('26', '23', '2023-10-20');
insert into Records (Member_ID, Gym_ID, Date) values ('33', '41', '2024-02-18');
insert into Records (Member_ID, Gym_ID, Date) values ('16', '29', '2023-06-26');
insert into Records (Member_ID, Gym_ID, Date) values ('1', '30', '2023-09-27');
insert into Records (Member_ID, Gym_ID, Date) values ('8', '28', '2023-07-02');
insert into Records (Member_ID, Gym_ID, Date) values ('32', '35', '2023-05-17');
insert into Records (Member_ID, Gym_ID, Date) values ('19', '5', '2024-01-20');
insert into Records (Member_ID, Gym_ID, Date) values ('24', '37', '2023-06-07');
insert into Records (Member_ID, Gym_ID, Date) values ('25', '15', '2023-09-27');
insert into Records (Member_ID, Gym_ID, Date) values ('7', '31', '2023-11-14');
insert into Records (Member_ID, Gym_ID, Date) values ('18', '13', '2024-03-20');
insert into Records (Member_ID, Gym_ID, Date) values ('21', '40', '2023-05-12');
insert into Records (Member_ID, Gym_ID, Date) values ('17', '22', '2024-03-01');
insert into Records (Member_ID, Gym_ID, Date) values ('30', '36', '2023-07-24');
insert into Records (Member_ID, Gym_ID, Date) values ('35', '3', '2023-05-10');
insert into Records (Member_ID, Gym_ID, Date) values ('10', '20', '2024-02-04');
insert into Records (Member_ID, Gym_ID, Date) values ('29', '16', '2023-12-09');
insert into Records (Member_ID, Gym_ID, Date) values ('20', '14', '2023-10-23');
insert into Records (Member_ID, Gym_ID, Date) values ('27', '21', '2023-08-26');
insert into Records (Member_ID, Gym_ID, Date) values ('36', '39', '2023-07-11');
insert into Records (Member_ID, Gym_ID, Date) values ('15', '34', '2024-03-03');
insert into Records (Member_ID, Gym_ID, Date) values ('4', '7', '2023-06-15');
insert into Records (Member_ID, Gym_ID, Date) values ('13', '10', '2023-05-02');
insert into Records (Member_ID, Gym_ID, Date) values ('31', '8', '2023-12-18');
insert into Records (Member_ID, Gym_ID, Date) values ('39', '17', '2023-11-01');
insert into Records (Member_ID, Gym_ID, Date) values ('41', '32', '2023-05-21');
insert into Records (Member_ID, Gym_ID, Date) values ('12', '18', '2024-03-29');
insert into Records (Member_ID, Gym_ID, Date) values ('3', '2', '2024-03-31');
insert into Records (Member_ID, Gym_ID, Date) values ('6', '24', '2023-12-29');
insert into Records (Member_ID, Gym_ID, Date) values ('11', '4', '2023-11-12');
insert into Records (Member_ID, Gym_ID, Date) values ('38', '38', '2023-06-22');
insert into Records (Member_ID, Gym_ID, Date) values ('37', '1', '2023-07-18');
insert into Records (Member_ID, Gym_ID, Date) values ('5', '27', '2024-01-16');
insert into Records (Member_ID, Gym_ID, Date) values ('2', '11', '2023-10-23');


insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (1, '28', 'Stadium A', '6:38:11.000', '2023-10-31', 'David Lee', 'Zumba Dance Party', 46, 'Fitness Fiesta');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (2, '30', 'Field E', '10:04:11.000', '2023-09-04', 'David Lee', 'Fitness Challenge Kickoff', 58, 'Cardio Craze Party');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (3, '25', 'Field E', '9:51:44.000', '2023-09-02', 'Michael Johnson', 'Yoga Retreat Day', 21, 'Cardio Craze Party');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (4, '29', 'Stadium B', '2:36:35.000 ', '2023-10-22', 'Jane Smith', 'Yoga Retreat Day', 87, 'Sweat & Socialize');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (5, '34', 'Park D', '6:11:43.000 ', '2024-03-13', 'David Lee', 'Zumba Dance Party', 54, 'Strength & Stretch Soiree');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (6, '19', 'Stadium A', '10:40:18.000', '2023-08-23', 'Jane Smith', 'Yoga Retreat Day', 83, 'Cardio Craze Party');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (7, '9', 'Field E', '11:21:05.000', '2023-12-27', 'John Doe', 'Summer BBQ Social', 82, 'Fitness Fiesta');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (8, '7', 'Field E', '2:44:31.000 ', '2023-06-05', 'Michael Johnson', 'Summer BBQ Social', 84, 'Cardio Craze Party');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (9, '3', 'Field E', '4:06:30.000 ', '2023-11-26', 'Jane Smith', 'Yoga Retreat Day', 32, 'Fitness Fiesta');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (10, '39', 'Park D', '11:00:48.000', '2023-08-02', 'Michael Johnson', 'Summer BBQ Social', 100, 'Cardio Craze Party');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (11, '1', 'Stadium A', '7:52:00.000 ', '2023-09-09', 'Michael Johnson', 'Healthy Cooking Workshop', 91, 'Fitness Fiesta');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (12, '14', 'Field E', '4:12:51.000 ', '2023-10-24', 'John Doe', 'Healthy Cooking Workshop', 24, 'Sweat & Socialize');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (13, '15', 'Stadium A', '6:52:15.000 ', '2024-03-29', 'David Lee', 'Zumba Dance Party', 53, 'Muscle Madness Mixer');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (14, '21', 'Stadium A', '4:42:28.000 ', '2024-03-03', 'Emily Brown', 'Zumba Dance Party', 66, 'Muscle Madness Mixer');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (15, '37', 'Field E', '11:04:46.000', '2023-09-27', 'Jane Smith', 'Fitness Challenge Kickoff', 40, 'Muscle Madness Mixer');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (16, '4', 'Stadium A', '11:53:46.000', '2023-10-08', 'John Doe', 'Zumba Dance Party', 43, 'Sweat & Socialize');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (17, '23', 'Park D', '12:31:11.000 ', '2023-07-20', 'Jane Smith', 'Summer BBQ Social', 94, 'Cardio Craze Party');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (18, '38', 'Field E', '1:39:48.000 ', '2023-12-26', 'David Lee', 'Yoga Retreat Day', 48, 'Sweat & Socialize');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (19, '13', 'Stadium A', '11:46:53.000', '2024-02-29', 'Emily Brown', 'Summer BBQ Social', 31, 'Sweat & Socialize');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (20, '8', 'Stadium A', '8:55:49.000 ', '2023-12-21', 'John Doe', 'Yoga Retreat Day', 97, 'Fitness Fiesta');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (21, '41', 'Stadium B', '7:46:32.000 ', '2024-03-09', 'John Doe', 'Yoga Retreat Day', 71, 'Fitness Fiesta');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (22, '22', 'Park D', '9:09:50.000', '2023-11-25', 'John Doe', 'Summer BBQ Social', 100, 'Sweat & Socialize');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (23, '24', 'Stadium C', '9:12:47.000', '2023-05-11', 'Jane Smith', 'Healthy Cooking Workshop', 91, 'Sweat & Socialize');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (24, '33', 'Stadium B', '5:32:26.000 ', '2023-11-28', 'John Doe', 'Healthy Cooking Workshop', 31, 'Muscle Madness Mixer');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (25, '6', 'Park D', '12:34:17.000 ', '2024-02-11', 'David Lee', 'Zumba Dance Party', 68, 'Cardio Craze Party');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (26, '11', 'Stadium B', '2:15:23.000 ', '2024-02-27', 'Emily Brown', 'Zumba Dance Party', 73, 'Strength & Stretch Soiree');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (27, '36', 'Stadium A', '6:44:58.000 ', '2023-11-06', 'John Doe', 'Yoga Retreat Day', 76, 'Fitness Fiesta');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (28, '40', 'Field E', '11:14:19.000', '2023-04-29', 'David Lee', 'Fitness Challenge Kickoff', 46, 'Fitness Fiesta');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (29, '12', 'Stadium A', '7:16:12.000 ', '2024-01-04', 'Michael Johnson', 'Yoga Retreat Day', 47, 'Fitness Fiesta');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (30, '2', 'Park D', '12:27:54.000 ', '2024-02-07', 'David Lee', 'Summer BBQ Social', 76, 'Muscle Madness Mixer');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (31, '32', 'Stadium B', '8:19:45.000 ', '2023-11-05', 'Jane Smith', 'Yoga Retreat Day', 35, 'Strength & Stretch Soiree');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (32, '18', 'Field E', '2:25:05.000 ', '2023-05-15', 'John Doe', 'Fitness Challenge Kickoff', 34, 'Strength & Stretch Soiree');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (33, '26', 'Park D', '12:22:12.000 ', '2023-05-15', 'Michael Johnson', 'Yoga Retreat Day', 35, 'Sweat & Socialize');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (34, '31', 'Park D', '8:48:53.000 ', '2023-12-15', 'Michael Johnson', 'Summer BBQ Social', 24, 'Sweat & Socialize');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (35, '35', 'Stadium A', '10:56:39.000', '2024-03-18', 'John Doe', 'Fitness Challenge Kickoff', 48, 'Fitness Fiesta');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (36, '17', 'Stadium C', '9:29:08.000', '2023-06-05', 'David Lee', 'Zumba Dance Party', 75, 'Cardio Craze Party');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (37, '5', 'Stadium A', '4:32:42.000 ', '2023-05-08', 'Emily Brown', 'Zumba Dance Party', 27, 'Fitness Fiesta');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (38, '20', 'Field E', '8:35:02.000 ', '2023-07-29', 'Emily Brown', 'Yoga Retreat Day', 78, 'Muscle Madness Mixer');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (39, '27', 'Stadium A', '9:54:46.000', '2023-09-26', 'David Lee', 'Fitness Challenge Kickoff', 74, 'Sweat & Socialize');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (40, '10', 'Park D', '5:25:35.000', '2024-02-11', 'David Lee', 'Summer BBQ Social', 65, 'Muscle Madness Mixer');
insert into Social_Events (Event_ID, Gym_ID, Location, Time, Date, Organizer, Description, Attendance_Limit, Event_Name) values (41, '16', 'Field E', '2:58:46.000', '2023-07-14', 'Michael Johnson', 'Healthy Cooking Workshop', 98, 'Muscle Madness Mixer');


insert into Gym_Members (Member_ID, Gym_ID) values ('9', '32');
insert into Gym_Members (Member_ID, Gym_ID) values ('19', '18');
insert into Gym_Members (Member_ID, Gym_ID) values ('15', '35');
insert into Gym_Members (Member_ID, Gym_ID) values ('40', '33');
insert into Gym_Members (Member_ID, Gym_ID) values ('28', '10');
insert into Gym_Members (Member_ID, Gym_ID) values ('33', '38');
insert into Gym_Members (Member_ID, Gym_ID) values ('29', '5');
insert into Gym_Members (Member_ID, Gym_ID) values ('20', '16');
insert into Gym_Members (Member_ID, Gym_ID) values ('3', '22');
insert into Gym_Members (Member_ID, Gym_ID) values ('25', '40');
insert into Gym_Members (Member_ID, Gym_ID) values ('34', '1');
insert into Gym_Members (Member_ID, Gym_ID) values ('5', '34');
insert into Gym_Members (Member_ID, Gym_ID) values ('26', '13');
insert into Gym_Members (Member_ID, Gym_ID) values ('36', '30');
insert into Gym_Members (Member_ID, Gym_ID) values ('16', '6');
insert into Gym_Members (Member_ID, Gym_ID) values ('27', '37');
insert into Gym_Members (Member_ID, Gym_ID) values ('1', '2');
insert into Gym_Members (Member_ID, Gym_ID) values ('13', '9');
insert into Gym_Members (Member_ID, Gym_ID) values ('37', '25');
insert into Gym_Members (Member_ID, Gym_ID) values ('35', '14');
insert into Gym_Members (Member_ID, Gym_ID) values ('22', '8');
insert into Gym_Members (Member_ID, Gym_ID) values ('18', '20');
insert into Gym_Members (Member_ID, Gym_ID) values ('32', '29');
insert into Gym_Members (Member_ID, Gym_ID) values ('23', '17');
insert into Gym_Members (Member_ID, Gym_ID) values ('17', '4');
insert into Gym_Members (Member_ID, Gym_ID) values ('12', '19');
insert into Gym_Members (Member_ID, Gym_ID) values ('8', '28');
insert into Gym_Members (Member_ID, Gym_ID) values ('39', '27');
insert into Gym_Members (Member_ID, Gym_ID) values ('21', '31');
insert into Gym_Members (Member_ID, Gym_ID) values ('24', '23');
insert into Gym_Members (Member_ID, Gym_ID) values ('30', '26');
insert into Gym_Members (Member_ID, Gym_ID) values ('7', '15');
insert into Gym_Members (Member_ID, Gym_ID) values ('11', '39');
insert into Gym_Members (Member_ID, Gym_ID) values ('2', '21');
insert into Gym_Members (Member_ID, Gym_ID) values ('4', '41');
insert into Gym_Members (Member_ID, Gym_ID) values ('38', '12');
insert into Gym_Members (Member_ID, Gym_ID) values ('31', '7');
insert into Gym_Members (Member_ID, Gym_ID) values ('41', '3');
insert into Gym_Members (Member_ID, Gym_ID) values ('6', '24');
insert into Gym_Members (Member_ID, Gym_ID) values ('14', '36');
insert into Gym_Members (Member_ID, Gym_ID) values ('15', '39');
insert into Gym_Members (Member_ID, Gym_ID) values ('7', '5');
insert into Gym_Members (Member_ID, Gym_ID) values ('25', '36');
insert into Gym_Members (Member_ID, Gym_ID) values ('41', '16');
insert into Gym_Members (Member_ID, Gym_ID) values ('37', '3');
insert into Gym_Members (Member_ID, Gym_ID) values ('38', '15');
insert into Gym_Members (Member_ID, Gym_ID) values ('31', '28');
insert into Gym_Members (Member_ID, Gym_ID) values ('21', '41');
insert into Gym_Members (Member_ID, Gym_ID) values ('33', '19');
insert into Gym_Members (Member_ID, Gym_ID) values ('34', '14');
insert into Gym_Members (Member_ID, Gym_ID) values ('13', '7');
insert into Gym_Members (Member_ID, Gym_ID) values ('12', '6');
insert into Gym_Members (Member_ID, Gym_ID) values ('24', '4');
insert into Gym_Members (Member_ID, Gym_ID) values ('19', '35');
insert into Gym_Members (Member_ID, Gym_ID) values ('17', '31');
insert into Gym_Members (Member_ID, Gym_ID) values ('10', '11');
insert into Gym_Members (Member_ID, Gym_ID) values ('14', '34');
insert into Gym_Members (Member_ID, Gym_ID) values ('32', '29');
insert into Gym_Members (Member_ID, Gym_ID) values ('11', '30');
insert into Gym_Members (Member_ID, Gym_ID) values ('40', '8');
insert into Gym_Members (Member_ID, Gym_ID) values ('1', '37');
insert into Gym_Members (Member_ID, Gym_ID) values ('27', '27');
insert into Gym_Members (Member_ID, Gym_ID) values ('39', '23');
insert into Gym_Members (Member_ID, Gym_ID) values ('22', '40');
insert into Gym_Members (Member_ID, Gym_ID) values ('3', '17');
insert into Gym_Members (Member_ID, Gym_ID) values ('26', '25');
insert into Gym_Members (Member_ID, Gym_ID) values ('23', '21');
insert into Gym_Members (Member_ID, Gym_ID) values ('36', '38');
insert into Gym_Members (Member_ID, Gym_ID) values ('5', '32');
insert into Gym_Members (Member_ID, Gym_ID) values ('2', '13');
insert into Gym_Members (Member_ID, Gym_ID) values ('30', '12');
insert into Gym_Members (Member_ID, Gym_ID) values ('29', '20');
insert into Gym_Members (Member_ID, Gym_ID) values ('8', '1');
insert into Gym_Members (Member_ID, Gym_ID) values ('4', '22');
insert into Gym_Members (Member_ID, Gym_ID) values ('16', '33');
insert into Gym_Members (Member_ID, Gym_ID) values ('18', '18');
insert into Gym_Members (Member_ID, Gym_ID) values ('6', '9');
insert into Gym_Members (Member_ID, Gym_ID) values ('28', '24');
insert into Gym_Members (Member_ID, Gym_ID) values ('9', '26');
insert into Gym_Members (Member_ID, Gym_ID) values ('20', '10');
insert into Gym_Members (Member_ID, Gym_ID) values ('35', '2');
insert into Gym_Members (Member_ID, Gym_ID) values ('11', '22');
insert into Gym_Members (Member_ID, Gym_ID) values ('1', '14');
insert into Gym_Members (Member_ID, Gym_ID) values ('38', '30');
insert into Gym_Members (Member_ID, Gym_ID) values ('19', '13');
insert into Gym_Members (Member_ID, Gym_ID) values ('22', '9');
insert into Gym_Members (Member_ID, Gym_ID) values ('23', '3');
insert into Gym_Members (Member_ID, Gym_ID) values ('33', '7');
insert into Gym_Members (Member_ID, Gym_ID) values ('17', '16');
insert into Gym_Members (Member_ID, Gym_ID) values ('2', '18');
insert into Gym_Members (Member_ID, Gym_ID) values ('7', '19');
insert into Gym_Members (Member_ID, Gym_ID) values ('16', '39');
insert into Gym_Members (Member_ID, Gym_ID) values ('3', '11');
insert into Gym_Members (Member_ID, Gym_ID) values ('6', '5');
insert into Gym_Members (Member_ID, Gym_ID) values ('10', '8');
insert into Gym_Members (Member_ID, Gym_ID) values ('24', '2');
insert into Gym_Members (Member_ID, Gym_ID) values ('32', '29');
insert into Gym_Members (Member_ID, Gym_ID) values ('41', '26');
insert into Gym_Members (Member_ID, Gym_ID) values ('20', '15');
insert into Gym_Members (Member_ID, Gym_ID) values ('36', '38');
insert into Gym_Members (Member_ID, Gym_ID) values ('29', '17');
insert into Gym_Members (Member_ID, Gym_ID) values ('14', '20');
insert into Gym_Members (Member_ID, Gym_ID) values ('35', '10');
insert into Gym_Members (Member_ID, Gym_ID) values ('8', '6');
insert into Gym_Members (Member_ID, Gym_ID) values ('25', '25');
insert into Gym_Members (Member_ID, Gym_ID) values ('40', '37');
insert into Gym_Members (Member_ID, Gym_ID) values ('34', '40');
insert into Gym_Members (Member_ID, Gym_ID) values ('28', '21');
insert into Gym_Members (Member_ID, Gym_ID) values ('31', '35');
insert into Gym_Members (Member_ID, Gym_ID) values ('4', '28');
insert into Gym_Members (Member_ID, Gym_ID) values ('9', '1');
insert into Gym_Members (Member_ID, Gym_ID) values ('15', '32');
insert into Gym_Members (Member_ID, Gym_ID) values ('27', '41');
insert into Gym_Members (Member_ID, Gym_ID) values ('37', '27');
insert into Gym_Members (Member_ID, Gym_ID) values ('21', '33');
insert into Gym_Members (Member_ID, Gym_ID) values ('13', '36');
insert into Gym_Members (Member_ID, Gym_ID) values ('39', '34');
insert into Gym_Members (Member_ID, Gym_ID) values ('18', '12');
insert into Gym_Members (Member_ID, Gym_ID) values ('5', '4');
insert into Gym_Members (Member_ID, Gym_ID) values ('26', '23');
insert into Gym_Members (Member_ID, Gym_ID) values ('30', '31');
insert into Gym_Members (Member_ID, Gym_ID) values ('12', '24');
insert into Gym_Members (Member_ID, Gym_ID) values ('31', '23');
insert into Gym_Members (Member_ID, Gym_ID) values ('40', '21');
insert into Gym_Members (Member_ID, Gym_ID) values ('18', '25');
insert into Gym_Members (Member_ID, Gym_ID) values ('4', '30');
insert into Gym_Members (Member_ID, Gym_ID) values ('12', '22');
insert into Gym_Members (Member_ID, Gym_ID) values ('28', '20');
insert into Gym_Members (Member_ID, Gym_ID) values ('13', '19');
insert into Gym_Members (Member_ID, Gym_ID) values ('25', '8');
insert into Gym_Members (Member_ID, Gym_ID) values ('20', '38');
insert into Gym_Members (Member_ID, Gym_ID) values ('33', '28');
insert into Gym_Members (Member_ID, Gym_ID) values ('26', '11');
insert into Gym_Members (Member_ID, Gym_ID) values ('9', '10');
insert into Gym_Members (Member_ID, Gym_ID) values ('35', '1');
insert into Gym_Members (Member_ID, Gym_ID) values ('29', '13');
insert into Gym_Members (Member_ID, Gym_ID) values ('11', '31');
insert into Gym_Members (Member_ID, Gym_ID) values ('32', '32');
insert into Gym_Members (Member_ID, Gym_ID) values ('39', '37');
insert into Gym_Members (Member_ID, Gym_ID) values ('36', '18');
insert into Gym_Members (Member_ID, Gym_ID) values ('17', '17');
insert into Gym_Members (Member_ID, Gym_ID) values ('24', '5');
insert into Gym_Members (Member_ID, Gym_ID) values ('41', '24');
insert into Gym_Members (Member_ID, Gym_ID) values ('15', '9');
insert into Gym_Members (Member_ID, Gym_ID) values ('8', '26');
insert into Gym_Members (Member_ID, Gym_ID) values ('27', '36');
insert into Gym_Members (Member_ID, Gym_ID) values ('3', '27');
insert into Gym_Members (Member_ID, Gym_ID) values ('6', '16');
insert into Gym_Members (Member_ID, Gym_ID) values ('5', '3');
insert into Gym_Members (Member_ID, Gym_ID) values ('2', '33');
insert into Gym_Members (Member_ID, Gym_ID) values ('16', '15');
insert into Gym_Members (Member_ID, Gym_ID) values ('37', '41');
insert into Gym_Members (Member_ID, Gym_ID) values ('30', '34');
insert into Gym_Members (Member_ID, Gym_ID) values ('22', '40');
insert into Gym_Members (Member_ID, Gym_ID) values ('23', '4');
insert into Gym_Members (Member_ID, Gym_ID) values ('10', '12');
insert into Gym_Members (Member_ID, Gym_ID) values ('38', '6');
insert into Gym_Members (Member_ID, Gym_ID) values ('1', '29');
insert into Gym_Members (Member_ID, Gym_ID) values ('7', '7');
insert into Gym_Members (Member_ID, Gym_ID) values ('19', '2');
insert into Gym_Members (Member_ID, Gym_ID) values ('14', '14');
insert into Gym_Members (Member_ID, Gym_ID) values ('34', '35');
insert into Gym_Members (Member_ID, Gym_ID) values ('21', '39');
insert into Gym_Members (Member_ID, Gym_ID) values ('1', '37');
insert into Gym_Members (Member_ID, Gym_ID) values ('28', '4');
insert into Gym_Members (Member_ID, Gym_ID) values ('3', '12');
insert into Gym_Members (Member_ID, Gym_ID) values ('33', '3');
insert into Gym_Members (Member_ID, Gym_ID) values ('9', '39');
insert into Gym_Members (Member_ID, Gym_ID) values ('12', '14');
insert into Gym_Members (Member_ID, Gym_ID) values ('38', '20');
insert into Gym_Members (Member_ID, Gym_ID) values ('5', '33');
insert into Gym_Members (Member_ID, Gym_ID) values ('20', '38');
insert into Gym_Members (Member_ID, Gym_ID) values ('34', '5');
insert into Gym_Members (Member_ID, Gym_ID) values ('35', '30');
insert into Gym_Members (Member_ID, Gym_ID) values ('18', '10');
insert into Gym_Members (Member_ID, Gym_ID) values ('22', '7');
insert into Gym_Members (Member_ID, Gym_ID) values ('39', '29');
insert into Gym_Members (Member_ID, Gym_ID) values ('2', '21');
insert into Gym_Members (Member_ID, Gym_ID) values ('19', '35');
insert into Gym_Members (Member_ID, Gym_ID) values ('21', '28');
insert into Gym_Members (Member_ID, Gym_ID) values ('17', '1');
insert into Gym_Members (Member_ID, Gym_ID) values ('14', '31');
insert into Gym_Members (Member_ID, Gym_ID) values ('37', '25');
insert into Gym_Members (Member_ID, Gym_ID) values ('10', '26');
insert into Gym_Members (Member_ID, Gym_ID) values ('25', '34');
insert into Gym_Members (Member_ID, Gym_ID) values ('13', '9');
insert into Gym_Members (Member_ID, Gym_ID) values ('31', '40');
insert into Gym_Members (Member_ID, Gym_ID) values ('23', '41');
insert into Gym_Members (Member_ID, Gym_ID) values ('26', '17');
insert into Gym_Members (Member_ID, Gym_ID) values ('29', '8');
insert into Gym_Members (Member_ID, Gym_ID) values ('7', '32');
insert into Gym_Members (Member_ID, Gym_ID) values ('27', '23');
insert into Gym_Members (Member_ID, Gym_ID) values ('24', '18');
insert into Gym_Members (Member_ID, Gym_ID) values ('32', '15');
insert into Gym_Members (Member_ID, Gym_ID) values ('36', '24');
insert into Gym_Members (Member_ID, Gym_ID) values ('41', '22');
insert into Gym_Members (Member_ID, Gym_ID) values ('15', '6');
insert into Gym_Members (Member_ID, Gym_ID) values ('30', '27');
insert into Gym_Members (Member_ID, Gym_ID) values ('16', '36');
insert into Gym_Members (Member_ID, Gym_ID) values ('11', '19');


insert into Gym_Events (Gym_ID, Event_ID) values ('29', '41');
insert into Gym_Events (Gym_ID, Event_ID) values ('31', '33');
insert into Gym_Events (Gym_ID, Event_ID) values ('37', '11');
insert into Gym_Events (Gym_ID, Event_ID) values ('36', '13');
insert into Gym_Events (Gym_ID, Event_ID) values ('41', '15');
insert into Gym_Events (Gym_ID, Event_ID) values ('30', '21');
insert into Gym_Events (Gym_ID, Event_ID) values ('21', '22');
insert into Gym_Events (Gym_ID, Event_ID) values ('20', '4');
insert into Gym_Events (Gym_ID, Event_ID) values ('23', '23');
insert into Gym_Events (Gym_ID, Event_ID) values ('24', '20');
insert into Gym_Events (Gym_ID, Event_ID) values ('5', '24');
insert into Gym_Events (Gym_ID, Event_ID) values ('14', '31');
insert into Gym_Events (Gym_ID, Event_ID) values ('11', '32');
insert into Gym_Events (Gym_ID, Event_ID) values ('26', '12');
insert into Gym_Events (Gym_ID, Event_ID) values ('10', '27');
insert into Gym_Events (Gym_ID, Event_ID) values ('32', '25');
insert into Gym_Events (Gym_ID, Event_ID) values ('33', '30');
insert into Gym_Events (Gym_ID, Event_ID) values ('25', '37');
insert into Gym_Events (Gym_ID, Event_ID) values ('19', '1');
insert into Gym_Events (Gym_ID, Event_ID) values ('28', '10');
insert into Gym_Events (Gym_ID, Event_ID) values ('4', '9');
insert into Gym_Events (Gym_ID, Event_ID) values ('40', '17');
insert into Gym_Events (Gym_ID, Event_ID) values ('1', '3');
insert into Gym_Events (Gym_ID, Event_ID) values ('34', '16');
insert into Gym_Events (Gym_ID, Event_ID) values ('27', '40');
insert into Gym_Events (Gym_ID, Event_ID) values ('8', '19');
insert into Gym_Events (Gym_ID, Event_ID) values ('3', '14');
insert into Gym_Events (Gym_ID, Event_ID) values ('6', '38');
insert into Gym_Events (Gym_ID, Event_ID) values ('9', '28');
insert into Gym_Events (Gym_ID, Event_ID) values ('18', '5');
insert into Gym_Events (Gym_ID, Event_ID) values ('22', '35');
insert into Gym_Events (Gym_ID, Event_ID) values ('16', '39');
insert into Gym_Events (Gym_ID, Event_ID) values ('38', '36');
insert into Gym_Events (Gym_ID, Event_ID) values ('39', '2');
insert into Gym_Events (Gym_ID, Event_ID) values ('15', '26');
insert into Gym_Events (Gym_ID, Event_ID) values ('12', '18');
insert into Gym_Events (Gym_ID, Event_ID) values ('2', '8');
insert into Gym_Events (Gym_ID, Event_ID) values ('13', '7');
insert into Gym_Events (Gym_ID, Event_ID) values ('17', '34');
insert into Gym_Events (Gym_ID, Event_ID) values ('35', '29');
insert into Gym_Events (Gym_ID, Event_ID) values ('7', '6');
insert into Gym_Events (Gym_ID, Event_ID) values ('8', '2');
insert into Gym_Events (Gym_ID, Event_ID) values ('30', '34');
insert into Gym_Events (Gym_ID, Event_ID) values ('38', '35');
insert into Gym_Events (Gym_ID, Event_ID) values ('5', '1');
insert into Gym_Events (Gym_ID, Event_ID) values ('21', '16');
insert into Gym_Events (Gym_ID, Event_ID) values ('2', '37');
insert into Gym_Events (Gym_ID, Event_ID) values ('20', '30');
insert into Gym_Events (Gym_ID, Event_ID) values ('3', '10');
insert into Gym_Events (Gym_ID, Event_ID) values ('9', '5');
insert into Gym_Events (Gym_ID, Event_ID) values ('39', '12');
insert into Gym_Events (Gym_ID, Event_ID) values ('19', '15');
insert into Gym_Events (Gym_ID, Event_ID) values ('41', '32');
insert into Gym_Events (Gym_ID, Event_ID) values ('35', '25');
insert into Gym_Events (Gym_ID, Event_ID) values ('23', '14');
insert into Gym_Events (Gym_ID, Event_ID) values ('29', '3');
insert into Gym_Events (Gym_ID, Event_ID) values ('25', '9');
insert into Gym_Events (Gym_ID, Event_ID) values ('26', '8');
insert into Gym_Events (Gym_ID, Event_ID) values ('12', '39');
insert into Gym_Events (Gym_ID, Event_ID) values ('36', '33');
insert into Gym_Events (Gym_ID, Event_ID) values ('11', '24');
insert into Gym_Events (Gym_ID, Event_ID) values ('17', '11');
insert into Gym_Events (Gym_ID, Event_ID) values ('10', '19');
insert into Gym_Events (Gym_ID, Event_ID) values ('15', '27');
insert into Gym_Events (Gym_ID, Event_ID) values ('13', '41');
insert into Gym_Events (Gym_ID, Event_ID) values ('1', '36');
insert into Gym_Events (Gym_ID, Event_ID) values ('16', '20');
insert into Gym_Events (Gym_ID, Event_ID) values ('27', '7');
insert into Gym_Events (Gym_ID, Event_ID) values ('18', '17');
insert into Gym_Events (Gym_ID, Event_ID) values ('4', '31');
insert into Gym_Events (Gym_ID, Event_ID) values ('37', '26');
insert into Gym_Events (Gym_ID, Event_ID) values ('14', '40');
insert into Gym_Events (Gym_ID, Event_ID) values ('6', '28');
insert into Gym_Events (Gym_ID, Event_ID) values ('22', '21');
insert into Gym_Events (Gym_ID, Event_ID) values ('34', '4');
insert into Gym_Events (Gym_ID, Event_ID) values ('28', '38');
insert into Gym_Events (Gym_ID, Event_ID) values ('31', '18');
insert into Gym_Events (Gym_ID, Event_ID) values ('32', '29');
insert into Gym_Events (Gym_ID, Event_ID) values ('24', '22');
insert into Gym_Events (Gym_ID, Event_ID) values ('40', '23');
insert into Gym_Events (Gym_ID, Event_ID) values ('33', '13');
insert into Gym_Events (Gym_ID, Event_ID) values ('37', '35');
insert into Gym_Events (Gym_ID, Event_ID) values ('36', '15');
insert into Gym_Events (Gym_ID, Event_ID) values ('7', '6');
insert into Gym_Events (Gym_ID, Event_ID) values ('3', '24');
insert into Gym_Events (Gym_ID, Event_ID) values ('33', '16');
insert into Gym_Events (Gym_ID, Event_ID) values ('11', '29');
insert into Gym_Events (Gym_ID, Event_ID) values ('20', '1');
insert into Gym_Events (Gym_ID, Event_ID) values ('5', '13');
insert into Gym_Events (Gym_ID, Event_ID) values ('27', '10');
insert into Gym_Events (Gym_ID, Event_ID) values ('25', '39');
insert into Gym_Events (Gym_ID, Event_ID) values ('14', '37');
insert into Gym_Events (Gym_ID, Event_ID) values ('22', '8');
insert into Gym_Events (Gym_ID, Event_ID) values ('13', '33');
insert into Gym_Events (Gym_ID, Event_ID) values ('6', '40');
insert into Gym_Events (Gym_ID, Event_ID) values ('2', '2');
insert into Gym_Events (Gym_ID, Event_ID) values ('38', '19');
insert into Gym_Events (Gym_ID, Event_ID) values ('15', '11');
insert into Gym_Events (Gym_ID, Event_ID) values ('8', '31');
insert into Gym_Events (Gym_ID, Event_ID) values ('24', '32');
insert into Gym_Events (Gym_ID, Event_ID) values ('17', '21');
insert into Gym_Events (Gym_ID, Event_ID) values ('4', '14');
insert into Gym_Events (Gym_ID, Event_ID) values ('10', '4');
insert into Gym_Events (Gym_ID, Event_ID) values ('32', '3');
insert into Gym_Events (Gym_ID, Event_ID) values ('40', '5');
insert into Gym_Events (Gym_ID, Event_ID) values ('34', '9');
insert into Gym_Events (Gym_ID, Event_ID) values ('35', '7');
insert into Gym_Events (Gym_ID, Event_ID) values ('39', '36');
insert into Gym_Events (Gym_ID, Event_ID) values ('1', '23');
insert into Gym_Events (Gym_ID, Event_ID) values ('19', '26');
insert into Gym_Events (Gym_ID, Event_ID) values ('29', '30');
insert into Gym_Events (Gym_ID, Event_ID) values ('12', '27');
insert into Gym_Events (Gym_ID, Event_ID) values ('16', '41');
insert into Gym_Events (Gym_ID, Event_ID) values ('28', '18');
insert into Gym_Events (Gym_ID, Event_ID) values ('9', '20');
insert into Gym_Events (Gym_ID, Event_ID) values ('23', '12');
insert into Gym_Events (Gym_ID, Event_ID) values ('30', '17');
insert into Gym_Events (Gym_ID, Event_ID) values ('31', '25');
insert into Gym_Events (Gym_ID, Event_ID) values ('18', '38');
insert into Gym_Events (Gym_ID, Event_ID) values ('21', '22');
insert into Gym_Events (Gym_ID, Event_ID) values ('41', '28');
insert into Gym_Events (Gym_ID, Event_ID) values ('26', '34');
insert into Gym_Events (Gym_ID, Event_ID) values ('26', '34');
insert into Gym_Events (Gym_ID, Event_ID) values ('5', '23');
insert into Gym_Events (Gym_ID, Event_ID) values ('27', '10');
insert into Gym_Events (Gym_ID, Event_ID) values ('37', '13');
insert into Gym_Events (Gym_ID, Event_ID) values ('15', '39');
insert into Gym_Events (Gym_ID, Event_ID) values ('11', '22');
insert into Gym_Events (Gym_ID, Event_ID) values ('24', '29');
insert into Gym_Events (Gym_ID, Event_ID) values ('8', '16');
insert into Gym_Events (Gym_ID, Event_ID) values ('29', '30');
insert into Gym_Events (Gym_ID, Event_ID) values ('33', '32');
insert into Gym_Events (Gym_ID, Event_ID) values ('14', '41');
insert into Gym_Events (Gym_ID, Event_ID) values ('41', '11');
insert into Gym_Events (Gym_ID, Event_ID) values ('1', '40');
insert into Gym_Events (Gym_ID, Event_ID) values ('23', '8');
insert into Gym_Events (Gym_ID, Event_ID) values ('40', '17');
insert into Gym_Events (Gym_ID, Event_ID) values ('6', '26');
insert into Gym_Events (Gym_ID, Event_ID) values ('36', '7');
insert into Gym_Events (Gym_ID, Event_ID) values ('22', '25');
insert into Gym_Events (Gym_ID, Event_ID) values ('4', '4');
insert into Gym_Events (Gym_ID, Event_ID) values ('20', '19');
insert into Gym_Events (Gym_ID, Event_ID) values ('19', '14');
insert into Gym_Events (Gym_ID, Event_ID) values ('34', '38');
insert into Gym_Events (Gym_ID, Event_ID) values ('12', '9');
insert into Gym_Events (Gym_ID, Event_ID) values ('3', '27');
insert into Gym_Events (Gym_ID, Event_ID) values ('9', '15');
insert into Gym_Events (Gym_ID, Event_ID) values ('25', '20');
insert into Gym_Events (Gym_ID, Event_ID) values ('21', '18');
insert into Gym_Events (Gym_ID, Event_ID) values ('35', '12');
insert into Gym_Events (Gym_ID, Event_ID) values ('28', '24');
insert into Gym_Events (Gym_ID, Event_ID) values ('18', '28');
insert into Gym_Events (Gym_ID, Event_ID) values ('38', '33');
insert into Gym_Events (Gym_ID, Event_ID) values ('31', '6');
insert into Gym_Events (Gym_ID, Event_ID) values ('32', '36');
insert into Gym_Events (Gym_ID, Event_ID) values ('13', '37');
insert into Gym_Events (Gym_ID, Event_ID) values ('17', '3');
insert into Gym_Events (Gym_ID, Event_ID) values ('39', '21');
insert into Gym_Events (Gym_ID, Event_ID) values ('30', '31');
insert into Gym_Events (Gym_ID, Event_ID) values ('16', '35');
insert into Gym_Events (Gym_ID, Event_ID) values ('7', '5');
insert into Gym_Events (Gym_ID, Event_ID) values ('10', '1');
insert into Gym_Events (Gym_ID, Event_ID) values ('41', '28');
insert into Gym_Events (Gym_ID, Event_ID) values ('25', '40');
insert into Gym_Events (Gym_ID, Event_ID) values ('31', '9');
insert into Gym_Events (Gym_ID, Event_ID) values ('40', '10');
insert into Gym_Events (Gym_ID, Event_ID) values ('5', '30');
insert into Gym_Events (Gym_ID, Event_ID) values ('38', '39');
insert into Gym_Events (Gym_ID, Event_ID) values ('23', '13');
insert into Gym_Events (Gym_ID, Event_ID) values ('13', '33');
insert into Gym_Events (Gym_ID, Event_ID) values ('2', '7');
insert into Gym_Events (Gym_ID, Event_ID) values ('27', '34');
insert into Gym_Events (Gym_ID, Event_ID) values ('15', '8');
insert into Gym_Events (Gym_ID, Event_ID) values ('32', '20');
insert into Gym_Events (Gym_ID, Event_ID) values ('37', '38');
insert into Gym_Events (Gym_ID, Event_ID) values ('33', '26');
insert into Gym_Events (Gym_ID, Event_ID) values ('6', '23');
insert into Gym_Events (Gym_ID, Event_ID) values ('29', '21');
insert into Gym_Events (Gym_ID, Event_ID) values ('8', '16');
insert into Gym_Events (Gym_ID, Event_ID) values ('26', '5');
insert into Gym_Events (Gym_ID, Event_ID) values ('36', '31');
insert into Gym_Events (Gym_ID, Event_ID) values ('24', '12');
insert into Gym_Events (Gym_ID, Event_ID) values ('10', '25');
insert into Gym_Events (Gym_ID, Event_ID) values ('16', '18');
insert into Gym_Events (Gym_ID, Event_ID) values ('39', '29');
insert into Gym_Events (Gym_ID, Event_ID) values ('20', '32');
insert into Gym_Events (Gym_ID, Event_ID) values ('34', '37');
insert into Gym_Events (Gym_ID, Event_ID) values ('12', '19');
insert into Gym_Events (Gym_ID, Event_ID) values ('17', '14');
insert into Gym_Events (Gym_ID, Event_ID) values ('4', '11');
insert into Gym_Events (Gym_ID, Event_ID) values ('3', '3');
insert into Gym_Events (Gym_ID, Event_ID) values ('9', '22');
insert into Gym_Events (Gym_ID, Event_ID) values ('28', '15');
insert into Gym_Events (Gym_ID, Event_ID) values ('21', '4');
insert into Gym_Events (Gym_ID, Event_ID) values ('19', '27');
insert into Gym_Events (Gym_ID, Event_ID) values ('22', '17');
insert into Gym_Events (Gym_ID, Event_ID) values ('35', '2');
insert into Gym_Events (Gym_ID, Event_ID) values ('14', '24');
insert into Gym_Events (Gym_ID, Event_ID) values ('11', '36');


insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('41', 230, 254, '9:59:04.000', '2024-04-01');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('3', 43, 348, '6:55:00.000', '2024-04-05');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('36', 333, 193, '1:15:06.000', '2023-05-15');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('40', 156, 289, '9:25:25.000', '2023-06-13');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('21', 385, 396, '7:43:04.000', '2023-06-23');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('12', 4, 275, '4:58:38.000', '2023-09-02');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('33', 277, 190, '1:19:50.000', '2024-03-28');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('23', 273, 141, '11:41:26.000', '2023-10-19');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('14', 48, 171, '11:49:07.000', '2024-04-13');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('4', 365, 326, '1:20:43.000', '2023-05-31');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('27', 255, 321, '6:47:33.000', '2023-05-12');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('15', 174, 290, '10:55:38.000', '2023-07-02');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('10', 350, 146, '3:44:45.000', '2023-10-10');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('29', 45, 387, '11:01:55.000', '2024-01-30');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('8', 279, 255, '3:09:50.000', '2023-11-12');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('11', 339, 275, '10:21:31.000', '2023-09-22');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('6', 178, 328, '5:36:57.000', '2023-04-28');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('2', 158, 127, '10:21:37.000', '2023-11-08');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('39', 77, 298, '5:54:13.000', '2024-02-09');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('25', 304, 150, '12:35:26.000', '2023-11-30');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('7', 11, 221, '1:07:27.000', '2024-03-21');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('20', 100, 355, '2:07:24.000', '2024-04-18');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('37', 392, 373, '10:33:14.000', '2024-02-12');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('24', 143, 198, '6:00:35.000', '2023-08-04');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('13', 251, 119, '9:46:23.000', '2023-12-02');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('38', 154, 395, '10:18:50.000', '2023-12-18');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('22', 310, 155, '3:42:52.000', '2023-12-11');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('16', 35, 181, '11:59:34.000', '2023-05-24');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('18', 391, 176, '6:16:50.000', '2023-12-30');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('34', 162, 398, '3:25:55.000', '2023-09-19');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('32', 331, 104, '6:35:02.000', '2023-05-09');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('28', 271, 332, '12:39:23.000', '2023-10-04');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('30', 239, 271, '6:41:15.000', '2023-07-20');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('9', 340, 181, '12:59:50.000', '2023-10-18');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('1', 317, 247, '11:37:06.000', '2023-08-23');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('26', 186, 140, '7:40:45.000', '2023-11-09');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('5', 207, 218, '8:44:47.000', '2023-11-01');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('17', 65, 107, '8:34:47.000', '2023-07-01');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('35', 389, 260, '1:34:41.000', '2023-11-18');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('19', 16, 300, '4:26:07.000', '2023-11-12');
insert into Occupancy (Gym_ID, Occupancy_Level, Max_Occupancy, Time, Date) values ('31', 55, 341, '10:24:38.000', '2024-02-13');