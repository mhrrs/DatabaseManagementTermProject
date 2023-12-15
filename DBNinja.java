package cpsc4620;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import java.util.Date;
import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;

/*
 * This file is where most of your code changes will occur You will write the code to retrieve
 * information from the database, or save information to the database
 * 
 * The class has several hard coded static variables used for the connection, you will need to
 * change those to your connection information
 * 
 * This class also has static string variables for pickup, delivery and dine-in. If your database
 * stores the strings differently (i.e "pick-up" vs "pickup") changing these static variables will
 * ensure that the comparison is checking for the right string in other places in the program. You
 * will also need to use these strings if you store this as boolean fields or an integer.
 * 
 * 
 */

/**
 * A utility class to help add and retrieve information from the database
 */

public final class DBNinja {
	private static Connection conn;

	// Change these variables to however you record dine-in, pick-up and delivery, and sizes and crusts
	public final static String pickup = "pickup";
	public final static String delivery = "delivery";
	public final static String dine_in = "dinein";

	public final static String size_s = "Small";
	public final static String size_m = "Medium";
	public final static String size_l = "Large";
	public final static String size_xl = "XLarge";

	public final static String crust_thin = "Thin";
	public final static String crust_orig = "Original";
	public final static String crust_pan = "Pan";
	public final static String crust_gf = "Gluten-Free";




	private static boolean connect_to_db() throws SQLException, IOException {
		try {
			conn = DBConnector.make_connection();
			if (conn != null) {
				return true;
			} else {
				System.out.println("Failed to establish a connection.");
				return false;
			}
		} catch (SQLException e) {
			System.out.println("A SQL exception occurred: " + e.getMessage());
			e.printStackTrace();
			return false;
		} catch (IOException e) {
			System.out.println("An IO exception occurred: " + e.getMessage());
			e.printStackTrace();
			return false;
		}
	}



	public static int addOrder(Order o) throws SQLException, IOException {
		// Create a new connection
//		Connection conn = DBConnector.make_connection();
		connect_to_db();
		/*
		 * add code to add the order to the DB. Remember that we're not just
		 * adding the order to the order DB table, but we're also recording
		 * the necessary data for the delivery, dinein, and pickup tables
		 * 
		 */

		String sql = "INSERT INTO orders (ordersTimeStamp, ordersPrice, ordersCost, ordersIsComplete, ordersDeliveryType, customerID) VALUES (CURRENT_TIMESTAMP, ?, ?, ?, ?, ?)";
		PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

		pstmt.setDouble(1, o.getCustPrice());
		pstmt.setDouble(2, o.getBusPrice());
		pstmt.setInt(3, o.getIsComplete());
		pstmt.setString(4, o.getOrderType());
		pstmt.setInt(5, o.getCustID());


		pstmt.executeUpdate();

		int orderID = -1;
		ResultSet rs = pstmt.getGeneratedKeys();
		if (rs.next()) {
			orderID = rs.getInt(1);
		}

		pstmt.close();
		System.out.println("Order added successfully.");
		conn.close();

		return orderID;  // Return the Order ID
	}


