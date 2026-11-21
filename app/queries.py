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

# TODO: add the remaining features (at least 8 in total, at least 4 advanced).
