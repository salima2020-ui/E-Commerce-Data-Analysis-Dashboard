DROP TABLE IF EXISTS orders CASCADE;

CREATE TABLE users (
    id          INT          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name  VARCHAR(50)  NOT NULL,
    last_name   VARCHAR(50)  NOT NULL,
    email       VARCHAR(100) NOT NULL UNIQUE,
    phone       VARCHAR(20)  NOT null UNIQUE,
    birth_date  DATE         NOT NULL,
    city        VARCHAR(50),
    country     VARCHAR(50),
    is_active   BOOLEAN      DEFAULT TRUE,
    created_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE employees (
    employee_id  INT           GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name    VARCHAR(100)  NOT NULL,
    email        VARCHAR(100)  NOT NULL UNIQUE,
    role         VARCHAR(50),
    department   VARCHAR(50),
    salary       DECIMAL(10,2) CHECK (salary >= 0),
    manager_id   INT           REFERENCES employees(employee_id) ON DELETE SET NULL,
    is_active    BOOLEAN       DEFAULT TRUE,
    hired_at     DATE          DEFAULT CURRENT_DATE,
    created_at   TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    category_id  INT          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name         VARCHAR(100) NOT NULL UNIQUE,
    parent_id    INT          REFERENCES categories(category_id) ON DELETE SET NULL,
    created_at   TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    product_id   INT           GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name         VARCHAR(150)  NOT NULL,
    brand        VARCHAR(50),
    category_id  INT           REFERENCES categories(category_id) ON DELETE SET NULL,
    price        DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    stock        INT           NOT NULL DEFAULT 0 CHECK (stock >= 0),
    is_active    BOOLEAN       DEFAULT TRUE,
    created_at   TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE addresses (
    address_id    INT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id       INT       NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title         VARCHAR(50),
    full_address  TEXT      NOT NULL,
    city          VARCHAR(50),
    country       VARCHAR(50),
    is_default    BOOLEAN   DEFAULT FALSE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    order_id         INT           GENERATED ALWAYS AS IDENTITY (START WITH 5001 INCREMENT BY 1) PRIMARY KEY,
    user_id          INT           NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    address_id       INT           REFERENCES addresses(address_id) ON DELETE SET NULL,
    total_amount     DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    discount_applied DECIMAL(10,2) DEFAULT 0.00,
    payment_method   VARCHAR(30),
    order_status     VARCHAR(20)   DEFAULT 'pending'
                                   CHECK (order_status IN ('pending','confirmed','shipped','delivered','cancelled','refunded')),
    created_at       TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
    order_item_id      INT           GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id     INT           NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id   INT           REFERENCES products(product_id) ON DELETE SET NULL,
    product_name VARCHAR(150)  NOT NULL,
    quantity     INT           NOT NULL DEFAULT 1 CHECK (quantity > 0),
    price   DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    total_price  DECIMAL(10,2) GENERATED ALWAYS AS (quantity * unit_price) STORED
);

CREATE TABLE payments (
    payment_id      INT           GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id        INT           NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    amount          DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    method          VARCHAR(30),
    status          VARCHAR(20)   DEFAULT 'pending'
                                  CHECK (status IN ('pending','completed','failed','refunded')),
    transaction_ref VARCHAR(100),
    paid_at         TIMESTAMP,
    created_at      TIMESTAMP     DEFAULT CURRENT_TIMESTAMP

CREATE TABLE notifications (
    notification_id  INT          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id          INT          NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type             VARCHAR(50)  NOT NULL
                                  CHECK (type IN ('order_placed','order_shipped','order_delivered','order_cancelled','payment_success','payment_failed','promo','system')),
    title            VARCHAR(150) NOT NULL,
    message          TEXT,
    is_read          BOOLEAN      DEFAULT FALSE,
    reference_table  VARCHAR(50),
    reference_id     INT,
    read_at          TIMESTAMP,
    created_at       TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);


INSERT INTO users (first_name, last_name, email, phone, birth_date, city, country, is_active) VALUES
('Əli',      'Həsənov',   'ali.hasanov@gmail.com',    '0501234567', '1990-03-15', 'Bakı',      'Azərbaycan', TRUE),
('Nigar',    'Quliyeva',  'nigar.quliyeva@gmail.com', '0552345678', '1995-07-22', 'Bakı',      'Azərbaycan', TRUE),
('Vüsal',    'Məmmədov',  'vusal.mammadov@mail.ru',   '0703456789', '1988-11-05', 'Gəncə',     'Azərbaycan', TRUE),
('Leyla',    'Əliyeva',   'leyla.aliyeva@gmail.com',  '0514567890', '1993-01-30', 'Sumqayıt',  'Azərbaycan', TRUE),
('Kamran',   'Nəsirov',   'kamran.nasirov@gmail.com', '0555678901', '1985-09-12', 'Bakı',      'Azərbaycan', TRUE),
('Aytən',    'Hüseynova', 'ayten.huseynova@mail.ru',  '0706789012', '1997-04-18', 'Lənkəran',  'Azərbaycan', TRUE),
('Orxan',    'Babayev',   'orxan.babayev@gmail.com',  '0507890123', '1991-06-25', 'Bakı',      'Azərbaycan', FALSE),
('Günel',    'Rəhimova',  'gunel.rahimova@gmail.com', '0558901234', '1999-12-03', 'Mingəçevir', 'Azərbaycan', TRUE);
 
 

INSERT INTO employees (full_name, email, role, department, salary, manager_id, is_active, hired_at) VALUES
('Rauf Əliyev',      'rauf.aliyev@company.az',    'CEO',             'İdarəetmə',  8500.00, NULL, TRUE, '2018-01-10'),
('Səbinə Musayeva',  'sabina.musayeva@company.az', 'CTO',             'Texnologiya', 7200.00, 1,   TRUE, '2018-03-15'),
('Tural Hüseynov',   'tural.huseynov@company.az',  'CFO',             'Maliyyə',    6800.00, 1,   TRUE, '2019-02-01'),
('Fidan Qasımova',   'fidan.qasimova@company.az',  'Backend Dev',     'Texnologiya', 3200.00, 2,   TRUE, '2020-06-10'),
('Elnur Cəfərov',    'elnur.cafarov@company.az',   'Frontend Dev',    'Texnologiya', 3000.00, 2,   TRUE, '2021-01-20'),
('Şəbnəm Əhmədova',  'sabnam.ahmadova@company.az', 'Mühasib',         'Maliyyə',    2400.00, 3,   TRUE, '2020-09-05'),
('Kamil Rzayev',     'kamil.rzayev@company.az',    'HR Mütəxəssisi',  'HR',         2200.00, 1,   TRUE, '2021-07-12'),
('Nərmin İsmayılova','narmin.ismayilova@company.az','Junior Dev',      'Texnologiya', 1800.00, 4,   FALSE,'2022-03-01');
 
 

INSERT INTO categories (name, parent_id) VALUES
('Elektronika',       NULL),
('Geyim',             NULL),
('Ev və Bağ',         NULL),
('Telefonlar',        1),
('Noutbuklar',        1),
('Kişi Geyimi',       2),
('Qadın Geyimi',      2),
('Mətbəx Əşyaları',   3);
 

INSERT INTO products (name, brand, category_id, price, stock, is_active) VALUES
('iPhone 15 Pro',         'Apple',    4,  2499.00, 25,  TRUE),
('Samsung Galaxy S24',    'Samsung',  4,  1899.00, 40,  TRUE),
('MacBook Air M3',        'Apple',    5,  3299.00, 15,  TRUE),
('Lenovo ThinkPad X1',    'Lenovo',   5,  2799.00, 10,  TRUE),
('Nike Kişi Köynəyi',     'Nike',     6,   89.00, 100,  TRUE),
('Zara Qadın Donu',       'Zara',     7,  129.00,  60,  TRUE),
('Tefal Qazan Dəsti',     'Tefal',    8,  299.00,  35,  TRUE),
('Xiaomi Redmi Note 13',  'Xiaomi',   4,  699.00,  80,  TRUE);
 
 

INSERT INTO addresses (user_id, title, full_address, city, country, is_default) VALUES
(1, 'Ev',   'Neftçilər pr. 42, mən. 15',  'Bakı',      'Azərbaycan', TRUE),
(2, 'Ev',   'İstiqlaliyyət küç. 8, mən. 3','Bakı',      'Azərbaycan', TRUE),
(3, 'Ev',   'Cavadxan küç. 17, mən. 5',   'Gəncə',     'Azərbaycan', TRUE),
(4, 'İş',   'Azadlıq pr. 100, of. 12',    'Sumqayıt',  'Azərbaycan', TRUE),
(5, 'Ev',   'Hüsü Hacıyev küç. 3, mən. 8','Bakı',      'Azərbaycan', TRUE),
(6, 'Ev',   'Lənkəran şəh., Xiyaban 21',  'Lənkəran',  'Azərbaycan', TRUE),
(7, 'Ev',   'Səməd Vurğun küç. 55',       'Bakı',      'Azərbaycan', TRUE),
(8, 'Ev',   'Həsən Əliyev küç. 9, mən. 2','Mingəçevir','Azərbaycan', TRUE);
 
 

INSERT INTO orders (user_id, address_id, total_amount, discount_applied, payment_method, order_status) VALUES
(1, 1, 2499.00,    0.00, 'Kart',   'delivered'),
(2, 2, 1899.00,   50.00, 'Kart',   'delivered'),
(3, 3, 3299.00,    0.00, 'Nağd',   'shipped'),
(4, 4,  299.00,   20.00, 'Kart',   'confirmed'),
(5, 5, 2799.00,    0.00, 'Kart',   'pending'),
(6, 6,  129.00,    0.00, 'Nağd',   'delivered'),
(1, 1,  699.00,   30.00, 'Kart',   'cancelled'),
(8, 8,  178.00,    0.00, 'Kart',   'confirmed');
 
 

INSERT INTO order_items (order_id, product_id, product_name, quantity, price) VALUES
(5001, 1, 'iPhone 15 Pro',        1, 2499.00),
(5002, 2, 'Samsung Galaxy S24',   1, 1899.00),
(5003, 3, 'MacBook Air M3',       1, 3299.00),
(5004, 7, 'Tefal Qazan Dəsti',    1,  299.00),
(5005, 4, 'Lenovo ThinkPad X1',   1, 2799.00),
(5006, 6, 'Zara Qadın Donu',      1,  129.00),
(5007, 8, 'Xiaomi Redmi Note 13', 1,  699.00),
(5008, 5, 'Nike Kişi Köynəyi',    2,   89.00);
 
 

INSERT INTO payments (order_id, amount, method, status, transaction_ref, paid_at) VALUES
(5001, 2499.00, 'Kart', 'completed', 'TXN-001-2024', '2024-01-15 10:30:00'),
(5002, 1849.00, 'Kart', 'completed', 'TXN-002-2024', '2024-02-20 14:15:00'),
(5003, 3299.00, 'Nağd', 'completed', 'TXN-003-2024', '2024-03-05 09:00:00'),
(5004,  279.00, 'Kart', 'completed', 'TXN-004-2024', '2024-03-18 16:45:00'),
(5005, 2799.00, 'Kart', 'pending',    NULL,            NULL),
(5006,  129.00, 'Nağd', 'completed', 'TXN-006-2024', '2024-04-10 11:20:00'),
(5007,  669.00, 'Kart', 'failed',    'TXN-007-2024', NULL),
(5008,  178.00, 'Kart', 'completed', 'TXN-008-2024', '2024-05-01 13:00:00');
 
 
INSERT INTO notifications (user_id, type, title, message, is_read, reference_table, reference_id) VALUES
(1, 'order_placed',    'Sifarişiniz qəbul edildi',     'Sifariş #5001 uğurla qəbul edildi.',         TRUE,  'orders', 5001),
(2, 'payment_success', 'Ödəniş tamamlandı',            'Sifariş #5002 üçün ödəniş alındı.',          TRUE,  'orders', 5002),
(3, 'order_shipped',   'Sifarişiniz yoldadır',         'Sifariş #5003 çatdırılmaya verildi.',        FALSE, 'orders', 5003),
(4, 'order_placed',    'Sifarişiniz qəbul edildi',     'Sifariş #5004 uğurla qəbul edildi.',         TRUE,  'orders', 5004),
(5, 'order_placed',    'Sifarişiniz qəbul edildi',     'Sifariş #5005 təsdiqi gözləyir.',            FALSE, 'orders', 5005),
(6, 'order_delivered', 'Sifarişiniz çatdırıldı',       'Sifariş #5006 uğurla çatdırıldı.',           FALSE, 'orders', 5006),
(1, 'payment_failed',  'Ödəniş uğursuz oldu',          'Sifariş #5007 üçün ödəniş alınmadı.',        FALSE, 'orders', 5007),
(8, 'order_placed',    'Sifarişiniz qəbul edildi',     'Sifariş #5008 uğurla qəbul edildi.',         FALSE, 'orders', 5008);




SELECT 
    payment_method,
    COUNT(order_id)   AS order_count,
    SUM(total_amount) AS total_amount
FROM orders
GROUP BY payment_method
HAVING COUNT(order_id) >= 2
ORDER BY total_amount DESC;
 
 
SELECT 
    user_id,
    COUNT(order_id)   AS order_count,
    SUM(total_amount) AS total_spent
FROM orders
WHERE order_status != 'cancelled'
GROUP BY user_id
HAVING SUM(total_amount) > 3000
ORDER BY total_spent DESC;
 
 
SELECT 
    product_name,
    COUNT(order_id)  AS order_count,
    SUM(quantity)    AS total_quantity,
    SUM(total_price) AS total_revenue
FROM order_items
GROUP BY product_name
HAVING COUNT(order_id) >= 2
ORDER BY total_quantity DESC;
 
 
SELECT 
    department,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) < 3000
ORDER BY avg_salary ASC;
 
 
SELECT 
    status,
    COUNT(payment_id) AS payment_count,
    SUM(amount)       AS total_amount
FROM payments
WHERE status IN ('completed', 'failed')
GROUP BY status;
 
 
SELECT 
    EXTRACT(MONTH FROM created_at) AS month,
    COUNT(order_id)                AS order_count,
    SUM(total_amount)              AS total_revenue
FROM orders
GROUP BY EXTRACT(MONTH FROM created_at)
HAVING SUM(total_amount) > 3000
ORDER BY month;
 
 
SELECT 
    department,
    MAX(salary) AS max_salary,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department;
 
 
SELECT 
    user_id,
    MAX(total_amount) AS max_order_amount
FROM orders
GROUP BY user_id
ORDER BY max_order_amount DESC;
 
 
SELECT 
    method,
    AVG(amount) AS avg_amount
FROM payments
GROUP BY method
HAVING AVG(amount) > 1500;
 
 
SELECT 
    product_name,
    SUM(quantity) AS total_quantity
FROM order_items
GROUP BY product_name
ORDER BY total_quantity DESC
LIMIT 1;
 
 
SELECT 
    department,
    COUNT(employee_id) AS active_employee_count
FROM employees
WHERE is_active = TRUE
GROUP BY department
HAVING COUNT(employee_id) >= 2;
 

SELECT 
    payment_method,
    MAX(discount_applied) AS max_discount
FROM orders
GROUP BY payment_method
HAVING MAX(discount_applied) > 10
ORDER BY max_discount DESC;
 

SELECT 
    product_name,
    SUM(total_price) AS total_revenue
FROM order_items
GROUP BY product_name
ORDER BY total_revenue DESC;
 
SELECT 
    department,
    SUM(salary) AS total_salary
FROM employees
GROUP BY department
HAVING SUM(salary) > 5000
ORDER BY total_salary DESC;

select payment_method, avg(discount_applied) as avg_discount from orders group by payment_method having avg(discount_applied)>0 order by avg_discount desc;
select order_status, count(order_id), sum(total_amount) as total_revenue from orders group by order_status having count(order_id)>1 order by total_revenue desc;
select user_id, max(total_amount) as max_amount, min(total_amount) group by user_id order by max_amount desc;