import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class MoneyRequestRepo {
  static Future<http.Response> getWallets({required String uuid}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.getMoneyTransferRequest + "/$uuid");
  }

  static Future<http.Response> moneyRequest({required Map<String, dynamic> fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.postMoneyTransferRequest,fields: fields);
  }
  static Future<http.Response> recipientstore({required Map<String, dynamic> fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.recipientstore,fields: fields);
  }
  
  static Future<http.Response> moneyRequestAction({required Map<String, dynamic> fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.moneyRequestAction,fields: fields);
  }

  static Future<http.Response> getMoneyRequestHistory({required String page}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.moneyRequestHistory+"?page=$page");
  }
}
