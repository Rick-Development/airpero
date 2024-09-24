import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class ReferRepo {
  static Future<http.Response> getRefer({required String  page}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.referUrl+"?page=$page");
  }
}
