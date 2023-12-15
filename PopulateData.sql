-- Developed by Michael Harris 
USE Pizzeria;

INSERT INTO topping (toppingName, toppingPrice, toppingCost, toppingInventory, toppingSmall, toppingMedium, toppingLarge, toppingXlarge)
VALUES
    ('Pepperoni', 1.25, 0.2, 100, 2, 2.75, 3.5, 4.5),
    ('Sausage', 1.25, 0.15, 100, 2.5, 3, 3.5, 4.25),
    ('Ham', 1.5, 0.15, 78, 2, 2.5, 3.25, 4),
    ('Chicken', 1.75, 0.25, 56, 1.5, 2, 2.25, 3),
    ('Green Pepper', 0.5, 0.02, 79, 1, 1.5, 2, 2.5),
    ('Onion', 0.5, 0.02, 85, 1, 1.5, 2, 2.75),
    ('Roma Tomato', 0.75, 0.03, 86, 2, 3, 3.5, 4.5),
    ('Mushrooms', 0.75, 0.1, 52, 1.5, 2, 2.5, 3),
    ('Black Olives', 0.6, 0.1, 39, 0.75, 1, 1.5, 2),
    ('Pineapple', 1, 0.25, 15, 1, 1.25, 1.75, 2),
    ('Jalapenos', 0.5, 0.05, 64, 0.5, 0.75, 1.25, 1.75),
    ('Banana Peppers', 0.5, 0.05, 36, 0.6, 1, 1.3, 1.75),
    ('Regular Cheese', 1.5, 0.12, 250, 2, 3.5, 5, 7),
    ('Four Cheese Blend', 2, 0.15, 150, 2, 3.5, 5, 7),
    ('Feta Cheese', 2, 0.18, 75, 1.75, 3, 4, 5.5),
    ('Goat Cheese', 2, 0.2, 54, 1.6, 2.75, 4, 5.5),
    ('Bacon', 1.5, 0.25, 89, 1, 1.5, 2, 3);



INSERT INTO discount (discountName, discountPercentageOff, discountDollarAmountOff)
VALUES
    ('Employee', 15, NULL),
    ('Lunch Special Medium', NULL, 1.00),
    ('Lunch Special Large', NULL, 2.00),
    ('Specialty Pizza', NULL, 1.50),
    ('Gameday Special', NULL, 2.00),
    ('Happy Hour', 10, NULL);


INSERT INTO basepricepizza (basepriceSize, basepriceCrust, basepricePrice, basepriceCost)
VALUES
    ('Small', 'Thin', 3, 0.5),
    ('Small', 'Original', 3, 0.75),
    ('Small', 'Pan', 3.5, 1),
    ('Small', 'Gluten-Free', 4, 2),
    ('Medium', 'Thin', 5, 1),
    ('Medium', 'Original', 5, 1.5),
    ('Medium', 'Pan', 6, 2.25),
    ('Medium', 'Gluten-Free', 6.25, 3),
    ('Large', 'Thin', 8, 1.25),
    ('Large', 'Original', 8, 2),
    ('Large', 'Pan', 9, 3),
    ('Large', 'Gluten-Free', 9.5, 4),
    ('XLarge', 'Thin', 10, 2),
    ('XLarge', 'Original', 10, 3),
    ('XLarge', 'Pan', 11.5, 4.5),
    ('XLarge', 'Gluten-Free', 12.5, 6);

-- ORDER 1: ---------------------------------------------------------------------------------------------------------------------
-- orders table 
INSERT INTO Pizzeria.orders(ordersTimeStamp, ordersPrice, ordersCost, ordersIsComplete, ordersDeliveryType)
VALUES ("2023-03-05 12:03:00", 13.50, 3.68, 1, "dinein");

-- pizza table 
INSERT INTO Pizzeria.pizza(pizzaPrice, pizzaCost, pizzaState, pizzaBasePricePizzaID)
VALUES (13.50, 3.68, 1, (SELECT  basepriceID from basepricepizza WHERE basepriceCrust = "Thin" and basepriceSize = "Large" ));

