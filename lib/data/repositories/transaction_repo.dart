import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class TransactionRepo {
  static Future<http.Response> getTransactionList({
    required int page,
    required String transaction_id,
    required String start_date,
    required String end_date,
    String? uuid,
    bool? isFromWallet = false,
  }) async {
    if (isFromWallet == true) {
      return await ApiClient.get(
          ENDPOINT_URL: AppConstants.walletTransaction +
              "/$uuid" +
              "?page=$page&transaction=$transaction_id&start_date=$start_date&end_date=$end_date");
    } else {
      return await ApiClient.get(
          ENDPOINT_URL: AppConstants.transactionUrl +
              "?page=$page&transaction=$transaction_id&start_date=$start_date&end_date=$end_date");
    }
  }
}
