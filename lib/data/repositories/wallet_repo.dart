import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class WalletRepo {
  static Future<http.Response> getWallets() async {
    return await ApiClient.get(ENDPOINT_URL: AppConstants.dashboardUrl);
  }

  static Future<http.Response> walletStore(
      {required String currency_code}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.walletStore,
        fields: {
          "currency_code": currency_code,
        });
  }

  static Future<http.Response> moneyExchange(
      {required Map<String, dynamic>? fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.moneyExchange, fields: fields);
  }

  static Future<http.Response> defaultWallet({required String id}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.defaultWallet + "/$id");
  }
}