-- pizzaorders table 
INSERT INTO Pizzeria.pizzaorder(pizzaorderPizzaID, pizzaorderOrdersID)
values ((SELECT MAX(pizzaID) FROM pizza), (SELECT MAX(ordersID) FROM orders));

-- pizzatopping table
INSERT INTO Pizzeria.pizzatopping(pizzatoppingPizzaID, pizzatoppingToppingsID, pizzatoppingExtra)
VALUES ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Regular Cheese"), True),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Pepperoni"), False),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Sausage"), False); 

-- pizzadiscount table
INSERT INTO Pizzeria.pizzadiscount(pizzadiscountPizzaID, pizzadiscountDiscountID)
values ((SELECT MAX(pizzaID) from pizza), (SELECT discountID from discount WHERE discountName = "Lunch Special Large"));

-- ORDER 2: ---------------------------------------------------------------------------------------------------------------------
-- orders table
INSERT INTO Pizzeria.orders(ordersTimeStamp, ordersPrice, ordersCost, ordersIsComplete, ordersDeliveryType)
VALUES ("2023-04-03 12:05:00", 0.0, 0.0, 1, "dinein");

-- pizza table (pizza 1)
INSERT INTO Pizzeria.pizza(pizzaPrice, pizzaCost, pizzaState, pizzaBasePricePizzaID)
VALUES (10.60, 3.23, 1, (SELECT basepriceID from basepricepizza WHERE basepriceCrust = "Pan" and basepriceSize = "Medium" ));

-- pizzatopping table
INSERT INTO Pizzeria.pizzatopping(pizzatoppingPizzaID, pizzatoppingToppingsID, pizzatoppingExtra)
VALUES ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Feta Cheese"), False),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Black Olives"), False),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Roma Tomato"), False),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Mushrooms"), False),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Banana Peppers"), False);

-- pizzaorders table
INSERT INTO Pizzeria.pizzaorder(pizzaorderPizzaID, pizzaorderOrdersID)
values ((SELECT MAX(pizzaID) FROM pizza), (SELECT MAX(ordersID) FROM orders));

-- update orders price and cost
UPDATE Pizzeria.orders
SET ordersPrice = ordersPrice + 10.60, ordersCost = ordersCost + 3.23
WHERE ordersID = 
(SELECT ordersID FROM (SELECT MAX(ordersID) AS ordersID FROM Pizzeria.orders) AS T1);

-- pizzadiscount table
INSERT INTO Pizzeria.pizzadiscount(pizzadiscountPizzaID, pizzadiscountDiscountID)
values ((SELECT MAX(pizzaID) from pizza), (SELECT discountID from discount WHERE discountName = "Specialty Pizza")), 
       ((SELECT MAX(pizzaID) from pizza), (SELECT discountID from discount WHERE discountName = "Lunch Special Medium"));

-- pizza table (pizza 2)
INSERT INTO Pizzeria.pizza(pizzaPrice, pizzaCost, pizzaState, pizzaBasePricePizzaID)
VALUES (6.75, 1.40, 1, (SELECT basepriceID from basepricepizza WHERE basepriceCrust = "Original" and basepriceSize = "Small" ));

-- pizzatopping table
INSERT INTO Pizzeria.pizzatopping(pizzatoppingPizzaID, pizzatoppingToppingsID, pizzatoppingExtra)
VALUES ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Regular Cheese"), False),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Chicken"), False),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Banana Peppers"), False);
       
-- pizzaorders table
INSERT INTO Pizzeria.pizzaorder(pizzaorderPizzaID, pizzaorderOrdersID)
values ((SELECT MAX(pizzaID) FROM pizza), (SELECT MAX(ordersID) FROM orders));

-- update orders price and cost
UPDATE Pizzeria.orders
SET ordersPrice = ordersPrice + 6.75, ordersCost = ordersCost + 1.40
WHERE ordersID = 
(SELECT ordersID FROM (SELECT MAX(ordersID) AS ordersID FROM Pizzeria.orders) AS T2);

-- insert into dinein table
INSERT INTO Pizzeria.dinein(dineinID, dineinTableNumber)
values ((SELECT MAX(ordersID) from orders), 4); 


