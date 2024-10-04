import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../services/crypro_compare_service.dart';

class CryptoController extends GetxController {
  var isLoading = true.obs;
  var selectedCrypto = 'Bitcoin'.obs;
  var walletAddress = ''.obs;
  var cryptoRate = 0.0.obs;
  var cryptoAmount = 0.0.obs;
  var trendData = <FlSpot>[].obs; // Holds chart trend data
  var percentageChange = '0.0%'.obs;
  var percentageChangeColor = Colors.green.obs;
  var availableBalance = 230.763.obs;  // Example balance

  final CryptoCompareService _cryptoService = CryptoCompareService();

  // List of cryptocurrencies
  List<Map<String, dynamic>> cryptoList = [
    {
      'name': 'Bitcoin',
      'address': 'bc1qfy5x8pycg...6zfa',
      'symbol': 'BTC',
    },
    {
      'name': 'Ethereum',
      'address': '0xabc123...xyz789',
      'symbol': 'ETH',
    },
    {
      'name': 'Cardano',
      'address': 'Sxabc123...xyz789',
      'symbol': 'ada',
    },
    {
      'name': 'Tron',
      'address': 'THEabc123...xyz789',
      'symbol': 'trx',
    },
    {
      'name': 'Dogecoin',
      'address': 'THEabc123...xyz789',
      'symbol': 'doge',
    },
    // Add more cryptos
  ];


  @override
  void onInit() {
    super.onInit();
    // Load stored balance if it exists
    double? storedBalance = box.read('balance');
    if (storedBalance != null) {
      availableBalance.value = storedBalance;
    }
    fetchCryptoData(selectedCrypto.value);
  }

  void setLoading(){
    isLoading.value = !isLoading.value;
  }

  void selectCrypto(String cryptoName) {
    selectedCrypto.value = cryptoName;
    final selected = cryptoList.firstWhere((element) => element['name'] == cryptoName);
    walletAddress.value = selected['address'];
    fetchCryptoData(cryptoName);
  }

  void fetchCryptoData(String cryptoName) async {
    final crypto = cryptoList.firstWhere((element) => element['name'] == cryptoName);
    String symbol = crypto['symbol'];
    print("fdf  $crypto");

    // Fetch the current price
    var priceData = await _cryptoService.getCryptoPrice(symbol, 'NGN');
    // priceData = json.decode(priceData)
    print('priceData: ${priceData['NGN'].toDouble()}');
    cryptoRate.value = priceData['NGN'].toDouble();

    // Fetch the historical data for the chart
    var historyData = await _cryptoService.getCryptoPriceHistory(symbol, 'NGN');
    trendData.value = historyData
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value['close'].toDouble()))
        .toList();

    // Calculate percentage change (mock example)
    double startPrice = historyData.first['close'].toDouble();
    double endPrice = historyData.last['close'].toDouble();
    double change = ((endPrice - startPrice) / startPrice) * 100;
    percentageChange.value = "${change.toStringAsFixed(2)}%";
    percentageChangeColor.value = change >= 0 ? Colors.green : Colors.red;
  }


  void calculateCryptoAmount({double ngnAmount = 0}) {
    print(val);
    cryptoAmount.value = ngnAmount * cryptoRate.value;
  }

  var selectedCoin = ''.obs;  // For selecting coin
  var coins = [
    {"name": "Ethereum", "balance": 0.002, "price": 1085.18},
    {"name": "Bitcoin", "balance": 0.0008, "price": 1085.18},
    {"name": "Cardano", "balance": 150.0, "price": 886.127},
    {"name": "TRON", "balance": 500.0, "price": 50.529},
    {"name": "Dogecoin", "balance": 450, "price": 89.39},
  ].obs;

  final GetStorage box = GetStorage();  // Persistent storage



  void depositCoin(String coinName, double amount) {
    availableBalance.value += amount;
    box.write('balance', availableBalance.value);  // Persist balance
  }

  void withdrawAmount(double amount) {
    if (availableBalance.value >= amount) {
      availableBalance.value -= amount;
      box.write('balance', availableBalance.value);  // Persist balance
    }
  }

  void setSelectedCoin(String coin) {
    selectedCoin.value = coin;
  }
}