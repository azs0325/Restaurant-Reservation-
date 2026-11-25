"""
queries.py  —  one SQL query per feature of the app.

Rules:
  - SELECT only (the app never changes the data).
  - User input goes in :name placeholders, never pasted into the string.
  - Label each query with its feature and say if it is simple or advanced
    (advanced = JOIN, GROUP BY + COUNT/SUM/AVG/MAX/MIN, HAVING, or a subquery).
"""

# Feature 1 (simple): A customer can see the menu of a restaurant, cheapest first.
RESTAURANT_MENU = """
    SELECT name, price
    FROM menu_items
    WHERE restaurant_id = :restaurant_id
    ORDER BY price
"""

# Feature 2 (advanced: JOIN + GROUP BY with SUM):
# A customer can see the total bill of each of their reservations.
CUSTOMER_BILLS = """
    SELECT r.reservation_id,
           res.name                     AS restaurant,
           r.start_time,
           SUM(o.quantity * m.price)    AS total_price
    FROM reservations r
    JOIN customers   c   ON c.customer_id     = r.customer_id
    JOIN restaurants res ON res.restaurant_id = r.restaurant_id
    JOIN orders      o   ON o.reservation_id  = r.reservation_id
    JOIN menu_items  m   ON m.menu_item_id    = o.menu_item_id
    WHERE c.email = :email
    GROUP BY r.reservation_id
    ORDER BY r.start_time
"""

# Zeta's Feature 1 (advanced: JOIN): Restaurants Offering a Specific Dietary Tag
# A customer can find all restaurants that offer a chosen dietary tag (such
# as 'vegan', 'vegetarian', or 'halal'), ordered alphabetically by restaurant name.

RESTAURANTS_BY_DIETARY_TAG = """
    SELECT r.restaurant_id,
           r.name,
           r.city
    FROM restaurants r
    JOIN restaurant_dietary_tags d
      ON d.restaurant_id = r.restaurant_id
    WHERE LOWER(d.tag) = LOWER(:tag)
    ORDER BY r.name ASC
"""
# Zeta's Feature 2 (advanced: NOT EXISTS): Menu Items Free of a Specific Allergen
# A customer can see menu items at a chosen restaurant that do not 
# contain a specific allergen (such as 'peanut', 'dairy', or 'shellfish'),
# including items that have no allergen entries recorded.
MENU_ITEMS_WITHOUT_ALLERGEN = """
    SELECT m.menu_item_id,
           m.name,
           m.price
    FROM menu_items m
    WHERE m.restaurant_id = :restaurant_id
      AND NOT EXISTS (
          SELECT 1
          FROM menu_item_allergens a
          WHERE a.menu_item_id = m.menu_item_id
            AND LOWER(a.allergen) = LOWER(:allergen)
      )
    ORDER BY m.price ASC, m.name ASC
"""

# Zeta's Feature 3 (simple):A manager or staff member can view the
# roster of staff at a specific restaurant (:restaurant_id), showing 
# each person's ID, name, role, and hire date.
STAFF_ROSTER_BY_RESTAURANT = """
    SELECT staff_id,
           name,
           role,
           hire_date
    FROM staff
    WHERE restaurant_id = :restaurant_id
    ORDER BY role ASC, hire_date ASC, name ASC
"""

# Zeta's Feature 4 (simple): Price Range Filter for Menu Items
# Filters menu items within a price range at a specific restaurant 
RESTAURANT_MENU_BY_PRICE_RANGE = """
    SELECT menu_item_id,
           name,
           price
    FROM menu_items
    WHERE restaurant_id = :restaurant_id
      AND price >= :min_price
      AND price <= :max_price
    ORDER BY price ASC, name ASC
"""

# TODO: add the remaining features (at least 8 in total, at least 4 advanced).

# Unpopular menu items for a certain restaurant on completed reservations ADV
UNSOLD_MENU_ITEMS_AT_RESTAURANT = """
    SELECT m.menu_item_id,
           m.name,
           m.price
    FROM menu_items m
    WHERE m.restaurant_id = :restaurant_id
      AND NOT EXISTS (
          SELECT 1
          FROM orders o
          JOIN reservations r ON r.reservation_id = o.reservation_id
          WHERE o.menu_item_id = m.menu_item_id
            AND r.status = 'completed'
      )
    ORDER BY m.price ASC, m.name ASC
"""

# Untried dishes at a restaurant for a certain customer ADV
UNTRIED_ITEMS_AT_RESTAURANT = """
    SELECT m.menu_item_id,
           m.name,
           m.price
    FROM menu_items m
    WHERE m.restaurant_id = :restaurant_id
      AND EXISTS (
          SELECT 1
          FROM customers c
          WHERE LOWER(c.email) = LOWER(:email)
      )
      AND NOT EXISTS (
          SELECT 1
          FROM orders o
          JOIN reservations r ON r.reservation_id = o.reservation_id
          JOIN customers c    ON c.customer_id    = r.customer_id
          WHERE o.menu_item_id = m.menu_item_id
            AND r.status = 'completed'
            AND LOWER(c.email) = LOWER(:email)
      )
    ORDER BY m.price ASC, m.name ASC
"""

# Tables for a certain restaurant with a certain party size SIMPLE
SUITABLE_TABLES_FOR_PARTY = """
    SELECT table_label,
           seats,
           zone
    FROM tables
    WHERE restaurant_id = :restaurant_id
      AND seats >= :party_size
    ORDER BY seats ASC, table_label ASC
"""

# Find a dish by a given keyword (ex. chicken, lasagna etc) SIMPLE
SEARCH_DISHES_BY_KEYWORD = """
    SELECT menu_item_id,
           restaurant_id,
           name,
           price
    FROM menu_items
    WHERE LOWER(name) LIKE LOWER(:keyword_pattern)
    ORDER BY price ASC, name ASC
"""
