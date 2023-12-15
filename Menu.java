package cpsc4620;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Scanner;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.function.Function;


/*
 * This file is where the front end magic happens.
 * 
 * You will have to write the methods for each of the menu options.
 * 
 * This file should not need to access your DB at all, it should make calls to the DBNinja that will do all the connections.
 * 
 * You can add and remove methods as you see necessary. But you MUST have all of the menu methods (including exit!)
 * 
 * Simply removing menu methods because you don't know how to implement it will result in a major error penalty (akin to your program crashing)
 * 
 * Speaking of crashing. Your program shouldn't do it. Use exceptions, or if statements, or whatever it is you need to do to keep your program from breaking.
 * 
 */

public class Menu {

	public static BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));

	public static void main(String[] args) throws SQLException, IOException {

		System.out.println("Welcome to Pizzas-R-Us!");
		
		int menu_option = 0;

		// present a menu of options and take their selection
		
		PrintMenu();
		BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
//		Autograder.checkSeed("eec2d78a0957459cb5e841a8760b4e99");
		String option = reader.readLine();
		menu_option = Integer.parseInt(option);

		while (menu_option != 9) {
			switch (menu_option) {
			case 1:// enter order
				EnterOrder();
				break;
			case 2:// view customers
				viewCustomers();
				break;
			case 3:// enter customer
				EnterCustomer();
				break;
			case 4:// view order
				// open/closed/date
				ViewOrders();
				break;
			case 5:// mark order as complete
				MarkOrderAsComplete();
				break;
			case 6:// view inventory levels
				ViewInventoryLevels();
				break;
			case 7:// add to inventory
				AddInventory();
				break;
			case 8:// view reports
				PrintReports();
				break;
			}
			PrintMenu();
			option = reader.readLine();
			menu_option = Integer.parseInt(option);
		}

	}

	// allow for a new order to be placed
	public static void EnterOrder() throws SQLException, IOException 
	{

		/*
		 * EnterOrder should do the following:
		 * 
		 * Ask if the order is delivery, pickup, or dinein
		 *   if dine in....ask for table number
		 *   if pickup...
		 *   if delivery...
		 * 
		 * Then, build the pizza(s) for the order (there's a method for this)
		 *  until there are no more pizzas for the order
		 *  add the pizzas to the order
		 *
		 * Apply order discounts as needed (including to the DB)
		 * 
		 * return to menu
		 * 
		 * make sure you use the prompts below in the correct order!
		 */

		// User Input Prompts...
		System.out.println("Is this order for: \n1.) Dine-in\n2.) Pick-up\n3.) Delivery\nEnter the number of your choice:");
		String orderType = reader.readLine();
		int orderID = DBNinja.getMaxOrderID();


		// Handle order type
		if (orderType.equals("1")) {

			System.out.println("What is the table number for this order?");
			String tableStr = reader.readLine();
			int tableNum = Integer.parseInt(tableStr);

			List<Pizza> pizzas = buildPizza(orderID);

			double totalPrice = 0.0;
			double totalCost = 0.0;
			for (Pizza pizza : pizzas) {
				totalPrice += pizza.getCustPrice();
				totalCost += pizza.getBusPrice();
			}


			// Create the order with the total prices
			Order newOrder = new Order(-1, 1, "dinein", "OrderDate", totalPrice, totalCost, 0);

			// Add the order to the database
			orderID = DBNinja.addOrder(newOrder);
			Customer customer = new Customer(DBNinja.getMaxOrderID()+1, "DINEIN", "","");

			DineinOrder dineInOrder = new DineinOrder(orderID, customer.getCustID(), "OrderDate", totalPrice, totalCost, 0, tableNum);
			orderID = DBNinja.addDineInOrder(dineInOrder);

			for (Pizza pizza : pizzas){
				int pizzaID = DBNinja.getMaxPizzaID();
				DBNinja.addPizzaToOrder(pizzaID, orderID);
			}


		} else if (orderType.equals("2")) {
			Customer customer = GetCustomerInfo();

			List<Pizza> pizzas = buildPizza(orderID);

			double totalPrice = 0.0;
			double totalCost = 0.0;
			for (Pizza pizza : pizzas) {
				totalPrice += pizza.getCustPrice();
				totalCost += pizza.getBusPrice();
			}


			// Create the order with the total prices
			Order newOrder = new Order(-1, customer.getCustID(), "pickup", "OrderDate", totalPrice, totalCost, 0);

			// Add the order to the database
			orderID = DBNinja.addOrder(newOrder);

			EnterCustomerOrderType(orderType, customer, totalPrice, totalCost, orderID);

			for (Pizza pizza : pizzas){
				int pizzaID = DBNinja.getMaxPizzaID();
				DBNinja.addPizzaToOrder(pizzaID, orderID);
			}

		} else if (orderType.equals("3")) {
			Customer customer = GetCustomerInfo();

			List<Pizza> pizzas = buildPizza(orderID);

			double totalPrice = 0.0;
			double totalCost = 0.0;
			for (Pizza pizza : pizzas) {
				totalPrice += pizza.getCustPrice();
				totalCost += pizza.getBusPrice();
			}


			// Create the order with the total prices
			Order newOrder = new Order(-1, customer.getCustID(), "delivery", "OrderDate", totalPrice, totalCost, 0);

			// Add the order to the database
			orderID = DBNinja.addOrder(newOrder);

			EnterCustomerOrderType(orderType, customer, totalPrice, totalCost, orderID);

			for (Pizza pizza : pizzas){
				int pizzaID = DBNinja.getMaxPizzaID();
				DBNinja.addPizzaToOrder(pizzaID, orderID);
			}
		}
		System.out.println("Finished adding order...Returning to menu...");
	}
	
	
	public static void viewCustomers() throws SQLException, IOException 
	{
		/*
		 * Simply print out all of the customers from the database. 
		 */
		ArrayList<Customer> customerList = DBNinja.getCustomerList();

		// print the table headers
		System.out.printf("%-10s %-15s %-15s %-15s\n", "ID", "First Name", "Last Name", "Phone");

		for (Customer customer : customerList) {
			// print the table row
			System.out.printf("%-10d %-15s %-15s %-15s\n", customer.getCustID(), customer.getFName(), customer.getLName(), customer.getPhone());
		}
	}
	

	// Enter a new customer in the database
	public static Customer EnterCustomer() throws SQLException, IOException {
		/*
		 * Ask for the name of the customer:
		 *   First Name <space> Last Name
		 * 
		 * Ask for the  phone number.
		 *   (##########) (No dash/space)
		 * 
		 * Once you get the name and phone number, add it to the DB
		 */
		
		// User Input Prompts...
		System.out.println("What is this customer's name (first <space> last)?");
		String fullName = reader.readLine();
		String[] names = fullName.split(" ");

		String fname = names[0];
		String lname = names.length > 1 ? names[1] : ""; // Use an empty string if no last name was provided

		System.out.println("What is this customer's phone number (##########) (No dash/space)?");
		String phone = reader.readLine();

		int cID = DBNinja.getMaxCustID() + 1;
		Customer c = new Customer(cID, fname, lname, phone);

		DBNinja.addCustomer(c);
		return c;
	}

	public static void EnterCustomerOrderType(String orderType, Customer customer, double totalPrice, double totalCost, int orderID) throws SQLException, IOException {
		// Handle order type
		switch (orderType) {
			case "1":   // Dine-in
				break;

			case "2":   // Pick-up
				if (customer != null) {
					PickupOrder pickupOrder = new PickupOrder(orderID, customer.getCustID(), "OrderDate", totalPrice, totalCost, 0, 0);
					orderID = DBNinja.addPickupOrder(customer, pickupOrder);
				}
				break;

			case "3":   // Delivery
				System.out.println("Please enter your delivery street address:");
				String address = reader.readLine();
				System.out.println("Please enter your delivery city:");
				String city = reader.readLine();
				System.out.println("Please enter your delivery state:");
				String state = reader.readLine();
				System.out.println("Please enter your delivery zip code:");
				String zip = reader.readLine();
				if (customer != null) {
					DeliveryOrder deliveryOrder = new DeliveryOrder(orderID, customer.getCustID(), "OrderDate", totalPrice, totalCost, 0, address, city, state, zip);
					orderID = DBNinja.addDeliveryOrder(customer, deliveryOrder);
				}
				break;
		}
	}



	public static String getCrustType(String crustInt) {
		switch (crustInt) {
			case "1":
				return "Thin";
			case "2":
				return "Original";
			case "3":
				return "Pan";
			case "4":
				return "Gluten-Free";
			default:
				return null;
		}
	}

	public static String getSize(String sizeInt) {
		switch (sizeInt) {
			case "1":
				return "Small";
			case "2":
				return "Medium";
			case "3":
				return "Large";
			case "4":
				return "XLarge";
			default:
				return null;
		}
	}



	// View any orders that are not marked as completed
	public static void ViewOrders() throws SQLException, IOException {
		// Ask the user what type of orders they want to view
		System.out.println("Would you like to:\n(a) display all open orders\n(b) display all completed orders\n(c) display orders since a specific date");
		String choice = reader.readLine();

		ArrayList<Order> orderList = new ArrayList<>();

		switch (choice) {
			case "a":
				// Get all open orders
				orderList = DBNinja.getOpenOrders();
				break;
			case "b":
				// Get all completed orders
				orderList = DBNinja.getCompletedOrders();
				break;
			case "c":
				// Ask the user for a specific date
				System.out.println("What is the date you want to restrict by? (FORMAT= YYYY-MM-DD)");
				String date = reader.readLine();
				// Get all orders since the specific date
				orderList = DBNinja.getOrdersSinceDate(date);
				break;
			default:
				System.out.println("I don't understand that input, returning to menu");
				return;
		}

		if (orderList.isEmpty()) {
			System.out.println("No orders to display, returning to menu.");
			return;
		}

		// print the table headers
		System.out.printf("%-10s %-15s %-15s %-15s %-15s %-15s\n", "Order ID", "Customer ID", "Order Type", "Order Date", "Total Price", "Total Cost");

		for (Order order : orderList) {
			// print the table row
			System.out.printf("%-10d %-15d %-15s %-15s %-15.2f %-15.2f\n",
					order.getOrderID(),
					order.getCustID(),
					order.getOrderType(),
					order.getDate(),
					order.getCustPrice(),
					order.getBusPrice());
		}

		// Ask the user if they want to see a specific order in detail
		System.out.println("Which order would you like to see in detail? Enter the number (-1 to exit): ");
		int orderDetail = Integer.parseInt(reader.readLine());
		if (orderDetail == -1) {
			return;
		} else {
			// Here you can display the details for the order with the id orderDetail
			// If there is no order with such id, print an error message
			Order order = DBNinja.getOrderById(orderDetail);
			if (order != null) {
				// print details of the order
				System.out.printf("%-10d %-15d %-15s %-15s %-15.2f %-15.2f\n",
						order.getOrderID(),
						order.getCustID(),
						order.getOrderType(),
						order.getDate(),
						order.getCustPrice(),
						order.getBusPrice());

				List<Pizza> pizzas = DBNinja.getPizzasInOrder(order.getOrderID());

				System.out.printf("\n%-10s %-10s %-10s %-10s %-15s %-10s %-10s\n", "Pizza ID", "Size", "Crust", "Order ID", "State", "Price", "Cost");

				for (Pizza pizza : pizzas) {
					System.out.printf("%-10d %-10s %-10s %-10d %-15s %-10.2f %-10.2f\n",
							pizza.getPizzaID(),
							pizza.getSize(),
							pizza.getCrustType(),
							pizza.getOrderID(),
							pizza.getPizzaState(),
							pizza.getCustPrice(),
							pizza.getBusPrice());
				}
			} else {
				System.out.println("Incorrect entry, returning to menu.");
			}
		}
	}



	// When an order is completed, we need to make sure it is marked as complete
	public static void MarkOrderAsComplete() throws SQLException, IOException 
	{
		/*
		 * All orders that are created through java (part 3, not the orders from part 2) should start as incomplete
		 * 
		 * When this method is called, you should print all of the "opoen" orders marked
		 * and allow the user to choose which of the incomplete orders they wish to mark as complete
		 * 
		 */

		ArrayList<Order> orderList = DBNinja.getOpenOrders();

		if (orderList.isEmpty()) {
			System.out.println("There are no open orders currently... returning to menu...");
			return;
		}

		// print the table headers
		System.out.printf("%-10s %-15s %-15s %-15s %-15s %-15s\n", "Order ID", "Customer ID", "Order Type", "Order Date", "Total Price", "Total Cost");

		for (Order order : orderList) {
			// print the table row
			System.out.printf("%-10d %-15d %-15s %-15s %-15.2f %-15.2f\n",
					order.getOrderID(),
					order.getCustID(),
					order.getOrderType(),
					order.getDate(),
					order.getCustPrice(),
					order.getBusPrice());
		}
		
		
		// User Input Prompts...
		System.out.println("Which order would you like to mark as complete? Enter the OrderID (enter -1 to quit): ");
		int orderDetail = Integer.parseInt(reader.readLine());
		if (orderDetail == -1) {
			return;
		} else {

			boolean orderExists = false;

			for (Order order : orderList) {
				if (order.getOrderID() == orderDetail) {
					DBNinja.completeOrder(order);
					System.out.println("Order " + orderDetail + " marked as complete.");
					orderExists = true;
					break;
				}
			}

			if (!orderExists) {
				System.out.println("No order with ID " + orderDetail + " found. Please try again.");
			}
		}
	}

	public static void ViewInventoryLevels() throws SQLException, IOException 
	{
		/*
		 * Print the inventory. Display the topping ID, name, and current inventory
		*/
		DBNinja.printInventory();
	}


	public static void AddInventory() throws SQLException, IOException 
	{
		/*
		 * This should print the current inventory and then ask the user which topping (by ID) they want to add more to and how much to add
		 */
		
		
		// User Input Prompts...
		ViewInventoryLevels();
		System.out.println("Which topping do you want to add inventory to? Enter the number: ");

		// Create a Scanner to get user input
		Scanner scanner = new Scanner(System.in);

		System.out.println("Which topping do you want to add inventory to? Enter the ID: ");
		int toppingID = scanner.nextInt();

		System.out.println("How many units would you like to add? ");
		double quantityToAdd = scanner.nextInt();

		Topping topping = DBNinja.getToppingByID(toppingID);

		// Update the inventory in the database
		DBNinja.addToInventory(topping, quantityToAdd);
	}



	public static Customer GetCustomerInfo() throws SQLException, IOException {
		// Convert the customer list to a map for efficient lookups
		Map<Integer, Customer> customerMap = DBNinja.getCustomerList().stream()
				.collect(Collectors.toMap(Customer::getCustID, Function.identity()));

		Customer customer = null;
		while (customer == null) {
			System.out.println("Are You an Existing Customer or a New Customer?");
			System.out.println("1. Existing Customer");
			System.out.println("2. New Customer");
			System.out.println("Enter the Corresponding Number.");
			int newcustomer = Integer.parseInt(reader.readLine());

			switch (newcustomer) {
				// Existing Customer
				case 1:
					System.out.println("List of Customers:");
					viewCustomers();

					System.out.println("Enter Your Customer ID");
					int custID = Integer.parseInt(reader.readLine());

					customer = customerMap.get(custID);
					if (customer == null) {
						System.out.println("Invalid Selection. Try Again.");
					}
					break;

				// New Customer
				case 2:
					customer = EnterCustomer();
					break;

				default:
					System.out.println("Invalid Selection. Try Again.");
					break;
			}
		}

		return customer;
	}



	public static List<Pizza> buildPizza(int orderID) throws SQLException, IOException {
		List<Pizza> pizzas = new ArrayList<>();

		while (true) {
			System.out.println("Let's build a pizza!");
			System.out.println("What size is the pizza?");
			System.out.println("1.Small\n2.Medium\n3.Large\n4.XLarge\nEnter the corresponding number:");
			String pizzaSize = reader.readLine();

			System.out.println("What crust for this pizza?");
			System.out.println("1.Thin\n2.Original\n3.Pan\n4.Gluten-Free\nEnter the corresponding number:");
			String pizzaCrust = reader.readLine();

			String pizzaCr = getCrustType(pizzaCrust);
			String pizzaSz = getSize(pizzaSize);
			Pizza newPizza = new Pizza(-1, pizzaSz, pizzaCr, orderID, "In Progress", "PizzaDate", 0, 0);

			ArrayList<Integer> chosenToppings = new ArrayList<>();
			ArrayList<Boolean> isToppingExtra = new ArrayList<>();

			while (true) {
				ViewInventoryLevels();
				System.out.println("Which topping do you want to add? Enter -1 if you want to stop adding toppings.");
				String topping = reader.readLine();
				int toppingNum = Integer.parseInt(topping);

				if (toppingNum == -1) {
					break;
				}

				chosenToppings.add(toppingNum);

				System.out.println("Do you want to add extra? y/n:");
				String extraTopping = reader.readLine();
				isToppingExtra.add(extraTopping.equalsIgnoreCase("y"));
			}

			// Add toppings to the Pizza
			for (int i = 0; i < chosenToppings.size(); i++) {
				Topping topping = DBNinja.getToppingByID(chosenToppings.get(i));
				newPizza.addToppings(topping, isToppingExtra.get(i));
			}

			// Add the new Pizza to the database
			int basePriceID = DBNinja.getBasePriceID(pizzaCr, pizzaSz);
			newPizza.setBusPrice(DBNinja.getBaseBusPrice(pizzaSz,pizzaCr));
			newPizza.setCustPrice(DBNinja.getBaseCustPrice(pizzaSz, pizzaCr));

			// Convert ArrayList<Boolean> to boolean[]
			boolean[] isToppingDoubled = new boolean[isToppingExtra.size()];
			for (int i = 0; i < isToppingExtra.size(); i++) {
				isToppingDoubled[i] = isToppingExtra.get(i);
			}
			newPizza.setIsDoubleArray(isToppingDoubled);

			DBNinja.addPizza(newPizza);  // This should assign a PizzaID
			pizzas.add(newPizza);

			// Now that the pizza is in the database, we can add discounts
			while (true) {
				DBNinja.getDiscountList();
				System.out.println("Do you want to add any discounts to this pizza? Enter y/n");
				String addDiscount = reader.readLine();
				if (addDiscount.equalsIgnoreCase("n")) {
					break;
				} else {
					System.out.println("Enter the discount ID you want to apply:");
					String discountID = reader.readLine();
					Discount discount = DBNinja.getDiscountByID(Integer.parseInt(discountID));
					newPizza.addDiscounts(discount);
					DBNinja.usePizzaDiscount(newPizza, discount);

					// Update the pizza price in the Pizza object and the database
					DBNinja.updatePizzaPrice(newPizza);
				}
			}

			System.out.println("Enter -1 to stop adding pizzas...Enter anything else to continue adding more pizzas to the order.");
			String pizzaN = reader.readLine();
			int pizzaNum = Integer.parseInt(pizzaN);

			if (pizzaNum == -1) {
				break;
			}
		}
		return pizzas;
	}




	public static void PrintReports() throws SQLException, NumberFormatException, IOException {
		System.out.println("Which report do you wish to print? Enter\n(a) ToppingPopularity\n(b) ProfitByPizza\n(c) ProfitByOrderType:");
		BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
		String input = reader.readLine();

		switch (input) {
			case "a":
				DBNinja.printToppingPopReport();
				break;
			case "b":
				DBNinja.printProfitByPizzaReport();
				break;
			case "c":
				DBNinja.printProfitByOrderType();
				break;
			default:
				System.out.println("I don't understand that input... returning to menu...");
				break;
		}
	}


	//Prompt - NO CODE SHOULD TAKE PLACE BELOW THIS LINE
	// DO NOT EDIT ANYTHING BELOW HERE, THIS IS NEEDED TESTING.
	// IF YOU EDIT SOMETHING BELOW, IT BREAKS THE AUTOGRADER WHICH MEANS YOUR GRADE WILL BE A 0 (zero)!!

	public static void PrintMenu() {
		System.out.println("\n\nPlease enter a menu option:");
		System.out.println("1. Enter a new order");
		System.out.println("2. View Customers ");
		System.out.println("3. Enter a new Customer ");
		System.out.println("4. View orders");
		System.out.println("5. Mark an order as completed");
		System.out.println("6. View Inventory Levels");
		System.out.println("7. Add Inventory");
		System.out.println("8. View Reports");
		System.out.println("9. Exit\n\n");
		System.out.println("Enter your option: ");
	}


	/*
	 * autograder controls....do not modiify!
	 */

	public final static String autograder_seed = "eec2d78a0957459cb5e841a8760b4e99";

}
