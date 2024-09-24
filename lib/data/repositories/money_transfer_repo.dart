import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class MoneyTransferRepo {
  static Future<http.Response> getTransferCurrencies() async {
    return await ApiClient.get(ENDPOINT_URL: AppConstants.transferCurrencies);
  }

  static Future<http.Response> getTransferRecipient(
      {required String countryName,
      required String search,
      required int page}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.transferRecipient +
            "/$countryName?page=$page&search=$search");
  }

  static Future<http.Response> getTransferReview({required String uuid}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.transferReview + "/$uuid");
  }

  static Future<http.Response> transferPaymentStore(
      {Map<String, dynamic>? fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.transferPaymentStore, fields: fields);
  }

  static Future<http.Response> transferPost(
      {Map<String, dynamic>? fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.transferPost, fields: fields);
  }

  static Future<http.Response> transferPay({required String uuid}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.transferPay + "/$uuid");
  }

  static Future<http.Response> transferDetails({required String uuid}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.transferDetails + "/$uuid");
  }
  
  static Future<http.Response> getCurrencyRate({Map<String, dynamic>? fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.currencyRate,fields: fields);
  }

  static Future<http.Response> getTransferOtp({required String option}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.transferOtp+"?option=$option");
  }

  static Future<http.Response> transferOtp({Map<String, dynamic>? fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.transferOtp,fields: fields);
  }
}
