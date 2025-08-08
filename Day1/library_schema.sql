CREATE DATABASE LibraryDB;
USE LibraryDB;

-- Authors Table-- 
CREATE TABLE Authors(
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    birth_year INT
);

-- Publishers Table-- 
CREATE TABLE Publishers (
    publisher_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(50)
);

-- Books Table-- 
CREATE TABLE Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    author_id INT,
    publisher_id INT,
    genre VARCHAR(50),
    year INT,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id),
    FOREIGN KEY (publisher_id) REFERENCES Publishers(publisher_id)
);

-- Members Table-- 
CREATE TABLE Members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    membership_date DATE
);

-- BookCopies Table (to manage multiple copies of the same book)-- 
CREATE TABLE BookCopies (
    copy_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT,
    status ENUM('available', 'borrowed', 'reserved', 'damaged') DEFAULT 'available',
    location VARCHAR(100),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

-- Loans Table (which copy was borrowed by which member)-- 
CREATE TABLE Loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    copy_id INT,
    member_id INT,
    issue_date DATE,
    return_date DATE,
    FOREIGN KEY (copy_id) REFERENCES BookCopies(copy_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

-- Reservations Table (when no copies are available)-- 
CREATE TABLE Reservations (
    reservation_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT,
    book_id INT,
    reservation_date DATE,
    status ENUM('pending', 'fulfilled', 'cancelled') DEFAULT 'pending',
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

-- Fines Table (for late returns)-- 
CREATE TABLE Fines (
    fine_id INT PRIMARY KEY AUTO_INCREMENT,
    loan_id INT,
    amount DECIMAL(6, 2),
    paid BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (loan_id) REFERENCES Loans(loan_id)
);

-- Staff Table (to manage admins/librarians)-- 
CREATE TABLE Staff (
    staff_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100),
    role ENUM('admin', 'librarian', 'assistant') DEFAULT 'librarian',
    password_hash VARCHAR(255)
);

-- Activity Log Table (tracks actions performed by staff)-- 
CREATE TABLE ActivityLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    staff_id INT,
    action TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);