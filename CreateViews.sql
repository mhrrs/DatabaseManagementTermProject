-- Developed by Michael Harris 
USE Pizzeria;

CREATE VIEW ToppingPopularity AS
SELECT 
  t.toppingName,
  CAST(COUNT(*) AS DECIMAL(10,2)) AS popularity
FROM Pizzeria.pizzatopping AS pt
JOIN Pizzeria.topping AS t ON pt.pizzatoppingToppingsID = t.toppingID
GROUP BY t.toppingName
ORDER BY popularity DESC;



CREATE VIEW ProfitByPizza AS
SELECT 
    bp.basepriceCrust as "Pizza Crust",
    bp.basepriceSize as "Pizza Size", 
    SUM(p.pizzaPrice - p.pizzaCost) AS "Profit", 
    MAX(o.ordersTimeStamp) as "LastOrderDate"
FROM Pizzeria.orders AS o
JOIN Pizzeria.pizzaorder AS po ON o.ordersID = po.pizzaorderOrdersID
JOIN Pizzeria.pizza AS p ON po.pizzaorderPizzaID = p.pizzaID
JOIN Pizzeria.basepricepizza AS bp ON p.pizzaBasePricePizzaID = bp.basepriceID
GROUP BY bp.basepriceSize, bp.basepriceCrust
ORDER BY `Profit` DESC;



CREATE VIEW ProfitByOrderType AS
SELECT o.ordersDeliveryType as "customerType", 
date_format(o.ordersTimeStamp, '%Y-%M') as "OrderMonth", 
SUM(o.ordersPrice) AS "TotalOrderPrice", 
SUM(o.ordersCost) AS "TotalOrderCost", 
SUM(o.ordersPrice - o.ordersCost) AS "Profit"
FROM Pizzeria.orders AS o
GROUP BY o.ordersDeliveryType, date_format(o.ordersTimeStamp, '%Y-%M-%d')

UNION ALL

SELECT 
  '' as "customerType", 
  'Grand Total' as "OrderMonth", 
  SUM(o.ordersPrice) AS "TotalOrderPrice", 
  SUM(o.ordersCost) AS "TotalOrderCost", 
  SUM(o.ordersPrice - o.ordersCost) AS "Profit"
FROM Pizzeria.orders AS o;