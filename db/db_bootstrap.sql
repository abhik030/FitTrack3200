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
CREATE TABLE Gym (
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
    Friends INT PRIMARY KEY,
    Member_ID INT,
    FOREIGN KEY (Member_ID) REFERENCES Member(Member_ID)
);

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




-- SAMPLE DATA