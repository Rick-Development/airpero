import 'package:get/get.dart';

class SellGiftCardController extends GetxController {
  var quantity = 0.obs;
  var currency = ''.obs; // Reactive currency
  var selectedPrice = ''.obs; // Observable to store the selected price
  var senderFee = 0.0; // Changed to double to match calculations with price

  // List of prices based on the selected currency and sender fee
  List<String> get priceList {
    return [
      "${currency.value} 10.00 - NGN ${(senderFee * 10).toStringAsFixed(2)}",
      "${currency.value} 20.00 - NGN ${(senderFee * 20).toStringAsFixed(2)}",
      "${currency.value} 50.00 - NGN ${(senderFee * 50).toStringAsFixed(2)}",
      "${currency.value} 100.00 - NGN ${(senderFee * 100).toStringAsFixed(2)}",
      "${currency.value} 200.00 - NGN ${(senderFee * 200).toStringAsFixed(2)}",
      "${currency.value} 500.00 - NGN ${(senderFee * 500).toStringAsFixed(2)}",
    ];
  }

  @override
  void onInit() {
    super.onInit();
    // Set initial values for currency and sender fee if needed
    currency.value = 'USD';
    senderFee = 500.00; // Example fee, modify as needed
  }

  // Method to set currency and sender fee
  void setCurrency(String cur, double fee) {
    currency.value = cur;
    senderFee = fee; // Update senderFee when setting currency
  }

  // Method to increment the quantity
  void addQuantity() {
    quantity++;
  }

  // Method to decrement the quantity
  void reduceQuantity() {
    if (quantity > 0) {
      quantity--;
    }
  }
}
