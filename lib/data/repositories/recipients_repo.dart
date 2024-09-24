import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class RecipientsRepo {
  static Future<http.Response> getRecipientsList(
      {required int page, required String search}) async {
    return await ApiClient.get(
        ENDPOINT_URL:
            AppConstants.recipientsListUrl + "?page=$page&search=$search");
  }

  static Future<http.Response> getRecipientDetails(
      {required String uuid}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.recipientdetailsUrl + "/$uuid");
  }

  static Future<http.Response> changeRecipientName({
    required String id,
    required String name,
  }) async {
    return await ApiClient.put(
        ENDPOINT_URL: AppConstants.recipientNameUpdateUrl + "/$id?name=$name");
  }

  static Future<http.Response> deleteRecipient({required String id}) async {
    return await ApiClient.delete(
        ENDPOINT_URL: AppConstants.recipientDeleteUrl + "/$id");
  }
}
