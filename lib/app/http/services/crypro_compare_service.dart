import 'dart:convert';
import 'package:http/http.dart' as http;

class CryptoCompareService {
  static const String apiKey = "2edfe5f2479b21e353047e42be3ed36657e19fad86fb6a7fb8f9a0d3d3b30cfa";
  static const String baseUrl = "https://min-api.cryptocompare.com/data";

  // Fetch current price for a given crypto and currency (e.g., USD)
  Future<Map<String, dynamic>> getCryptoPrice(String cryptoSymbol, String currency) async {
    final response = await http.get(
      Uri.parse('$baseUrl/price?fsym=$cryptoSymbol&tsyms=$currency&api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      var re = jsonDecode(response.body);
      re.forEach((String x, dynamic v)=>{
        print("resp: $x => $v")
      });
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch price data');
    }
  }

  // Fetch historical price data for charts
  Future<List<dynamic>> getCryptoPriceHistory(String cryptoSymbol, String currency) async {
    final response = await http.get(
      Uri.parse('$baseUrl/v2/histohour?fsym=$cryptoSymbol&tsym=$currency&limit=10&api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      print(json.decode(response.body)['Data']['Data']);
      return json.decode(response.body)['Data']['Data'];
    } else {
      throw Exception('Failed to fetch historical data');
    }
  }
}
