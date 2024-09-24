import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class PayoutRepo {
  static Future<http.Response> getPayoutHistoryList({
    required int page,
    required String transaction_id,
    required String start_date,
    required String end_date,
  }) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.payoutListUrl +
            "?page=$page&transaction=$transaction_id&start_date=$start_date&end_date=$end_date");
  }

  static Future<http.Response> getPayouts() async {
    return await ApiClient.get(ENDPOINT_URL: AppConstants.payoutUrl);
  }

  static Future<http.Response> getBankFromBank(
      {required String bankName}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.getBankFromBankUrl,
        fields: {
          "bankName": bankName,
        });
  }

  static Future<http.Response> getBankFromCurrency(
      {required String currencyCode}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.getBankFromCurrencyUrl,
        fields: {
          "currencyCode": currencyCode,
        });
  }

  static Future<http.Response> payoutSubmit(
      {required Iterable<MultipartFile>? fileList,
      required String trxId,
      required Map<String, String> fields}) async {
    return await ApiClient.postMultipart(
        ENDPOINT_URL: AppConstants.payoutSubmitUrl + "/$trxId",
        fields: fields,
        fileList: fileList);
  }

  static Future<http.Response> payoutRequest(
      {required Map<String, String> fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.payoutRequestUrl, fields: fields);
  }

  static Future<http.Response> flutterwaveSubmit(
      {required Map<String, String> fields, required String trxId}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.flutterwaveSubmitUrl + "/$trxId",
        fields: fields);
  }

  static Future<http.Response> paystackSubmit(
      {required Map<String, String> fields, required String trxId}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.paystackSubmitUrl + "/$trxId",
        fields: fields);
  }

  static Future<http.Response> payoutConfirm({required String trxId}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.payoutConfirmUrl + "/$trxId");
  }
}
