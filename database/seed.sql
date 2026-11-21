-- =====================================================================
--  seed.sql  —  sample data for the restaurant reservations database
--  Based on the ER diagram with these participation constraints:
--    has       Tables total           (every table belongs to a restaurant)
--    employs   Staff total            (every staff member works at a restaurant)
--    offers    Menu_Items total       (every menu item belongs to a restaurant)
--    books     Reservations total     (every reservation has a table)
--    makes     Reservations total     (every reservation has a customer)
--    serves    Reservations total     (every reservation has a staff member)
--    contains  Orders total           (every order belongs to a reservation)
--    selects   Orders total           (every order line has a menu item)
--
--  Deliberate gaps, so the queries have something to find:
--    - Table 'T1' at restaurant 1 is never booked
--    - Customer 13 has never made a reservation
--    - Menu item 9 (Grilled Sea Bass) is never ordered
--    - Reservations 5 (cancelled) and 8 (no-show) have no orders
--    - Reservations 14 and 16 are future bookings with no orders yet
--
--  Repeated values are intentional where they are foreign keys
--  (restaurant_id, customer_id, and so on). Free-text categories
--  (zones, roles, dietary tags) are varied to keep the data realistic.
--
--  Derived attributes (table_count, time_elapsed, total_price,
--  years_employed, full_name) are NOT stored, so they are not inserted.
--  Parent rows are inserted before the rows that reference them.
-- =====================================================================

INSERT INTO restaurants (restaurant_id, name, city) VALUES
    (1,  'Golden Lotus',     'Hong Kong'),
    (2,  'Nordic Table',     'Copenhagen'),
    (3,  'La Tasca Verde',   'Madrid'),
    (4,  'Trattoria Roma',   'Rome'),
    (5,  'Harbour Grill',    'Hong Kong'),
    (6,  'Green Fork',       'Aarhus'),
    (7,  'Sakura House',     'Tokyo'),
    (8,  'The Blue Door',    'London'),
    (9,  'Casa del Sol',     'Barcelona'),
    (10, 'Noodle Bar 88',    'Hong Kong');

INSERT INTO tables (restaurant_id, table_label, seats, zone) VALUES
    (1,  'T1', 2,  'Window'),
    (1,  'T2', 4,  'Main Hall'),
    (1,  'T3', 6,  'Private Room'),
    (2,  'T1', 4,  'Central'),
    (2,  'T2', 2,  'Terrace'),
    (3,  'A1', 4,  'Dining Room'),
    (3,  'A2', 8,  'Patio'),
    (4,  'R1', 2,  'Indoor'),
    (4,  'R2', 6,  'Courtyard'),
    (5,  'H1', 4,  'Harbour View'),
    (5,  'H2', 10, 'Private Room'),
    (6,  'G1', 2,  'Garden'),
    (6,  'G2', 4,  'Greenhouse'),
    (7,  'S1', 4,  'Counter'),
    (8,  'B1', 2,  'Bar'),
    (8,  'B2', 4,  'Main Hall'),
    (9,  'P1', 6,  'Terrace'),
    (10, 'N1', 2,  'Counter'),
    (10, 'N2', 4,  'Lounge');

INSERT INTO customers (customer_id, first_name, last_name, email) VALUES
    (1,  'Alice',  'Wong',     'alice.wong@example.com'),
    (2,  'Bjorn',  'Hansen',   'bjorn.hansen@example.com'),
    (3,  'Carmen', 'Ruiz',     'carmen.ruiz@example.com'),
    (4,  'David',  'Kim',      'david.kim@example.com'),
    (5,  'Elena',  'Rossi',    'elena.rossi@example.com'),
    (6,  'Felix',  'Schmidt',  'felix.schmidt@example.com'),
    (7,  'Grace',  'Lee',      'grace.lee@example.com'),
    (8,  'Hiro',   'Sato',     'hiro.sato@example.com'),
    (9,  'Isabel', 'Moreno',   'isabel.moreno@example.com'),
    (10, 'James',  'Parker',   'james.parker@example.com'),
    (11, 'Karen',  'Ng',       'karen.ng@example.com'),
    (12, 'Lars',   'Pedersen', 'lars.pedersen@example.com'),
    (13, 'Mia',    'Thompson', 'mia.thompson@example.com');

