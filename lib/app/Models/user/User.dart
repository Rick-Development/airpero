import 'package:waiz/app/http/controllers/auth/auth_controller.dart';
import 'package:get_storage/get_storage.dart';

import '../../http/controllers/user_controller.dart';
import 'package:get/get.dart';

class User extends AuthController {
  late Map<String, dynamic> user_details;
  GetStorage storage = GetStorage();
  // UserController userController = Get.put(UserController());
  User() {

    user_details = getUserDetails();  // Assuming getUserDetails fetches user details
    // print(user_details);
  }

  // Getter for username
  String get username {
    return user_details['username'] ?? '';  // Handle null safety
  }

  // Getter for username
  String get pin {
    return  storage.read('user_pin') ?? '';  // Handle null safety
  }

  // Getter for mobile number
  String get mobile {
    return user_details['mobile'].toString();  // Convert to string for consistency
  }

  // Getter for balance with Naira symbol
  String get balance {
    // Convert to double and format to 2 decimal places
    double balanceValue = double.tryParse(user_details['balance']?.toString() ?? '0') ?? 0.0;
    print("balance: $user_details");
    return '\u20A6 ${balanceValue.toStringAsFixed(2)}';  // Ensures 2 decimal places
  }


  // Getter for full name (firstname + lastname)
  String get fullName {
    String firstname = user_details['firstname'] ?? '';
    String lastname = user_details['lastname'] ?? '';
    return '$firstname $lastname';
  }

  // Getter for email
  String get email {
    return user_details['email'] ?? '';
  }

  // Getter for address details
  String get address {
    Map<String, dynamic> address = user_details['address'] ?? {};
    String fullAddress = '${address['address'] ?? ''}, ${address['city'] ?? ''}, ${address['state'] ?? ''}, ${address['zip'] ?? ''}, ${address['country'] ?? ''}';
    return fullAddress.trim();
  }

  // Getter for account creation date
  String get createdAt {
    return user_details['created_at'] ?? '';
  }

  // Getter for profile completion status
  bool get isProfileComplete {
    return user_details['profile_complete'] == 1;
  }

  // Getter for KYC status
  bool get isKYCVerified {
    return user_details['kv'] == 1;
  }

  // Getter for email verification
  bool get isEmailVerified {
    return user_details['ev'] == 1;
  }

  // Getter for mobile verification
  bool get isMobileVerified {
    return user_details['sv'] == 1;
  }

  // Getter for ban reason, if any
  String? get banReason {
    return user_details['ban_reason'];
  }

  // Function to check if the user is banned
  bool get isBanned {
    return user_details['status'] == 0 && user_details['ban_reason'] != null;
  }

  String get accessToken{
    return storage.read('accessToken') ?? "";
  }

  String get tokenType{
    return storage.read('tokenType') ?? "";
  }
}