	// Method to get the list of pizzas in an order
	public static ArrayList<Pizza> getPizzasInOrder(int orderId) throws SQLException, IOException {
		ArrayList<Pizza> pizzas = new ArrayList<>();
		String sql = "SELECT pizzaorderPizzaID FROM pizzaorder WHERE pizzaorderOrdersID = ?";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, orderId);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			int pizzaId = rs.getInt("pizzaorderPizzaID");
			Pizza pizza = getPizzaById(pizzaId);
			pizzas.add(pizza);
		}
		rs.close();
		pstmt.close();
		return pizzas;
	}

	// Method to get a pizza by its ID
	public static Pizza getPizzaById(int pizzaId) throws SQLException, IOException {
		String sql = "SELECT p.*, b.basepriceCrust, b.basepriceSize, po.pizzaorderOrdersID FROM pizza p " +
				"JOIN basepricepizza b ON p.pizzaBasePricePizzaID = b.basepriceID " +
				"JOIN pizzaorder po ON p.pizzaID = po.pizzaorderPizzaID " +
				"WHERE p.pizzaID = ?";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, pizzaId);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			int oID = rs.getInt("pizzaorderOrdersID");
			Order order = getOrderById(oID);
			Pizza pizza = new Pizza(rs.getInt("pizzaID"), rs.getString("basepriceSize"), rs.getString("basepriceCrust"),
					rs.getInt("pizzaorderOrdersID"), rs.getString("pizzaState"), order.getDate(),
					rs.getDouble("pizzaPrice"), rs.getDouble("pizzaCost"));
			return pizza;
		} else {
			return null;
		}
	}






	// Method to retrieve all open orders
	public static ArrayList<Order> getOpenOrders() throws SQLException, IOException {
		connect_to_db();
		ArrayList<Order> openOrders = new ArrayList<>();
		String sql = "SELECT * FROM orders WHERE ordersIsComplete = 0";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			Order order = new Order(rs.getInt("ordersID"), rs.getInt("customerID"), rs.getString("ordersDeliveryType"),
					rs.getString("ordersTimeStamp"), rs.getDouble("ordersPrice"), rs.getDouble("ordersCost"),
					rs.getInt("ordersIsComplete"));
			openOrders.add(order);
		}
		return openOrders;
	}

	// Method to retrieve all completed orders
	public static ArrayList<Order> getCompletedOrders() throws SQLException, IOException {
		connect_to_db();
		ArrayList<Order> completedOrders = new ArrayList<>();
		String sql = "SELECT * FROM orders WHERE ordersIsComplete = 1";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			Order order = new Order(rs.getInt("ordersID"), rs.getInt("customerID"), rs.getString("ordersDeliveryType"),
					rs.getString("ordersTimeStamp"), rs.getDouble("ordersPrice"), rs.getDouble("ordersCost"),
					rs.getInt("ordersIsComplete"));
			completedOrders.add(order);
		}
		return completedOrders;
	}

	// Method to retrieve all orders since a specific date
	public static ArrayList<Order> getOrdersSinceDate(String date) throws SQLException, IOException {
		connect_to_db();
		ArrayList<Order> orders = new ArrayList<>();
		String sql = "SELECT * FROM orders WHERE ordersTimeStamp >= ?";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, date);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			Order order = new Order(rs.getInt("ordersID"), rs.getInt("customerID"), rs.getString("ordersDeliveryType"),
					rs.getString("ordersTimeStamp"), rs.getDouble("ordersPrice"), rs.getDouble("ordersCost"),
					rs.getInt("ordersIsComplete"));
			orders.add(order);
		}
		return orders;
	}

	// Method to retrieve order by ID
	public static Order getOrderById(int orderId) throws SQLException, IOException {
		connect_to_db();
		String sql = "SELECT * FROM orders WHERE ordersID = ?";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, orderId);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			Order order = new Order(rs.getInt("ordersID"), rs.getInt("customerID"), rs.getString("ordersDeliveryType"),
					rs.getString("ordersTimeStamp"), rs.getDouble("ordersPrice"), rs.getDouble("ordersCost"),
					rs.getInt("ordersIsComplete"));
			return order;
		} else {
			return null;
		}
	}




	public static void addPizzaToOrder(int pizzaID, int orderID) throws SQLException, IOException {
		connect_to_db();
		String sql = "INSERT INTO pizzaorder (pizzaorderPizzaID, pizzaorderOrdersID) VALUES (?, ?)";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, pizzaID);
		pstmt.setInt(2, orderID);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}


	public static void addPizza(Pizza p) throws SQLException, IOException {
		/*
		 * Add the code needed to insert the pizza into into the database.
		 * Keep in mind adding pizza discounts and toppings associated with the pizza,
		 * there are other methods below that may help with that process.
		 * 
		 */

		connect_to_db();
		// Calculate the total price and cost of the toppings
		double toppingsPrice = 0.0;
		double toppingsCost = 0.0;
		for (Topping t : p.getToppings()) {
			// Retrieve the price and cost of the topping from the topping table
			String toppingPriceSql = "SELECT toppingPrice, toppingCost FROM topping WHERE toppingID = ?";
			PreparedStatement toppingPricePstmt = conn.prepareStatement(toppingPriceSql);
			toppingPricePstmt.setInt(1, t.getTopID());
			ResultSet toppingPriceRs = toppingPricePstmt.executeQuery();
			toppingPriceRs.next();
			double toppingPrice = toppingPriceRs.getDouble("toppingPrice");
			double toppingCost = toppingPriceRs.getDouble("toppingCost");
			toppingsPrice += toppingPrice;
			toppingsCost += toppingCost;
		}

		// Calculate the total pizza price and cost
		double pizzaPrice = p.getCustPrice() + toppingsPrice;
		double pizzaCost = p.getBusPrice() + toppingsCost;

		// Set the prices in the Pizza object
		p.setCustPrice(pizzaPrice);
		p.setBusPrice(pizzaCost);


		// Insert the new pizza into the pizza table
		String sql = "INSERT INTO pizza (pizzaPrice, pizzaCost, pizzaState, pizzaBasePricePizzaID) VALUES (?, ?, ?, ?)";
		PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
		pstmt.setDouble(1, pizzaPrice);
		pstmt.setDouble(2, p.getBusPrice());
		pstmt.setString(3, p.getPizzaState());
		pstmt.setInt(4, getBasePriceID(p.getCrustType(), p.getSize()));
		pstmt.executeUpdate();
		ResultSet rs = pstmt.getGeneratedKeys();

		boolean[] extraList = p.getIsDoubleArray();

		if (rs.next()) {
			int pizzaID = rs.getInt(1);
			p.setPizzaID(pizzaID);
			for (int i = 0; i < p.getToppings().size(); i++) {
				Topping t = p.getToppings().get(i);
				boolean extra = extraList[i];
				useTopping(p, t, extra);
			}
		}

		pstmt.close();
		conn.close();
	}

	public static void updatePizzaPrice(Pizza p) throws SQLException, IOException {
		connect_to_db();

		// Fetch associated discounts from pizzadiscount table
		String sqlFetchDiscounts = "SELECT * FROM pizzadiscount WHERE pizzadiscountPizzaID = ?";
		PreparedStatement pstmtFetchDiscounts = conn.prepareStatement(sqlFetchDiscounts);
		pstmtFetchDiscounts.setInt(1, p.getPizzaID());
		ResultSet rs = pstmtFetchDiscounts.executeQuery();

		double pizzaPrice = p.getCustPrice();

		// Collect discounts from ResultSet
		List<Discount> discounts = new ArrayList<>();
		while (rs.next()) {
			int discountID = rs.getInt("pizzadiscountDiscountID");
			Discount discount = getDiscountByID(discountID);
			discounts.add(discount);
		}

		// Sort discounts: percentage first, then fixed
		discounts.sort(Comparator.comparing(Discount::isPercent).reversed());

		connect_to_db();
		// Update the pizza price in the pizza table
		String sqlUpdatePrice = "UPDATE pizza SET pizzaPrice = ? WHERE pizzaID = ?";
		PreparedStatement pstmtUpdatePrice = conn.prepareStatement(sqlUpdatePrice);
		pstmtUpdatePrice.setDouble(1, pizzaPrice);
		pstmtUpdatePrice.setInt(2, p.getPizzaID());
		pstmtUpdatePrice.executeUpdate();

		// Update the pizza price in the Pizza object
		p.setCustPrice(pizzaPrice);

		// Close the connections
		System.out.println(("Discount Updates Price."));
		pstmtFetchDiscounts.close();
		pstmtUpdatePrice.close();
		conn.close();
	}






	public static void useTopping(Pizza p, Topping t, boolean isExtra) throws SQLException, IOException //this method will update toppings inventory in SQL and add entities to the Pizzatops table. Pass in the p pizza that is using t topping
	{
		connect_to_db();
		/*
		 * This method should do 2 two things.
		 * - update the topping inventory every time we use t topping (accounting for extra toppings as well)
		 * - connect the topping to the pizza
		 *   What that means will be specific to your yimplementatinon.
		 * 
		 * Ideally, you should't let toppings go negative....but this should be dealt with BEFORE calling this method.
		 * 
		 */

		double quantityUsed = isExtra ? 2.0 : 1.0; // Subtract double if isDoubled is true

		// Update topping inventory
		String sql = "UPDATE topping SET toppingInventory = toppingInventory - ? WHERE toppingID = ?";
		PreparedStatement pstmt = conn.prepareStatement(sql);

		pstmt.setDouble(1, quantityUsed);
		pstmt.setInt(2, t.getTopID());

		pstmt.executeUpdate();

		// Connect the topping to the pizza
		addToppingToPizza(p.getPizzaID(), t, isExtra);

		pstmt.close();

//		System.out.println("Topping used successfully.");

		conn.close();
	}



	public static void addToppingToPizza(int pizzaID, Topping t, boolean isExtra) throws SQLException, IOException {
		connect_to_db();
		String sql = "INSERT INTO pizzatopping (pizzatoppingPizzaID, pizzatoppingToppingsID, pizzatoppingExtra) VALUES (?, ?, ?)";

		PreparedStatement pstmt = conn.prepareStatement(sql);

		pstmt.setInt(1, pizzaID);
		pstmt.setInt(2, t.getTopID());
		pstmt.setInt(3, isExtra ? 1: 0);

		pstmt.executeUpdate();

		pstmt.close();
		conn.close();

//		System.out.println("Topping added to pizza successfully.");
	}


	public static void usePizzaDiscount(Pizza p, Discount d) throws SQLException, IOException {
		connect_to_db();

		// Insert a new record into the pizzadiscount bridge table
		String sql = "INSERT INTO pizzadiscount (pizzadiscountPizzaID, pizzadiscountDiscountID) VALUES (?, ?)";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, p.getPizzaID());
		pstmt.setInt(2, d.getDiscountID());

		// Execute the update
		pstmt.executeUpdate();

		// Always close the connection
		conn.close();
	}




	public static void useOrderDiscount(Order o, Discount d) throws SQLException, IOException
	{
		connect_to_db();
		/*
		 * This method connects a discount with an order in the database
		 * 
		 * You might use this, you might not depending on where / how to want to update
		 * this information in the dabast
		 */
		
		
		
		
		
		//DO NOT FORGET TO CLOSE YOUR CONNECTION
	}

	public static void addCustomer(Customer c) throws SQLException, IOException {
		connect_to_db();
		try {
			String sql = "INSERT INTO customer (customerFName, customerLName, customerPhone) VALUES (?, ?, ?)";
			PreparedStatement pstmt = conn.prepareStatement(sql);

			// Set the parameters
			pstmt.setString(1, c.getFName());
			pstmt.setString(2, c.getLName());
			pstmt.setString(3, c.getPhone());

			// Execute the update
			pstmt.executeUpdate();

			// Close the PreparedStatement
			pstmt.close();
			System.out.println("Customer added successfully.");
		} catch (SQLException e) {
			System.out.println("Error adding customer");
			while (e != null) {
				System.out.println("Message     : " + e.getMessage());
				e = e.getNextException();
			}
		} finally {
			//DO NOT FORGET TO CLOSE YOUR CONNECTION
			conn.close();
		}
	}


	public static void completeOrder(Order o) throws SQLException, IOException {
		connect_to_db();
		String sql = "UPDATE orders SET ordersIsComplete = 1 WHERE ordersID = ?";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, o.getOrderID());
		pstmt.executeUpdate();
		conn.close();
	}



	public static ArrayList<Order> getOrders(boolean openOnly) throws SQLException, IOException {
		connect_to_db();
		/*
		 * Return an arraylist of all of the orders.
		 * 	openOnly == true => only return a list of open (ie orders that have not been marked as completed)
		 *           == false => return a list of all the orders in the database
		 * Remember that in Java, we account for supertypes and subtypes
		 * which means that when we create an arrayList of orders, that really
		 * means we have an arrayList of dineinOrders, deliveryOrders, and pickupOrders.
		 * 
		 * Don't forget to order the data coming from the database appropriately.
		 * 
		 */



		
		//DO NOT FORGET TO CLOSE YOUR CONNECTION
		return null;
	}
	
	public static Order getLastOrder(){
		/*
		 * Query the database for the LAST order added
		 * then return an Order object for that order.
		 * NOTE...there should ALWAYS be a "last order"!
		 */
		




		 return null;
	}

	public static ArrayList<Order> getOrdersByDate(String date){
		/*
		 * Query the database for ALL the orders placed on a specific date
		 * and return a list of those orders.
		 *  
		 */
		




		 return null;
	}

	public static ArrayList<Discount> getDiscountList() throws SQLException, IOException {
		connect_to_db();
		ArrayList<Discount> discountList = new ArrayList<>();
		String sql = "SELECT * FROM discount";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();

		// Print the header of the table
		System.out.printf("%-10s %-20s %-10s %-10s\n", "Discount ID", "Discount Name", "Amount", "Is Percent?");

		while (rs.next()) {
			double amount = rs.getDouble("discountDollarAmountOff");
			boolean isPercent = false;
			if (rs.getDouble("discountPercentageOff") != 0.0) {
				amount = rs.getDouble("discountPercentageOff");
				isPercent = true;
			}
			Discount discount = new Discount(rs.getInt("discountID"), rs.getString("discountName"), amount, isPercent);
			discountList.add(discount);

			// Print the details of the discount in a table format
			System.out.printf("%-10d %-20s %-10.2f %-10s\n", discount.getDiscountID(), discount.getDiscountName(),
					discount.getAmount(), (discount.isPercent() ? "Yes" : "No"));
		}
		conn.close();
		return discountList;
	}


	public static Discount getDiscountByID(int discountID) throws SQLException, IOException {
		connect_to_db();  // Establish a new connection
		String sql = "SELECT * FROM discount WHERE discountID = ?";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, discountID);
		ResultSet rs = pstmt.executeQuery();
		rs.next();

		double amount = rs.getDouble("discountDollarAmountOff");
		boolean isPercent = false;
		if (rs.getDouble("discountPercentageOff") != 0.0) {
			amount = rs.getDouble("discountPercentageOff");
			isPercent = true;
		}
		Discount discount = new Discount(rs.getInt("discountID"), rs.getString("discountName"), amount, isPercent);

		conn.close();  // Close the connection
		return discount;
	}




	public static Discount findDiscountByName(String name) throws SQLException, IOException {
		connect_to_db();
		String sql = "SELECT * FROM discount WHERE discountName = ?";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, name);
		ResultSet rs = pstmt.executeQuery();
		Discount discount = null;
		if (rs.next()) {
			double amount = rs.getDouble("discountDollarAmountOff");
			boolean isPercent = false;
			if (rs.getDouble("discountPercentageOff") != 0.0) {
				amount = rs.getDouble("discountPercentageOff");
				isPercent = true;
			}
			discount = new Discount(rs.getInt("discountID"), rs.getString("discountName"), amount, isPercent);
		}
		conn.close();
		return discount;
	}



	public static ArrayList<Customer> getCustomerList() throws SQLException, IOException {
		/*
		 * Query the data for all the customers and return an arrayList of all the customers. 
		 * Don't forget to order the data coming from the database appropriately.
		 * 
		*/

		boolean isConnected = connect_to_db();
		ArrayList<Customer> customerList = new ArrayList<>();

		if(isConnected) {
			System.out.println("Connection Success.");
			Statement statement = conn.createStatement();
			ResultSet resultSet = statement.executeQuery("SELECT * FROM customer ORDER BY customerID;");

			while (resultSet.next()) {
				int custID = resultSet.getInt("customerID");
				String fName = resultSet.getString("customerFName");
				String lName = resultSet.getString("customerLName");
				String phone = resultSet.getString("customerPhone");

				Customer customer = new Customer(custID, fName, lName, phone);
				customerList.add(customer);
			}

			resultSet.close();
			statement.close();
			conn.close();
		}
		else{
			System.out.println("Connection error.");
		}

		return customerList;
	}

	public static Customer findCustomerByPhone(String phoneNumber) throws SQLException, IOException {
		connect_to_db();
		String sql = "SELECT * FROM customer WHERE customerPhone = ?";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, phoneNumber);
		ResultSet rs = pstmt.executeQuery();
		Customer customer = null;
		if (rs.next()) {
			customer = new Customer(rs.getInt("customerID"), rs.getString("customerFName"), rs.getString("customerLName"), rs.getString("customerPhone"));
		}
		conn.close();
		return customer;
	}


	public static int getMaxPizzaID() throws SQLException, IOException {
		connect_to_db();

		String maxID = "select max(pizzaID) from pizza;";
		PreparedStatement prepStatement = conn.prepareStatement(maxID);
		ResultSet returnValue = prepStatement.executeQuery();

		int newID = -1;
		while (returnValue.next()) {
			newID = returnValue.getInt(1);
		}

		conn.close();

		return newID;
	}



	public static int getMaxCustID() throws SQLException, IOException {
		connect_to_db();

		String maxID = "select max(customerID) from customer;";
		PreparedStatement prepStatement = conn.prepareStatement(maxID);
		ResultSet returnValue = prepStatement.executeQuery();

		int newID = -1;
		while (returnValue.next()) {
			newID = returnValue.getInt(1);
		}

		conn.close();

		return newID;
	}


	public static int getMaxOrderID() throws SQLException, IOException {
		connect_to_db();

		String maxID = "select max(ordersID) from orders;";
		PreparedStatement prepStatement = conn.prepareStatement(maxID);
		ResultSet returnValue = prepStatement.executeQuery();

		int newID = -1;
		while (returnValue.next()) {
			newID = returnValue.getInt(1);
		}

		conn.close();
		return newID;
	}


	public static Topping findToppingByName(String name){
		/*
		 * Query the database for the topping using it's name.
		 * If found, then return a Topping object for the topping.
		 * If it's not found....then return null
		 *  
		 */
		




		 return null;
	}


	public static int addDineInOrder(DineinOrder order) throws SQLException, IOException {
		connect_to_db();

		String dineInSql = "INSERT INTO dinein (dineinID, dineinTableNumber) VALUES (?, ?)";
		PreparedStatement pstmtDineIn = conn.prepareStatement(dineInSql);
		pstmtDineIn.setInt(1, order.getOrderID());
		pstmtDineIn.setInt(2, order.getTableNum());

		pstmtDineIn.executeUpdate();
		conn.close();
		return order.getOrderID();
	}

	public static int addPickupOrder(Customer customer, PickupOrder order) throws SQLException, IOException {
		connect_to_db();

		String pickupSql = "INSERT INTO pickup (pickupID, pickupName, pickupPhone) VALUES (?, ?, ?)";
		PreparedStatement pstmtPickup = conn.prepareStatement(pickupSql);
		String name = customer.getFName() + " " + customer.getLName();
		pstmtPickup.setInt(1, order.getOrderID());
		pstmtPickup.setString(2, name);
		pstmtPickup.setString(3, customer.getPhone());

		pstmtPickup.executeUpdate();

		conn.close();
		return order.getOrderID();
	}


	public static int addDeliveryOrder(Customer customer, DeliveryOrder order) throws SQLException, IOException {
		connect_to_db();

		String deliverySql = "INSERT INTO delivery (deliveryID, deliveryName, deliveryPhone, deliveryAddress, deliveryCity, deliveryState, deliveryZip) VALUES (?, ?, ?, ?, ?, ?, ?)";
		PreparedStatement pstmtDelivery = conn.prepareStatement(deliverySql);
		String name = customer.getFName() + " " + customer.getLName();
		pstmtDelivery.setInt(1, order.getOrderID());
		pstmtDelivery.setString(2, name);
		pstmtDelivery.setString(3, customer.getPhone());
		pstmtDelivery.setString(4, order.getAddress());
		pstmtDelivery.setString(5, order.getCity());
		pstmtDelivery.setString(6, order.getState());
		pstmtDelivery.setString(7, order.getZip());

		pstmtDelivery.executeUpdate();

		conn.close();
		return order.getOrderID();
	}



	public static void addToInventory(Topping t, double quantity) throws SQLException, IOException {
		connect_to_db();
		/*
		 * Updates the quantity of the topping in the database by the amount specified.
		 * 
		 * */

		String sql = "UPDATE topping SET toppingInventory = toppingInventory + ? WHERE toppingID = ?";
		PreparedStatement pstmt = conn.prepareStatement(sql);

		// Set the parameters
		pstmt.setDouble(1, quantity);
		pstmt.setInt(2, t.getTopID());

		// Execute the update
		pstmt.executeUpdate();

		// Close the PreparedStatement
		pstmt.close();

		System.out.println("Inventory updated successfully.");
	}



	public static Topping getToppingByID(int id) throws SQLException, IOException {
		connect_to_db();
		String sql = "SELECT * FROM topping WHERE toppingID = ?";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, id);
		ResultSet rs = pstmt.executeQuery();

		if (rs.next()) {
			Topping topping = new Topping(
				rs.getInt("toppingID"),
				rs.getString("toppingName"),
				rs.getDouble("toppingPrice"),
				rs.getDouble("toppingCost"),
				rs.getDouble("toppingSmall"),
				rs.getDouble("toppingMedium"),
				rs.getDouble("toppingLarge"),
				rs.getDouble("toppingXlarge"),
					rs.getInt("toppingInventory")
			);

			return topping;
		}

		return null;
	}





	public static double getBaseCustPrice(String size, String crust) throws SQLException, IOException {
		connect_to_db();
		/*
		 * Query the database for the base customer price for that size and crust pizza.
		 */

		// Assume that your table has 'size' and 'crust' columns
		String basePriceSql = "SELECT basepricePrice FROM basepricepizza WHERE basepriceSize = ? AND basepriceCrust = ?";
		PreparedStatement basePricePstmt = conn.prepareStatement(basePriceSql);
		basePricePstmt.setString(1, size);
		basePricePstmt.setString(2, crust);

		ResultSet basePriceRs = basePricePstmt.executeQuery();

		// if the ResultSet is not empty, retrieve the base customer price
		double baseCustPrice = 0.0;
		if (basePriceRs.next()) {
			baseCustPrice = basePriceRs.getDouble("basepricePrice");
		} else {
			System.out.println("No base customer price found for the given size and crust");
		}

		// Always close the connection
		conn.close();

		return baseCustPrice;
	}



	public static int getBasePriceID(String pizzaCrust, String pizzaSize) throws SQLException, IOException {
		connect_to_db();

		// Prepare the SQL query
		String query = "SELECT basepriceID FROM basepricepizza WHERE basepriceCrust = ? AND basepriceSize = ?;";
		PreparedStatement prepStatement = conn.prepareStatement(query);

		// Set the values in the prepared statement
		prepStatement.setString(1, pizzaCrust);
		prepStatement.setString(2, pizzaSize);

		// Execute the query
		ResultSet returnValue = prepStatement.executeQuery();

		int basePriceID = -1;
		while (returnValue.next()) {
			basePriceID = returnValue.getInt(1);
		}

		// Close the connection
		conn.close();

		return basePriceID;
	}




	public static double getBaseBusPrice(String size, String crust) throws SQLException, IOException {
		connect_to_db();
		/*
		 * Query the database for the base business price for that size and crust pizza.
		 *
		 */

		// Assume that your table has 'size' and 'crust' columns
		String basePriceSql = "SELECT basepriceCost FROM basepricepizza WHERE basepriceSize = ? AND basepriceCrust = ?";
		PreparedStatement basePricePstmt = conn.prepareStatement(basePriceSql);
		basePricePstmt.setString(1, size);
		basePricePstmt.setString(2, crust);

		ResultSet basePriceRs = basePricePstmt.executeQuery();

		// if the ResultSet is not empty, retrieve the base price
		double basePrice = 0.0;
		if (basePriceRs.next()) {
			basePrice = basePriceRs.getDouble("basepriceCost");
		} else {
			System.out.println("No base price found for the given size and crust");
		}

		// Always close the connection
		conn.close();

		return basePrice;
	}


	public static void printInventory() throws SQLException, IOException {
		connect_to_db();
		/*
		 * Queries the database and prints the current topping list with quantities.
		 *  
		 * The result should be readable and sorted as indicated in the prompt.
		 * 
		 */
		ArrayList<Topping> toppingList = new ArrayList<>();
		Statement stmt = null;
		ResultSet rs = null;

		try {
			// Assuming you already have a connection established
			stmt = conn.createStatement();
			String sql = "SELECT * FROM topping ORDER BY toppingName";
			rs = stmt.executeQuery(sql);

			// Extract data from result set
			while(rs.next()){
				int toppingID = rs.getInt("toppingID");
				String toppingName = rs.getString("toppingName");
				double toppingPrice = rs.getDouble("toppingPrice");
				double toppingCost = rs.getDouble("toppingCost");
				int toppingInventory = rs.getInt("toppingInventory");
				double toppingSmall = rs.getDouble("toppingSmall");
				double toppingMedium = rs.getDouble("toppingMedium");
				double toppingLarge = rs.getDouble("toppingLarge");
				double toppingXlarge = rs.getDouble("toppingXlarge");

				// Create a new Topping object and add it to the list
				Topping topping = new Topping(toppingID, toppingName, toppingPrice, toppingCost, toppingSmall, toppingMedium, toppingLarge, toppingXlarge, toppingInventory);
				toppingList.add(topping);
			}

		} catch(SQLException se){
			// Handle errors for JDBC
			se.printStackTrace();
		} finally {
			// Finally block used to close resources
			try {
				if(rs != null)
					rs.close();
			} catch(SQLException se2) {
			} // Nothing we can do
			try {
				if(stmt != null)
					stmt.close();
			} catch(SQLException se) {
				se.printStackTrace();
			}
		}
		conn.close();

		// Print headers
		System.out.printf("%-5s %-20s %-10s\n", "ID", "Name", "Inventory");

		// Print line separator
		for(int i = 0; i < 47; i++){
			System.out.print("-");
		}
		System.out.println();

		// Iterate over the ArrayList and print the desired fields
		for (Topping topping : toppingList) {
			System.out.printf("%-5d %-20s %-10d \n",
					topping.getTopID(),
					topping.getTopName(),
					topping.getCurINVT()
			);
		}
	}

	public static void printToppingPopReport() throws SQLException, IOException {
		connect_to_db();

		// Execute the SQL query to get the report data
		String sql = "SELECT * FROM ToppingPopularity";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();

		// Print the report data
		System.out.printf("%-5s %-20s \n", "Topping", "Topping Count");
		while (rs.next()) {
			String toppingName = rs.getString("toppingName");
			double popularity = rs.getDouble("popularity");
			System.out.println(toppingName + ": " + popularity);
		}

		// Always close the connection
		conn.close();
	}


	public static void printProfitByPizzaReport() throws SQLException, IOException {
		connect_to_db();

		// Execute the SQL query to get the report data
		String sql = "SELECT * FROM ProfitByPizza";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();

		// Print the report data
		System.out.printf("%-20s %-20s %-10s %-20s\n", "Pizza Size", "Pizza Crust", "Profit", "Last Order Date");
		while (rs.next()) {
			String pizzaSize = rs.getString("Pizza Size");
			String pizzaCrust = rs.getString("Pizza Crust");
			double profit = rs.getDouble("Profit");
			String lastOrderDate = rs.getString("LastOrderDate");
			System.out.printf("%-20s %-20s %-10.2f %-20s\n", pizzaSize, pizzaCrust, profit, lastOrderDate);
		}

		// Always close the connection
		conn.close();
	}



	public static void printProfitByOrderType() throws SQLException, IOException {
		connect_to_db();

		// Execute the SQL query to get the report data
		String sql = "SELECT * FROM ProfitByOrderType";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();

		// Print the report data
		System.out.printf("%-20s %-15s %-20s %-20s %-10s\n", "Customer Type", "Order Month", "Total Order Price", "Total Order Cost", "Profit");
		while (rs.next()) {
			String customerType = rs.getString("customerType");
			String orderMonth = rs.getString("OrderMonth");
			double totalOrderPrice = rs.getDouble("TotalOrderPrice");
			double totalOrderCost = rs.getDouble("TotalOrderCost");
			double profit = rs.getDouble("Profit");
			System.out.printf("%-20s %-15s %-20.2f %-20.2f %-10.2f\n", customerType, orderMonth, totalOrderPrice, totalOrderCost, profit);
		}

		// Always close the connection
		conn.close();
	}





	public static String getCustomerName(int CustID) throws SQLException, IOException
	{
	/*
		 * This is a helper method to fetch and format the name of a customer
		 * based on a customer ID. This is an example of how to interact with 
		 * your database from Java.  It's used in the model solution for this project...so the code works!
		 * 
		 * OF COURSE....this code would only work in your application if the table & field names match!
		 *
		 */

		 connect_to_db();

		/* 
		 * an example query using a constructed string...
		 * remember, this style of query construction could be subject to sql injection attacks!
		 * 
		 */
		String cname1 = "";
		String query = "Select FName, LName From customer WHERE CustID=" + CustID + ";";
		Statement stmt = conn.createStatement();
		ResultSet rset = stmt.executeQuery(query);
		
		while(rset.next())
		{
			cname1 = rset.getString(1) + " " + rset.getString(2); 
		}

		/* 
		* an example of the same query using a prepared statement...
		* 
		*/
		String cname2 = "";
		PreparedStatement os;
		ResultSet rset2;
		String query2;
		query2 = "Select FName, LName From customer WHERE CustID=?;";
		os = conn.prepareStatement(query2);
		os.setInt(1, CustID);
		rset2 = os.executeQuery();
		while(rset2.next())
		{
			cname2 = rset2.getString("FName") + " " + rset2.getString("LName"); // note the use of field names in the getSting methods
		}

		conn.close();
		return cname1; // OR cname2
	}

	/*
	 * The next 3 private methods help get the individual components of a SQL datetime object. 
	 * You're welcome to keep them or remove them.
	 */
	private static int getYear(String date)// assumes date format 'YYYY-MM-DD HH:mm:ss'
	{
		return Integer.parseInt(date.substring(0,4));
	}
	private static int getMonth(String date)// assumes date format 'YYYY-MM-DD HH:mm:ss'
	{
		return Integer.parseInt(date.substring(5, 7));
	}
	private static int getDay(String date)// assumes date format 'YYYY-MM-DD HH:mm:ss'
	{
		return Integer.parseInt(date.substring(8, 10));
	}

	public static boolean checkDate(int year, int month, int day, String dateOfOrder)
	{
		if(getYear(dateOfOrder) > year)
			return true;
		else if(getYear(dateOfOrder) < year)
			return false;
		else
		{
			if(getMonth(dateOfOrder) > month)
				return true;
			else if(getMonth(dateOfOrder) < month)
				return false;
			else
			{
				if(getDay(dateOfOrder) >= day)
					return true;
				else
					return false;
			}
		}
	}


}