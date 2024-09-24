import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class AddRecipientRepo {

  static Future<http.Response> getServices({required String country_id}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.getServicesUrl + "?country_id=$country_id");
  }

    static Future<http.Response> addRecipient(
      {required Iterable<MultipartFile>? fileList,
      required Map<String, String> fields}) async {
    return await ApiClient.postMultipart(
        ENDPOINT_URL: AppConstants.addRecipientUrl,
        fields: fields,
        fileList: fileList);
  }

}
