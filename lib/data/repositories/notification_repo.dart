import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class NotificationRepo {
  static Future<http.Response> getPusherConfig() async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.pusherConfigUrl);
  }
}
