void main() {
  String customerName = "sunni";
  String foodItem = "chicken Biryani";
  int quantity = 2;
  double price = 100000.0;

  double total = quantity * price;

  print("===== FOOD DELIVERY ORDER =====");
  print("Customer: $customerName");
  print("Food Item: $foodItem");
  print("Quantity: $quantity");
  print("Price per item: ₹$price");
  print("Total Amount: ₹$total");
}