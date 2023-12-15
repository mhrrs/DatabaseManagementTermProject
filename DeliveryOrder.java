package cpsc4620;

public class DeliveryOrder extends Order
{
	private String Address;
	private String City;
	private String State;
	private String Zip;
	
	public DeliveryOrder(int orderID, int custID, String date, double custPrice, double busPrice, int isComplete, String address, String city, String state, String zip)
	{
		super(orderID, custID, DBNinja.delivery, date, custPrice, busPrice, isComplete);
		this.Address = address;
		this.City = city;
		this.State = state;
		this.Zip = zip;
	}

	public String getAddress() {
		return Address;
	}

	public void setAddress(String address) {
		Address = address;
	}

	public String getCity() {
		return City;
	}

	public void setCity(String city) {
		City = city;
	}

	public String getState() {
		return State;
	}

	public void setState(String state) {
		State = state;
	}

	public String getZip() {
		return Zip;
	}

	public void setZip(String zip) {
		Zip = zip;
	}

	@Override
	public String toString() {
		return super.toString() + " | Delivered to: " + Address;
	}
	
	
}
