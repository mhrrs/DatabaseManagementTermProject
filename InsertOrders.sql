USE Pizzeria;

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

-- ADD IN DINEIN? 


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
SET ordersPrice = 6 * 10.60, ordersCost = 6 * 3.23
WHERE ordersID = 
(SELECT ordersID FROM (SELECT MAX(ordersID) AS ordersID FROM Pizzeria.orders) AS T1);

INSERT INTO Pizzeria.pickup(pickupID, pickupName, pickupPhone)
values ((SELECT MAX(ordersID) from orders), "Andrew Wilkes-Krier", "864-254-5861");


-- Order 4 --------------------------------------------------------------------------------------------------------------------------------------------------
-- orders table
INSERT INTO Pizzeria.orders(ordersTimeStamp, ordersPrice, ordersCost, ordersIsComplete, ordersDeliveryType)
VALUES ("2023-04-20 19:11:00", 0.0, 0.0, 1, "pickup");

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
values ((SELECT MAX(ordersID) from orders), "Andrew Wilkes-Krier", (SELECT pickupPhone from pickup where pickupName = deliveryName LIMIT 1), "115 Party Blvd", "Anderson", "SC", "29621");

-- update orders price and cost
UPDATE Pizzeria.orders
SET ordersPrice = 14+17.00+17.00, ordersCost = 5.59+5.68+5.59
WHERE ordersID = 
(SELECT ordersID FROM (SELECT MAX(ordersID) AS ordersID FROM Pizzeria.orders) AS T1);

-- Order 5 --------------------------------------------------------------------------------------------------------------------------------------------------
-- orders table
INSERT INTO Pizzeria.orders(ordersTimeStamp, ordersPrice, ordersCost, ordersIsComplete, ordersDeliveryType)
VALUES ("2023-04-20 19:11:00", 0.0, 0.0, 1, "pickup");

INSERT INTO Pizzeria.pizza(pizzaPrice, pizzaCost, pizzaState, pizzaBasePricePizzaID)
VALUES (16.85, 5.68, 1, (SELECT basepriceID from basepricepizza WHERE basepriceCrust = "Gluten-Free" and basepriceSize = "XLarge" ));

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
SET ordersPrice = 16.85, ordersCost = 5.68
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