-- ORDER 3: ---------------------------------------------------------------------------------------------------------------------
-- orders table
INSERT INTO Pizzeria.orders(ordersTimeStamp, ordersPrice, ordersCost, ordersIsComplete, ordersDeliveryType)
VALUES ("2023-03-03 21:30:00", 0.0, 0.0, 1, "pickup");

-- pizza table (pizza 1)
INSERT INTO Pizzeria.pizza(pizzaPrice, pizzaCost, pizzaState, pizzaBasePricePizzaID)
VALUES (10.75, 3.30, 1, (SELECT basepriceID from basepricepizza WHERE basepriceCrust = "Original" and basepriceSize = "Large" ));

-- pizzatopping table
INSERT INTO Pizzeria.pizzatopping(pizzatoppingPizzaID, pizzatoppingToppingsID, pizzatoppingExtra)
VALUES ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Regular Cheese"), False),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Pepperoni"), False);

-- pizzaorders table
INSERT INTO Pizzeria.pizzaorder(pizzaorderPizzaID, pizzaorderOrdersID)
values ((SELECT MAX(pizzaID) FROM pizza), (SELECT MAX(ordersID) FROM orders));

-- pizza table (pizza 2)
INSERT INTO Pizzeria.pizza(pizzaPrice, pizzaCost, pizzaState, pizzaBasePricePizzaID)
VALUES (10.75, 3.30, 1, (SELECT basepriceID from basepricepizza WHERE basepriceCrust = "Original" and basepriceSize = "Large" ));

-- pizzatopping table
INSERT INTO Pizzeria.pizzatopping(pizzatoppingPizzaID, pizzatoppingToppingsID, pizzatoppingExtra)
VALUES ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Regular Cheese"), False),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Pepperoni"), False);

-- pizzaorders table
INSERT INTO Pizzeria.pizzaorder(pizzaorderPizzaID, pizzaorderOrdersID)
values ((SELECT MAX(pizzaID) FROM pizza), (SELECT MAX(ordersID) FROM orders));

-- pizza table (pizza 3)
INSERT INTO Pizzeria.pizza(pizzaPrice, pizzaCost, pizzaState, pizzaBasePricePizzaID)
VALUES (10.75, 3.30, 1, (SELECT basepriceID from basepricepizza WHERE basepriceCrust = "Original" and basepriceSize = "Large" ));

-- pizzatopping table
INSERT INTO Pizzeria.pizzatopping(pizzatoppingPizzaID, pizzatoppingToppingsID, pizzatoppingExtra)
VALUES ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Regular Cheese"), False),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Pepperoni"), False);

-- pizzaorders table
INSERT INTO Pizzeria.pizzaorder(pizzaorderPizzaID, pizzaorderOrdersID)
values ((SELECT MAX(pizzaID) FROM pizza), (SELECT MAX(ordersID) FROM orders));

-- pizza table (pizza 4)
INSERT INTO Pizzeria.pizza(pizzaPrice, pizzaCost, pizzaState, pizzaBasePricePizzaID)
VALUES (10.75, 3.30, 1, (SELECT basepriceID from basepricepizza WHERE basepriceCrust = "Original" and basepriceSize = "Large" ));

-- pizzatopping table
INSERT INTO Pizzeria.pizzatopping(pizzatoppingPizzaID, pizzatoppingToppingsID, pizzatoppingExtra)
VALUES ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Regular Cheese"), False),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Pepperoni"), False);

-- pizzaorders table
INSERT INTO Pizzeria.pizzaorder(pizzaorderPizzaID, pizzaorderOrdersID)
values ((SELECT MAX(pizzaID) FROM pizza), (SELECT MAX(ordersID) FROM orders));

-- pizza table (pizza 5)
INSERT INTO Pizzeria.pizza(pizzaPrice, pizzaCost, pizzaState, pizzaBasePricePizzaID)
VALUES (10.75, 3.30, 1, (SELECT basepriceID from basepricepizza WHERE basepriceCrust = "Original" and basepriceSize = "Large" ));

-- pizzatopping table
INSERT INTO Pizzeria.pizzatopping(pizzatoppingPizzaID, pizzatoppingToppingsID, pizzatoppingExtra)
VALUES ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Regular Cheese"), False),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Pepperoni"), False);

