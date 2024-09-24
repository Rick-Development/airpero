import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class SupportTicketRepo {
  static Future<http.Response> getSupportTicketList({required int page}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.supportTicketListUrl + "?page=$page");
  }

  static Future<http.Response> getSupportTicketView(
      {required String ticket}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.supportTicketViewUrl + "/$ticket");
  }

  static Future<http.Response> createSupportTicket(
      {Map<String, String>? fields,
      Iterable<http.MultipartFile>? fileList}) async {
    return await ApiClient.postMultipart(
        ENDPOINT_URL: AppConstants.supportTicketCreateUrl,
        fields: fields,
        fileList: fileList);
  }

  static Future<http.Response> replySupportTicket(
      {Map<String, String>? fields,
      required String id,
      Iterable<http.MultipartFile>? fileList}) async {
    return await ApiClient.postMultipart(
        ENDPOINT_URL: AppConstants.supportTicketReplyUrl + "/$id",
        fields: fields,
        fileList: fileList);
  }

  static Future<http.Response> closeSupportTicket({required String id}) async {
    return await ApiClient.patch(
        ENDPOINT_URL: AppConstants.supportTicketCloseUrl + "/$id");
  }
}
