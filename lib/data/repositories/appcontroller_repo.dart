import 'package:http/http.dart' as http;

import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class AppControllerRepo {
  static Future<http.Response> getAppConfig() async {
    return await ApiClient.get(ENDPOINT_URL: AppConstants.appConfigUrl);
  }
  static Future<http.Response> getLanguageList() async {
    return await ApiClient.get(ENDPOINT_URL: AppConstants.languageUrl);
  }
  static Future<http.Response> getLanguageById({required String id}) async {
    return await ApiClient.get(ENDPOINT_URL: AppConstants.languageUrl+'?id=$id');
  }
}
