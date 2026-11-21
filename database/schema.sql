-- =====================================================================
--  schema.sql  —  creates every table of the restaurant reservations app
-- =====================================================================
--  Reduced from our ER diagram (7 entity sets, 8 relationship sets).
--
--  Reduction rules used:
--    - Each strong entity set becomes a table with its own key.
--    - The weak entity set Tables gets the key of its owner
--      (restaurant_id) plus its partial key (table_label).
--    - Each one-to-many relationship becomes a FOREIGN KEY on the
--      "many" side; no separate table is needed.
--    - Total participation on the "many" side becomes NOT NULL.
--    - Each multivalued attribute becomes its own table.
--    - Composite attribute full_name is stored as its parts
--      (first_name, last_name).
--    - Derived attributes (table_count, time_elapsed, years_employed,
--      total_price) are not stored; queries compute them.
--
--  Order matters: a table is created before any table that refers to it.
--  Build with:  sqlite3 -bail :memory: ".read database/build.sql"
-- =====================================================================

-- Entity set: Restaurant
CREATE TABLE restaurants (
    restaurant_id   INTEGER PRIMARY KEY,
    name            TEXT    NOT NULL,
    city            TEXT    NOT NULL
);

-- Multivalued attribute: Restaurant.dietary_tags
CREATE TABLE restaurant_dietary_tags (
    restaurant_id   INTEGER NOT NULL,
    tag             TEXT    NOT NULL,
    PRIMARY KEY (restaurant_id, tag),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants (restaurant_id)
);

-- Weak entity set: Table, identified through "has" by its Restaurant
-- (one restaurant has many tables; every table belongs to one restaurant).
CREATE TABLE tables (
    restaurant_id   INTEGER NOT NULL,
    table_label     TEXT    NOT NULL,       -- partial key
    seats           INTEGER NOT NULL CHECK (seats > 0),
    zone            TEXT,
    PRIMARY KEY (restaurant_id, table_label),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants (restaurant_id)
);

-- Entity set: Customer
CREATE TABLE customers (
    customer_id     INTEGER PRIMARY KEY,
    first_name      TEXT    NOT NULL,
    last_name       TEXT    NOT NULL,
    email           TEXT    NOT NULL UNIQUE
);

-- Multivalued attribute: Customer.phone
CREATE TABLE customer_phones (
    customer_id     INTEGER NOT NULL,
    phone           TEXT    NOT NULL,
    PRIMARY KEY (customer_id, phone),
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
);

-- Entity set: Staff, plus relationship "employs"
-- (one restaurant employs many staff; every staff member works at one).
CREATE TABLE staff (
    staff_id        INTEGER PRIMARY KEY,
    restaurant_id   INTEGER NOT NULL,
    name            TEXT    NOT NULL,
    role            TEXT    NOT NULL,
    hire_date       DATE    NOT NULL,
    -- Lets reservations reference (staff_id, restaurant_id) together,
    -- so a reservation's staff member must work at that restaurant.
    UNIQUE (staff_id, restaurant_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants (restaurant_id)
);

-- Entity set: Menu_Item, plus relationship "offers"
-- (one restaurant offers many items; every item belongs to one).
CREATE TABLE menu_items (
    menu_item_id    INTEGER PRIMARY KEY,
    restaurant_id   INTEGER NOT NULL,
    name            TEXT    NOT NULL,
    price           REAL    NOT NULL CHECK (price >= 0),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants (restaurant_id)
);

-- Multivalued attribute: Menu_Item.allergens
CREATE TABLE menu_item_allergens (
    menu_item_id    INTEGER NOT NULL,
    allergen        TEXT    NOT NULL,
    PRIMARY KEY (menu_item_id, allergen),
    FOREIGN KEY (menu_item_id) REFERENCES menu_items (menu_item_id)
);

-- Entity set: Reservation, plus three relationships, all total on
-- the Reservation side:
--   "makes"  (one customer makes many reservations)
--   "serves" (one staff member serves many reservations)
--   "books"  (one table is booked by many reservations)
-- The staff member and the table share restaurant_id, so both must
-- belong to the same restaurant.
CREATE TABLE reservations (
    reservation_id  INTEGER PRIMARY KEY,
    customer_id     INTEGER NOT NULL,
    staff_id        INTEGER NOT NULL,
    restaurant_id   INTEGER NOT NULL,
    table_label     TEXT    NOT NULL,
    start_time      DATETIME NOT NULL,
    party_size      INTEGER NOT NULL CHECK (party_size > 0),
    status          TEXT    NOT NULL
                    CHECK (status IN ('confirmed', 'completed', 'cancelled', 'no_show')),
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
    FOREIGN KEY (staff_id, restaurant_id)
                              REFERENCES staff (staff_id, restaurant_id),
    FOREIGN KEY (restaurant_id, table_label)
                              REFERENCES tables (restaurant_id, table_label)
);

-- Entity set: Order, plus relationships "contains" and "selects"
-- (one reservation contains many orders; one menu item is selected
-- by many orders; every order has exactly one of each).
CREATE TABLE orders (
    order_id        INTEGER PRIMARY KEY,
    reservation_id  INTEGER NOT NULL,
    menu_item_id    INTEGER NOT NULL,
    quantity        INTEGER NOT NULL CHECK (quantity > 0),
    FOREIGN KEY (reservation_id) REFERENCES reservations (reservation_id),
    FOREIGN KEY (menu_item_id)   REFERENCES menu_items (menu_item_id)
);
