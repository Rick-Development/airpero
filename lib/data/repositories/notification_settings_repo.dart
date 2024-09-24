import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class NotificationSettingsRepo {
  static Future<http.Response> getNotificationSettings() async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.notificationSettingsUrl);
  }

  static Future<http.Response> postNotificationSettings(
      {Map<String, dynamic>? fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.notificationPermissionUrl,
        fields: fields);
  }
}