INSERT INTO customer_phones (customer_id, phone) VALUES
    (1,  '+852 5555 0101'),
    (1,  '+852 5555 0102'),
    (2,  '+45 20 12 34 56'),
    (3,  '+34 611 222 333'),
    (4,  '+82 10 1234 5678'),
    (5,  '+39 333 123 4567'),
    (6,  '+49 151 2345 6789'),
    (7,  '+852 6666 0707'),
    (8,  '+81 90 1234 5678'),
    (9,  '+34 622 333 444'),
    (10, '+44 7700 900123'),
    (11, '+852 9123 4567'),
    (12, '+45 30 45 67 89'),
    (13, '+44 7911 123456');

INSERT INTO staff (staff_id, restaurant_id, name, role, hire_date) VALUES
    (1,  1,  'Mei Chan',       'Head Waiter',      '2021-03-15'),
    (2,  1,  'Tomas Leung',    'Host',             '2023-06-01'),
    (3,  2,  'Sofie Larsen',   'General Manager',  '2019-09-10'),
    (4,  2,  'Mads Nielsen',   'Sous Chef',        '2022-01-17'),
    (5,  3,  'Lucia Ortega',   'Server',           '2024-02-05'),
    (6,  4,  'Marco Esposito', 'Head Chef',        '2018-11-20'),
    (7,  5,  'Oscar Wong',     'Duty Manager',     '2020-07-01'),
    (8,  6,  'Ingrid Holm',    'Greeter',          '2025-04-14'),
    (9,  7,  'Yuki Tanaka',    'Sommelier',        '2017-05-22'),
    (10, 8,  'Harry Bell',     'Bartender',        '2024-09-30'),
    (11, 9,  'Carla Marti',    'Server',           '2023-10-09'),
    (12, 10, 'Kevin Lau',      'Cashier',          '2022-08-18');

INSERT INTO menu_items (menu_item_id, restaurant_id, name, price) VALUES
    (1,  1,  'Dim Sum Basket',              58.00),
    (2,  1,  'Crispy Roast Duck',          168.00),
    (3,  1,  'Wonton Noodle Soup',          42.00),
    (4,  2,  'Smoked Salmon Open Sandwich', 135.00),
    (5,  2,  'Meatballs with Lingonberry',  149.00),
    (6,  3,  'Seafood Paella',               24.50),
    (7,  4,  'Spaghetti Carbonara',          16.00),
    (8,  4,  'Tiramisu',                      9.50),
    (9,  5,  'Grilled Sea Bass',            210.00),
    (10, 6,  'Vegetable Buddha Bowl',        13.90),
    (11, 7,  'Salmon Nigiri Set',            28.00),
    (12, 8,  'Fish and Chips',               15.50),
    (13, 9,  'Patatas Bravas',                6.00),
    (14, 10, 'Beef Ho Fun',                  48.00),
    (15, 3,  'Gazpacho',                      9.00);

-- Fixed allergen vocabulary (EU major allergens, exact strings):
--   Gluten, Crustaceans, Eggs, Fish, Peanuts, Soybeans, Milk,
--   Tree nuts, Celery, Mustard, Sesame, Sulphites, Lupin, Molluscs
INSERT INTO menu_item_allergens (menu_item_id, allergen) VALUES
    (1,  'Gluten'),
    (1,  'Soybeans'),
    (1,  'Crustaceans'),
    (2,  'Soybeans'),
    (3,  'Gluten'),
    (3,  'Eggs'),
    (3,  'Crustaceans'),
    (4,  'Fish'),
    (4,  'Gluten'),
    (5,  'Milk'),
    (5,  'Gluten'),
    (6,  'Crustaceans'),
    (6,  'Molluscs'),
    (7,  'Gluten'),
    (7,  'Eggs'),
    (7,  'Milk'),
    (8,  'Milk'),
    (8,  'Eggs'),
    (9,  'Fish'),
    (10, 'Tree nuts'),
    (11, 'Fish'),
    (12, 'Fish'),
    (12, 'Gluten'),
    (14, 'Soybeans'),
    (14, 'Gluten');

