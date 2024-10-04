import 'package:waiz/routes/routes.dart';
import 'package:get/get.dart';
  import 'package:http/http.dart' as http;
  import 'dart:convert';

// import '../../../../config/config.dart';
import '../../../Models/user/User.dart';

  class GiftCardController extends GetxController {
    // Observables to store products, categories, and specific product details as maps
    RxMap<String, dynamic> products = <String, dynamic>{}.obs;
    RxList<dynamic> categories = <dynamic>[].obs;
    RxMap<String, dynamic> productDetails = <String, dynamic>{}.obs;
    RxMap<String, dynamic> selectedCard = <String, dynamic>{}.obs;

    var isLoading = false.obs;
    var filteredProducts = <dynamic>[].obs; // Observable for filtered products

    // Access token for API authorization
    String accessToken = 'Config.accessToken';
    void selectCard() {

    }
    // Function to fetch all products
    Future<void> getProducts() async {
      isLoading(true);
      final url = Uri.parse("https://giftcards.reloadly.com/products");
      try {
        final response = await http.get(
          url,
          headers: {
            "Accept": "application/com.reloadly.giftcards-v1+json",
            "Authorization": "Bearer $accessToken",
          },
        );

        if (response.statusCode == 200) {
          products.value = json.decode(response.body) as Map<String, dynamic>;
          filteredProducts.value = products['content']; // Initialize with all products
        } else {
          Get.snackbar("Error", "Failed to load products");
        }
      } catch (e) {
        Get.snackbar("Error", "Error occurred: $e");
      } finally {
        isLoading(false);
      }
    }


    void searchProducts(String query) {
      // Ensure 'content' is a list of maps
      if (products['content'] is List<dynamic>) {
        // print('Products content: ${products['content']}'); // Debugging output
        products['content'].forEach((product) =>{
        // print(product)
        print("\n \n \n $product")

        });

        try {
          // Filter the products based on the search query
          var filteredProducts = products['content'].where((product) {
            // Debugging each product
            print('Product: $product');

            if (product is Map<String, dynamic> && product['productName'] is String) {
              return product['productName'].toLowerCase().contains(query.toLowerCase());
            }

            // In case product is not a map or productName is not a string
            print('Product does not match the expected structure.');
            return false;
          }).toList();

          // Update the observable with filtered products
          products.value = {'content': filteredProducts};

        } catch (e) {
          print('Error during filtering: $e');
        }
      } else {
        print("Error: 'content' is not a List or contains invalid data");
      }
    }



    // Function to fetch product categories
    Future<void> getCategories() async {
      isLoading(true);
      final url = Uri.parse("https://giftcards.reloadly.com/product-categories");
      try {
        final response = await http.get(
          url,
          headers: {
            "Accept": "application/com.reloadly.giftcards-v1+json",
            "Authorization": "Bearer $accessToken",
          },
        );

        if (response.statusCode == 200) {
          categories.value = json.decode(response.body) as List<dynamic>;
          // print(categories.value);
        } else {
          Get.snackbar("Error", "Failed to load categories");
        }
      } catch (e) {
        Get.snackbar("Error", "Error occurred: $e");
      } finally {
        isLoading(false);
      }
    }
// Loading indicator for buy operation
    var isBuying = false.obs;

    Future<String> buyGiftcard({ required int productId,required int quantity,required String email,required String phoneNumber,required double eurAmount,required int subTotal,required int total, required Map<String,dynamic> checkoutDetails}) async {

      // Fetch user info from local storage or API
      User user = User(); // Replace with actual user fetching logic if necessary
      String accessToken = user.accessToken ?? '';  // Handle null
      String tokenType = user.tokenType ?? '';      // Handle null
      print("access token: $accessToken");
      final url = Uri.parse("${WebRoutes.baseUrl}/api/giftcards/purchase");
      try {
        final response = await http.post(
          url,
            // Set headers for authorization
            headers : {
              'Authorization': '$tokenType $accessToken',
              'Accept': 'application/json',
              'Content-Type': 'application/json', // Important: make sure this is set
            },
          body: json.encode({
            'productId': productId,
            'quantity': quantity,
            'email': email,
            'phone_number': phoneNumber,
            'eurCurrency': 'EUR',
            'eurAmount': eurAmount,
            'ngnCurrency': 'NGN',
            'sub_total': subTotal,
            'total': total,
          }),
        );
        print(response);

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          return 'Purchase successful';
        } else {Get.snackbar("Error", "Failed to load product details");
          final responseData = json.decode(response.body);
          return 'Purchase failed: ${responseData['message']}';

        }
      } catch (e) {Get.snackbar("Error", "Failed to load product details");
        return 'Error: $e';
      }
    }

    // Function to fetch product details by ID
    Future<void> getProductByID(int id) async {
      isLoading(true);
      final url = Uri.parse("https://giftcards.reloadly.com/products/$id");
      try {
        final response = await http.get(
          url,
          headers: {
            "Accept": "application/com.reloadly.giftcards-v1+json",
            "Authorization": "Bearer $accessToken",
          },
        );

        if (response.statusCode == 200) {
          productDetails.value = json.decode(response.body) as Map<String, dynamic>;
        } else {
          Get.snackbar("Error", "Failed to load product details");
        }
      } catch (e) {
        Get.snackbar("Error", "Error occurred: $e");
      } finally {
        isLoading(false);
      }
    }
  }