-- pizzaorders table
INSERT INTO Pizzeria.pizzaorder(pizzaorderPizzaID, pizzaorderOrdersID)
values ((SELECT MAX(pizzaID) FROM pizza), (SELECT MAX(ordersID) FROM orders));

-- pizza table (pizza 6)
INSERT INTO Pizzeria.pizza(pizzaPrice, pizzaCost, pizzaState, pizzaBasePricePizzaID)
VALUES (10.75, 3.30, 1, (SELECT basepriceID from basepricepizza WHERE basepriceCrust = "Original" and basepriceSize = "Large" ));

-- pizzatopping table
INSERT INTO Pizzeria.pizzatopping(pizzatoppingPizzaID, pizzatoppingToppingsID, pizzatoppingExtra)
VALUES ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Regular Cheese"), False),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Pepperoni"), False);

-- pizzaorders table
INSERT INTO Pizzeria.pizzaorder(pizzaorderPizzaID, pizzaorderOrdersID)
values ((SELECT MAX(pizzaID) FROM pizza), (SELECT MAX(ordersID) FROM orders));

-- update orders price and cost
UPDATE Pizzeria.orders
SET ordersPrice = 6 * 10.75, ordersCost = 6 * 3.30
WHERE ordersID = 
(SELECT ordersID FROM (SELECT MAX(ordersID) AS ordersID FROM Pizzeria.orders) AS T1);

INSERT INTO Pizzeria.pickup(pickupID, pickupName, pickupPhone)
values ((SELECT MAX(ordersID) from orders), "Andrew Wilkes-Krier", "864-254-5861");


-- Order 4 --------------------------------------------------------------------------------------------------------------------------------------------------
-- orders table
INSERT INTO Pizzeria.orders(ordersTimeStamp, ordersPrice, ordersCost, ordersIsComplete, ordersDeliveryType)
VALUES ("2023-04-20 19:11:00", 0.0, 0.0, 1, "delivery");

-- pizza table (pizza 1)
INSERT INTO Pizzeria.pizza(pizzaPrice, pizzaCost, pizzaState, pizzaBasePricePizzaID)
VALUES (14.50, 5.59, 1, (SELECT basepriceID from basepricepizza WHERE basepriceCrust = "Original" and basepriceSize = "XLarge" ));

INSERT INTO Pizzeria.pizzatopping(pizzatoppingPizzaID, pizzatoppingToppingsID, pizzatoppingExtra)
VALUES ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Sausage"), False),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Pepperoni"), False),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Four Cheese Blend"), False);
       
-- pizzaorders table
INSERT INTO Pizzeria.pizzaorder(pizzaorderPizzaID, pizzaorderOrdersID)
values ((SELECT MAX(pizzaID) FROM pizza), (SELECT MAX(ordersID) FROM orders));

-- pizza table (pizza 2)
INSERT INTO Pizzeria.pizza(pizzaPrice, pizzaCost, pizzaState, pizzaBasePricePizzaID)
VALUES (17.00, 5.59, 1, (SELECT basepriceID from basepricepizza WHERE basepriceCrust = "Original" and basepriceSize = "XLarge" ));

INSERT INTO Pizzeria.pizzatopping(pizzatoppingPizzaID, pizzatoppingToppingsID, pizzatoppingExtra)
VALUES ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Ham"), True),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Pineapple"), True),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Four Cheese Blend"), False);
       
-- pizzadiscounts
INSERT INTO Pizzeria.pizzadiscount(pizzadiscountPizzaID, pizzadiscountDiscountID)
values((SELECT MAX(pizzaID) from pizza), (SELECT discountID from discount WHERE discountName = "Specialty Pizza"));
       
-- pizzaorders table
INSERT INTO Pizzeria.pizzaorder(pizzaorderPizzaID, pizzaorderOrdersID)
values ((SELECT MAX(pizzaID) FROM pizza), (SELECT MAX(ordersID) FROM orders));

-- pizza table (pizza 3)
INSERT INTO Pizzeria.pizza(pizzaPrice, pizzaCost, pizzaState, pizzaBasePricePizzaID)
VALUES (14.00, 5.68, 1, (SELECT basepriceID from basepricepizza WHERE basepriceCrust = "Original" and basepriceSize = "XLarge" ));

