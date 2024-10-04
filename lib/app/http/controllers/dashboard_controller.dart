import 'package:get/get.dart';

class DashboardController extends GetxController {
  // Observable variable for balance visibility
  var isBalanceVisible = true.obs;

  // Observable variable for account balance
  var accountBalance = 2580440.30.obs;

  // Function to toggle balance visibility
  void toggleBalanceVisibility() {
    isBalanceVisible.value = !isBalanceVisible.value;
  }

  // Function to fetch account balance (simulate fetching from an API)
  void fetchAccountBalance() {
    // Simulate a delay or API call
    Future.delayed(const Duration(seconds: 1), () {
      accountBalance.value = 2580440.30; // Example value
    });
  }
}
