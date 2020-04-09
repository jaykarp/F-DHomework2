/* 
    Drop Tables pre-script
*/

DROP TABLE ACTORS CASCADE CONSTRAINTS;
DROP TABLE GENRES CASCADE CONSTRAINTS;
DROP TABLE EVENTS CASCADE CONSTRAINTS;
DROP TABLE USERS  CASCADE CONSTRAINTS;
DROP TABLE PROFILES CASCADE CONSTRAINTS;
DROP TABLE CONTRACTS CASCADE CONSTRAINTS;
DROP TABLE MEMBERS CASCADE CONSTRAINTS;
DROP TABLE CLUBS CASCADE CONSTRAINTS;
DROP TABLE CLUBMEMBERS CASCADE CONSTRAINTS;
DROP TABLE FILMS CASCADE CONSTRAINTS;
DROP TABLE MOVIEACTORS CASCADE CONSTRAINTS;
DROP TABLE MOVIEGENRES CASCADE CONSTRAINTS;
DROP TABLE HISTORY CASCADE CONSTRAINTS;

/*
    Create reference tables
*/

CREATE TABLE ACTORS (
    name                VARCHAR2(100)   NOT NULL,
    CONSTRAINT PK_ACTORS
        PRIMARY KEY (name)
);

CREATE TABLE GENRES (
    genre               VARCHAR2(100)   NOT NULL,
    CONSTRAINT PK_GENRES
        PRIMARY KEY (genre)
);

CREATE TABLE EVENTS (
    eventName           VARCHAR2(100)   NOT NULL,
    CONSTRAINT PK_EVENTS
        PRIMARY KEY (eventName)
);

/*
    Create primary tables
*/

-- USERS / CLUB TABLES

CREATE TABLE USERS (
    username            VARCHAR2(100)   NOT NULL,
    password            VARCHAR2(100)   NOT NULL,
    email               VARCHAR2(100)   NOT NULL,
    CONSTRAINT PK_USERS
        PRIMARY KEY (username)
);

CREATE TABLE PROFILES (
    username            VARCHAR2(100)   NOT NULL,
    citizenID           VARCHAR2(9)     NOT NULL,
    firstName           VARCHAR2(100),
    lastName            VARCHAR2(100),
    secondLastName      VARCHAR2(100),
    age                 NUMBER(3),
    phoneNumber         VARCHAR2(14),
    dateOfBirth         DATE,
    CONSTRAINT PK_PROFILES
        PRIMARY KEY (username),
    CONSTRAINT FK_PROFILES
        FOREIGN KEY (username)
            REFERENCES USERS
                ON DELETE CASCADE,
    CONSTRAINT UNIQUE_PROFILES_CITIZENID UNIQUE(citizenID),
    CONSTRAINT UNIQUE_PROFILES_PHONENUMBER UNIQUE(phoneNumber)
);

CREATE TABLE CONTRACTS (
    contractId          VARCHAR2(16)    NOT NULL,
    username            VARCHAR2(100)   NOT NULL,
    citizenID           VARCHAR2(9)     NOT NULL,
    postalAddress       VARCHAR2(100)   NOT NULL,
    town                VARCHAR2(100)   NOT NULL,
    zipCode             VARCHAR2(10)    NOT NULL,
    country             VARCHAR2(100)   NOT NULL,
    startDate           DATE            NOT NULL,
    endDate             DATE,
    CONSTRAINT PK_CONTRACTS
        PRIMARY KEY (contractId),
    CONSTRAINT FK_PROFILES_USERNAME
        FOREIGN KEY (username)
            REFERENCES PROFILES
                ON DELETE CASCADE,
    CONSTRAINT FK_PROFILES_CITIZENID
        FOREIGN KEY (citizenID)
            REFERENCES PROFILES(citizenID)
                ON DELETE CASCADE
);

CREATE TABLE MEMBERS (
    userRef             VARCHAR2(100)   NOT NULL,
    CONSTRAINT PK_MEMBERS
        PRIMARY KEY (userRef),
    CONSTRAINT FK_MEMBERS_USERREF
        FOREIGN KEY (userRef)
            REFERENCES USERS
                ON DELETE CASCADE
);

CREATE TABLE CLUBS (
    clubName            VARCHAR2(60)    NOT NULL,
    open                VARCHAR2(99)    NOT NULL,
    motto               VARCHAR2(1500),
    CONSTRAINT PK_CLUBNAME
        PRIMARY KEY (clubName)
);

