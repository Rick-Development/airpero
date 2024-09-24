import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class TransferHistoryRepo {
  static Future<http.Response> getTransferHistory(
      {required int page,
      required String name,
      required String start_date,
      required String end_date}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.transferHistory +
            "?page=$page&name=$name&start_date=$start_date&end_date=$end_date");
  }
}
