create database ipl12;
use ipl12;
CREATE TABLE Teams (
    TeamID INT PRIMARY KEY,
    Name VARCHAR(255),
    City VARCHAR(255),
    Owner VARCHAR(255),
    Coach VARCHAR(255),
    Captain VARCHAR(255)
);

CREATE TABLE Players (
    PlayerID INT PRIMARY KEY,
    TeamID INT,
    Name VARCHAR(255),
    Age INT,
    Role VARCHAR(50),
    Nationality VARCHAR(50),
    BattingStyle VARCHAR(50),
    BowlingStyle VARCHAR(50),
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID)
);

CREATE TABLE Venues (
    VenueID INT PRIMARY KEY,
    Name VARCHAR(255),
    City VARCHAR(255),
    Capacity INT
);

CREATE TABLE Matches (
    MatchID INT PRIMARY KEY,
    Date DATE,
    VenueID INT,
    Team1ID INT,
    Team2ID INT,
    WinnerTeamID INT,
    MatchType VARCHAR(50),
    FOREIGN KEY (VenueID) REFERENCES Venues(VenueID),
    FOREIGN KEY (Team1ID) REFERENCES Teams(TeamID),
    FOREIGN KEY (Team2ID) REFERENCES Teams(TeamID),
    FOREIGN KEY (WinnerTeamID) REFERENCES Teams(TeamID)
);

CREATE TABLE Performance (
    PerformanceID INT PRIMARY KEY,
    MatchID INT,
    PlayerID INT,
    RunsScored INT,
    WicketsTaken INT,
    CatchesTaken INT,
    StumpsMade INT,
    FOREIGN KEY (MatchID) REFERENCES Matches(MatchID),
    FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID)
);

CREATE TABLE Scores (
    ScoreID INT PRIMARY KEY,
    MatchID INT,
    TeamID INT,
    
    InningsNumber INT,
    Runs INT,
    WicketsLost INT,
    OversBowled DECIMAL(5,2),
    FOREIGN KEY (MatchID) REFERENCES Matches(MatchID),
     FOREIGN KEY (TeamID) REFERENCES Teams(TeamID)
);
