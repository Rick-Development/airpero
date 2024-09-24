import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class AddFundnRepo {
  static Future<http.Response> getFundHistoryList({
    required int page,
    required String transaction_id,
    required String gateway,
  }) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.fundHistoryUrl +
            "?page=$page&transaction=$transaction_id&gateway=$gateway");
  }

  static Future<http.Response> getGateways() async {
    return await ApiClient.get(ENDPOINT_URL: AppConstants.gatewaysUrl);
  }

  static Future<http.Response> manualPayment(
      {required String trxid,
      required Iterable<http.MultipartFile>? fileList,
      required Map<String, String> fields}) async {
    return await ApiClient.postMultipart(
        ENDPOINT_URL: AppConstants.manualPaymentUrl + "/$trxid",
        fields: fields,
        fileList: fileList);
  }

  static Future<http.Response> webviewPayment({required String trxId}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.webviewPayment + "?trx_id=$trxId");
  }

  static Future<http.Response> paymentRequest(
      {required Map<String, String> fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.paymentRequest, fields: fields);
  }

  static Future<http.Response> cardPayment(
      {required Map<String, String> fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.cardPayment, fields: fields);
  }

  static Future<http.Response> onPaymentDone(
      {required Map<String, String> fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.onPaymentDone, fields: fields);
  }
}