-- Fixed dietary vocabulary (use these exact strings in every filter):
--   Vegetarian, Vegan, Pescatarian, Gluten-free, Dairy-free,
--   Nut-free, Halal, Kosher, Low-carb, Low-sodium
INSERT INTO restaurant_dietary_tags (restaurant_id, tag) VALUES
    (1,  'Nut-free'),
    (2,  'Nut-free'),
    (3,  'Gluten-free'),
    (4,  'Nut-free'),
    (5,  'Pescatarian'),
    (5,  'Gluten-free'),
    (6,  'Vegan'),
    (6,  'Dairy-free'),
    (7,  'Dairy-free'),
    (8,  'Pescatarian'),
    (9,  'Vegetarian'),
    (9,  'Nut-free'),
    (10, 'Halal');

INSERT INTO reservations (reservation_id, customer_id, staff_id, restaurant_id, table_label, start_time, party_size, status) VALUES
    (1,  1,  1,  1,  'T2', '2026-11-10 19:00:00', 4, 'completed'),
    (2,  2,  3,  2,  'T1', '2026-11-11 18:30:00', 3, 'completed'),
    (3,  3,  5,  3,  'A2', '2026-11-12 20:00:00', 6, 'completed'),
    (4,  4,  6,  4,  'R2', '2026-11-13 12:30:00', 5, 'completed'),
    (5,  5,  7,  5,  'H2', '2026-11-14 19:30:00', 8, 'cancelled'),
    (6,  6,  8,  6,  'G1', '2026-11-15 13:00:00', 2, 'completed'),
    (7,  7,  9,  7,  'S1', '2026-11-18 20:30:00', 4, 'completed'),
    (8,  8,  10, 8,  'B2', '2026-11-19 21:00:00', 3, 'no_show'),
    (9,  9,  11, 9,  'P1', '2026-11-20 19:00:00', 6, 'completed'),
    (10, 10, 12, 10, 'N2', '2026-11-20 18:00:00', 4, 'completed'),
    (11, 11, 1,  1,  'T3', '2026-11-16 19:30:00', 6, 'completed'),
    (12, 12, 3,  2,  'T2', '2026-11-17 13:00:00', 2, 'completed'),
    (13, 3,  5,  3,  'A1', '2026-11-19 20:00:00', 4, 'completed'),
    (14, 5,  7,  5,  'H1', '2026-11-26 19:00:00', 4, 'confirmed'),
    (15, 8,  10, 8,  'B1', '2026-11-18 21:30:00', 2, 'completed'),
    (16, 9,  11, 9,  'P1', '2026-11-29 19:00:00', 6, 'confirmed');

INSERT INTO orders (order_id, reservation_id, menu_item_id, quantity) VALUES
    (1,  1,  1,  2),
    (2,  1,  2,  1),
    (3,  1,  3,  2),
    (4,  2,  4,  2),
    (5,  2,  5,  1),
    (6,  3,  6,  2),
    (7,  3,  15, 1),
    (8,  4,  7,  2),
    (9,  4,  8,  2),
    (10, 6,  10, 2),
    (11, 7,  11, 2),
    (12, 9,  13, 3),
    (13, 10, 14, 2),
    (14, 12, 5,  2),
    (15, 11, 1,  4),
    (16, 15, 12, 2),
    (17, 13, 6,  2);