CREATE TABLE CLUBMEMBERS (
    username            VARCHAR2(100)   NOT NULL,
    clubName            VARCHAR2(60)    NOT NULL,
    CONSTRAINT PK_CLUBMEMBERS
        PRIMARY KEY (username, clubName),
    CONSTRAINT FK_CLUBMEMBERS_USERNAME
        FOREIGN KEY (username)
            REFERENCES MEMBERS
                ON DELETE CASCADE,
    CONSTRAINT FK_CLUBMEMBERS_CLUBNAME
        FOREIGN KEY (clubName)
            REFERENCES CLUBS
                ON DELETE CASCADE
);

-- FILMS TABLES

CREATE TABLE FILMS (
    title               VARCHAR2(100)   NOT NULL,
    director            VARCHAR2(100)   NOT NULL,
    duration            NUMBER,
    color               VARCHAR2(100),
    aspectRatio         NUMBER,
    release             DATE,
    ageRating           VARCHAR2(100),
    country             VARCHAR2(100),
    language            VARCHAR2(100),
    budget              NUMBER,
    grossIncome         NUMBER,
    imdbLink            VARCHAR2(100)   NOT NULL,
    imdbScore           NUMBER(3, 1)    NOT NULL,
    imdbNumberCritics   NUMBER,
    imdbNumberUsers     NUMBER          NOT NULL,
    directorLikes       NUMBER          NOT NULL,
    castLikes           NUMBER          NOT NULL,
    filmLikes           NUMBER          NOT NULL,
    facesOnPoster       NUMBER,
    CONSTRAINT PK_FILMS
        PRIMARY KEY (title, director)
);

CREATE TABLE MOVIEACTORS (
    name                VARCHAR2(100)   NOT NULL,
    filmTitle           VARCHAR2(100)   NOT NULL,
    filmDirector        VARCHAR2(100)   NOT NULL,
    likes               NUMBER          NOT NULL,
    CONSTRAINT PK_MOVIEACTORS
        PRIMARY KEY (name, filmTitle, filmDirector),
    CONSTRAINT FK_MOVIEACTORS_NAME
        FOREIGN KEY (name)
            REFERENCES ACTORS,
    CONSTRAINT FK_MOVIEACTORS_FILM
        FOREIGN KEY (filmTitle, filmDirector)
            REFERENCES FILMS
                ON DELETE CASCADE
);

CREATE TABLE MOVIEGENRES (
    filmTitle           VARCHAR2(100)   NOT NULL,
    filmDirector        VARCHAR2(100)   NOT NULL,
    genre               VARCHAR2(100)   NOT NULL,
    CONSTRAINT PK_MOVIEGENRES
        PRIMARY KEY (filmTitle, filmDirector, genre),
    CONSTRAINT FK_MOVIEGENRES_FILM
        FOREIGN KEY (filmTitle, filmDirector)
            REFERENCES FILMS
                ON DELETE CASCADE,
    CONSTRAINT FK_MOVIEGENRES_GENRE
        FOREIGN KEY (genre)
            REFERENCES GENRES
);


-- HISTORY / EVENT TABLES

CREATE TABLE HISTORY (
    eventType           VARCHAR2(100)   NOT NULL,
    dateTime            DATE            NOT NULL,
    club                VARCHAR2(60),
    firstUser           VARCHAR2(100),
    filmTitle           VARCHAR2(100),
    filmDirector        VARCHAR2(100),
    subject             VARCHAR(100),
    message             VARCHAR(1500),
    value               NUMBER(2, 0),
    contract            VARCHAR2(16),
    secondUser          VARCHAR2(100),
    motto               VARCHAR2(1500),
    open                VARCHAR2(99),
    CONSTRAINT FK_HISTORY_EVENT
        FOREIGN KEY (eventType)
            REFERENCES EVENTS,
    CONSTRAINT FK_HISTORY_FILMS
        FOREIGN KEY (filmTitle, filmDirector)
            REFERENCES FILMS,
    CONSTRAINT FK_HISTORY_FIRSTUSER
        FOREIGN KEY (firstUser)
            REFERENCES MEMBERS
                ON DELETE CASCADE,
    CONSTRAINT FK_HISTORY_SECONDUSER
        FOREIGN KEY (secondUser)
            REFERENCES MEMBERS
                ON DELETE CASCADE,
    CONSTRAINT FK_HISTORY_CLUB
        FOREIGN KEY (club)
            REFERENCES CLUBS
);