INSERT INTO Pizzeria.pizzatopping(pizzatoppingPizzaID, pizzatoppingToppingsID, pizzatoppingExtra)
VALUES ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Jalapenos"), False),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Four Cheese Blend"), False),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Bacon"), False);
       
-- pizzaorders table
INSERT INTO Pizzeria.pizzaorder(pizzaorderPizzaID, pizzaorderOrdersID)
values ((SELECT MAX(pizzaID) FROM pizza), (SELECT MAX(ordersID) FROM orders));

-- odiscounts table
INSERT INTO Pizzeria.odiscount(odiscountOrdersID, odiscountDiscountID)
values((SELECT MAX(ordersID) from orders), (SELECT discountID from discount WHERE discountName = "Gameday Special"));

-- delivery table
INSERT INTO Pizzeria.delivery (deliveryID, deliveryName, deliveryPhone, deliveryAddress, deliveryCity, deliveryState, deliveryZip)
values ((SELECT MAX(ordersID) from orders), "Andrew Wilkes-Krier", (SELECT pickupPhone from pickup where pickupName = deliveryName), "115 Party Blvd", "Anderson", "SC", "29621");

-- update orders price and cost
UPDATE Pizzeria.orders
SET ordersPrice = 14.50+14.00+17.00, ordersCost = 5.59+5.68+5.59
WHERE ordersID = 
(SELECT ordersID FROM (SELECT MAX(ordersID) AS ordersID FROM Pizzeria.orders) AS T1);

-- Order 5 --------------------------------------------------------------------------------------------------------------------------------------------------
-- orders table
INSERT INTO Pizzeria.orders(ordersTimeStamp, ordersPrice, ordersCost, ordersIsComplete, ordersDeliveryType)
VALUES ("2023-03-02 17:30:00", 0.0, 0.0, 1, "pickup");

INSERT INTO Pizzeria.pizza(pizzaPrice, pizzaCost, pizzaState, pizzaBasePricePizzaID)
VALUES (16.85, 7.85, 1, (SELECT basepriceID from basepricepizza WHERE basepriceCrust = "Gluten-Free" and basepriceSize = "XLarge" ));

INSERT INTO Pizzeria.pizzatopping(pizzatoppingPizzaID, pizzatoppingToppingsID, pizzatoppingExtra)
VALUES ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Onion"), False),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Goat Cheese"), False),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Roma Tomato"), False),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Mushrooms"), False),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Black Olives"), False),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Green Pepper"), False);
       
-- pizzaorders table
INSERT INTO Pizzeria.pizzaorder(pizzaorderPizzaID, pizzaorderOrdersID)
values ((SELECT MAX(pizzaID) FROM pizza), (SELECT MAX(ordersID) FROM orders));

-- pickup table
INSERT INTO Pizzeria.pickup(pickupID, pickupName, pickupPhone)
values ((SELECT MAX(ordersID) from orders), "Matt Engers", "864-474-9953");

-- pizzadiscounts
INSERT INTO Pizzeria.pizzadiscount(pizzadiscountPizzaID, pizzadiscountDiscountID)
values((SELECT MAX(pizzaID) from pizza), (SELECT discountID from discount WHERE discountName = "Specialty Pizza"));

-- update orders price and cost
UPDATE Pizzeria.orders
SET ordersPrice = 16.85, ordersCost = 7.85
WHERE ordersID = 
(SELECT ordersID FROM (SELECT MAX(ordersID) AS ordersID FROM Pizzeria.orders) AS T1);


-- order 6 --------------------------------------------------------------------------------------------------------------------------------------
-- orders table
INSERT INTO Pizzeria.orders(ordersTimeStamp, ordersPrice, ordersCost, ordersIsComplete, ordersDeliveryType)
VALUES ("2023-03-02 18:17:00", 0.0, 0.0, 1, "delivery");

INSERT INTO Pizzeria.pizza(pizzaPrice, pizzaCost, pizzaState, pizzaBasePricePizzaID)
VALUES (13.25, 3.20, 1, (SELECT basepriceID from basepricepizza WHERE basepriceCrust = "Thin" and basepriceSize = "Large" ));

