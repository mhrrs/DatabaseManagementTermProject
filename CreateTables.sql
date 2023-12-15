-- Developed by Michael Harris 
CREATE schema Pizzeria;
USE Pizzeria;

-- discount Table
CREATE TABLE discount (
  discountID INT PRIMARY KEY AUTO_INCREMENT,
  discountName VARCHAR(50),
  discountDollarAmountOff decimal(5,2),
  discountPercentageOff decimal(5,2)
);

-- customer Table
CREATE TABLE customer (
  customerID INT PRIMARY KEY AUTO_INCREMENT,
  customerFName VARCHAR(50),
  customerLName VARCHAR(50),
  customerPhone VARCHAR(30)
);

-- basepricepizza Table
CREATE TABLE basepricepizza (
  basepriceID INT PRIMARY KEY AUTO_INCREMENT,
  basepriceCost decimal(5,2),
  basepricePrice decimal(5,2),
  basepriceCrust VARCHAR(30),
  basepriceSize VARCHAR(30)
);

-- pizza Table
CREATE TABLE pizza (
  pizzaID INT PRIMARY KEY AUTO_INCREMENT,
  pizzaPrice decimal(5,2),
  pizzaCost decimal(5,2),
  pizzaState VARCHAR(30),
  pizzaBasePricePizzaID INT,
  FOREIGN KEY (pizzaBasePricePizzaID) REFERENCES basepricepizza(basepriceID)
);

-- orders Table
CREATE TABLE orders (
  ordersID INT PRIMARY KEY AUTO_INCREMENT,
  ordersTimeStamp TIMESTAMP,
  ordersPrice decimal(5,2),
  ordersCost decimal(5,2),
  ordersIsComplete int,
  ordersDeliveryType VARCHAR(30),
  customerID INT,
  FOREIGN KEY (customerID) REFERENCES customer(customerID)
);


CREATE TABLE odiscount (
	odiscountOrdersID int,
    odiscountDiscountID int,
    PRIMARY KEY(odiscountOrdersID, odiscountDiscountID),
    FOREIGN KEY (odiscountOrdersID) REFERENCES orders(ordersID),
    FOREIGN KEY (odiscountDiscountID) REFERENCES discount(discountID)
);

CREATE TABLE pizzadiscount (
	pizzadiscountPizzaID int,
    pizzadiscountDiscountID int,
    PRIMARY KEY(pizzadiscountPizzaID, pizzadiscountDiscountID),
    FOREIGN KEY (pizzadiscountPizzaID) REFERENCES pizza(pizzaID),
    FOREIGN KEY (pizzadiscountDiscountID) REFERENCES discount(discountID)
);

-- delivery Types
CREATE TABLE delivery (
  deliveryID INT PRIMARY KEY,
  deliveryName VARCHAR(50),
  deliveryPhone VARCHAR(30),
  deliveryAddress VARCHAR(50),
  deliveryCity VARCHAR(50),
  deliveryState varchar(5),
  deliveryZip VARCHAR(5),
  FOREIGN KEY (deliveryID) REFERENCES orders(ordersID)
);

CREATE TABLE pickup (
  pickupID INT PRIMARY KEY,
  pickupName VARCHAR(50),
  pickupPhone VARCHAR(30),
  FOREIGN KEY (pickupID) REFERENCES orders(ordersID)
);

CREATE TABLE dinein (
  dineinID INT PRIMARY KEY,
  dineinTableNumber INT,
  FOREIGN KEY (dineinID) REFERENCES orders(ordersID)
);

-- topping Table
CREATE TABLE topping (
  toppingID INT PRIMARY KEY AUTO_INCREMENT,
  toppingName VARCHAR(30),
  toppingPrice decimal(5,2),
  toppingCost decimal(5,2),
  toppingInventory decimal(5,2),
  toppingSmall decimal(5,2),
  toppingMedium decimal(5,2),
  toppingLarge decimal(5,2),
  toppingXlarge decimal(5,2)
);

CREATE TABLE pizzatopping (
	pizzatoppingPizzaID int,
    pizzatoppingToppingsID int,
    pizzatoppingExtra Boolean,
    PRIMARY KEY (pizzatoppingPizzaID, pizzatoppingToppingsID),
    FOREIGN KEY (pizzatoppingPizzaID) REFERENCES pizza(pizzaID),
    FOREIGN KEY (pizzatoppingToppingsID) REFERENCES topping(toppingID)
);


CREATE TABLE pizzaorder (
	pizzaorderPizzaID int,
    pizzaorderOrdersID INT,
    PRIMARY KEY( pizzaorderPizzaID, pizzaorderOrdersID),
    FOREIGN KEY (pizzaorderPizzaID) REFERENCES pizza(pizzaID),
    FOREIGN KEY (pizzaorderOrdersID) REFERENCES orders(ordersID)
);
