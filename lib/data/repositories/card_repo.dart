import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class CardRepo {
  static Future<http.Response> getVirtualCards() async {
    return await ApiClient.get(ENDPOINT_URL: AppConstants.virtualCardsUrl);
  }

  static Future<http.Response> cardOrder() async {
    return await ApiClient.get(ENDPOINT_URL: AppConstants.cardOrderForm);
  }

  static Future<http.Response> cardTransaction({required String id, required String page}) async {
    return await ApiClient.get(ENDPOINT_URL: AppConstants.cardTransaction+"/$id"+"?page=$page");
  }

  static Future<http.Response> cardOrderSubmit(
      {required Iterable<MultipartFile>? fileList,
      required Map<String, String> fields}) async {
    return await ApiClient.postMultipart(
        ENDPOINT_URL: AppConstants.cardOrderFormSubmit,
        fields:fields,fileList: fileList);
  }

  static Future<http.Response> cardOrderReSubmit(
      {required Iterable<MultipartFile>? fileList,
      required Map<String, String> fields}) async {
    return await ApiClient.postMultipart(
        ENDPOINT_URL: AppConstants.cardOrderFormReSubmit,
        fields:fields,fileList: fileList);
  }
  
  static Future<http.Response> blockCard(
      {required String id, required String reason}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.cardBlockUrl + "/$id",
        fields: {"reason": reason});
  }

  static Future<http.Response> cardOrderConfirm(
      {required String id}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.cardOrderConfirm + "/$id");
  }
}