INSERT INTO Pizzeria.pizzatopping(pizzatoppingPizzaID, pizzatoppingToppingsID, pizzatoppingExtra)
VALUES ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Chicken"), False),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Four Cheese Blend"), True),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Onion"), False),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Mushrooms"), False),
       ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Green Pepper"), False);
       
-- pizzaorders table
INSERT INTO Pizzeria.pizzaorder(pizzaorderPizzaID, pizzaorderOrdersID)
values ((SELECT MAX(pizzaID) FROM pizza), (SELECT MAX(ordersID) FROM orders));

-- update orders price and cost
UPDATE Pizzeria.orders
SET ordersPrice = 13.25, ordersCost = 3.20
WHERE ordersID = 
(SELECT ordersID FROM (SELECT MAX(ordersID) AS ordersID FROM Pizzeria.orders) AS T1);

-- delivery table
INSERT INTO Pizzeria.delivery (deliveryID, deliveryName, deliveryPhone, deliveryAddress, deliveryCity, deliveryState, deliveryZip)
values ((SELECT MAX(ordersID) from orders), "Frank Turner", "864-232-8944", "6745 Wessex St", "Anderson", "SC", "29621");

-- order 7 --------------------------------------------------------------------------------------------------------------------------------------
-- orders table
INSERT INTO Pizzeria.orders(ordersTimeStamp, ordersPrice, ordersCost, ordersIsComplete, ordersDeliveryType)
VALUES ("2023-04-13 20:32:00", 0.0, 0.0, 1, "delivery");

-- pizza table (pizza 1) 
INSERT INTO Pizzeria.pizza(pizzaPrice, pizzaCost, pizzaState, pizzaBasePricePizzaID)
VALUES (12.00, 3.75, 1, (SELECT basepriceID from basepricepizza WHERE basepriceCrust = "Thin" and basepriceSize = "Large" ));

INSERT INTO Pizzeria.pizzatopping(pizzatoppingPizzaID, pizzatoppingToppingsID, pizzatoppingExtra)
VALUES ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Four Cheese Blend"), True);
       
-- pizzaorders table
INSERT INTO Pizzeria.pizzaorder(pizzaorderPizzaID, pizzaorderOrdersID)
values ((SELECT MAX(pizzaID) FROM pizza), (SELECT MAX(ordersID) FROM orders));

-- pizza table (pizza 2) 
INSERT INTO Pizzeria.pizza(pizzaPrice, pizzaCost, pizzaState, pizzaBasePricePizzaID)
VALUES (12.00, 2.55, 1, (SELECT basepriceID from basepricepizza WHERE basepriceCrust = "Thin" and basepriceSize = "Large" ));

INSERT INTO Pizzeria.pizzatopping(pizzatoppingPizzaID, pizzatoppingToppingsID, pizzatoppingExtra)
VALUES ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Pepperoni"), True),
	   ((SELECT MAX(pizzaID) from pizza), (SELECT toppingID from topping WHERE toppingName = "Regular Cheese"), False);
       
-- pizzaorders table
INSERT INTO Pizzeria.pizzaorder(pizzaorderPizzaID, pizzaorderOrdersID)
values ((SELECT MAX(pizzaID) FROM pizza), (SELECT MAX(ordersID) FROM orders));

-- odiscounts table
INSERT INTO Pizzeria.odiscount(odiscountOrdersID, odiscountDiscountID)
values((SELECT MAX(ordersID) from orders), (SELECT discountID from discount WHERE discountName = "Employee"));

-- delivery table
INSERT INTO Pizzeria.delivery (deliveryID, deliveryName, deliveryPhone, deliveryAddress, deliveryCity, deliveryState, deliveryZip)
values ((SELECT MAX(ordersID) from orders), "Milo Auckerman", "864-878-5679", "8879 Suburban Home", "Anderson", "SC", "29621");

-- update orders price and cost
UPDATE Pizzeria.orders
SET ordersPrice = 24.00, ordersCost = 3.75 + 2.55
WHERE ordersID = (SELECT ordersID FROM (SELECT MAX(ordersID) AS ordersID FROM Pizzeria.orders) AS T1);
