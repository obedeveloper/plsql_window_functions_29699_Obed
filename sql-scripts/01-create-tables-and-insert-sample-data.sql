-- Create Customers Table
CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(15),
    registration_date DATE NOT NULL
);

-- Create Products Table
CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    rental_price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL
);

-- Create Rentals Table
CREATE TABLE Rentals (
    rental_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id) ON DELETE CASCADE,
    product_id INT REFERENCES Products(product_id) ON DELETE CASCADE,
    rental_date DATE NOT NULL,
    return_date DATE,
    rental_status VARCHAR(50) NOT NULL
);

-- Insert Sample Data into Customers Table
INSERT INTO Customers (name, email, phone, registration_date) VALUES
('Alice Johnson', 'alice.johnson@example.com', '1234567890', '2023-01-15'),
('Bob Smith', 'bob.smith@example.com', '0987654321', '2023-02-20'),
('Charlie Brown', 'charlie.brown@example.com', '1357924680', '2023-03-03');

-- Insert Sample Data into Products Table
INSERT INTO Products (product_name, category, rental_price, stock_quantity) VALUES
('Evening Gown', 'Formal', 49.99, 10),
('Summer Dress', 'Casual', 29.99, 20),
('Winter Jacket', 'Outerwear', 69.99, 15),
('Jeans', 'Casual', 19.99, 30),
('Tuxedo', 'Formal', 79.99, 5);

-- Insert Sample Data into Rentals Table
INSERT INTO Rentals (customer_id, product_id, rental_date, return_date, rental_status) VALUES
(1, 3, '2023-02-01', '2023-02-08', 'Returned'),
(1, 1, '2023-02-05', NULL, 'Pending'),
(2, 4, '2023-02-10', '2023-02-18', 'Returned'),
(3, 2, '2023-03-01', NULL, 'Pending');
