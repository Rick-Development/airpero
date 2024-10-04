import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  // For encoding/decoding JSON

class ApiServices {
  // Function to make POST requests with proper headers and JSON body
  Future<String> makePostRequest(String routeUrl, Map<String, dynamic> data, Map<String, String> headers) async {
    var url = Uri.parse(routeUrl);

    // Add Content-Type header for JSON format
    headers['Content-Type'] = 'application/json';

    try {
      // Sending POST request with encoded JSON body
      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      // Check if the response is successful (status code 200-299)
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.body;
      } else {
        // Get.snackbar('Failed to make POST request:', response.body,
        // backgroundColor: Colors.red, colorText: Colors.white,
        // );
        throw Exception('Failed to make POST request: ${response.statusCode}');
      }
    } catch (error) {
      print('Error making POST request: $error');
      rethrow;  // Rethrow the error for further handling
    }
  }

  // Function to make GET requests with headers
  Future<String> makeGetRequest(String routeUrl, Map<String, String> headers) async {
    var url = Uri.parse(routeUrl);

    try {
      // Sending GET request
      var response = await http.get(url, headers: headers);
    // print(response.body);
      // Check if the response is successful (status code 200-299)
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.body;
      } else {
        throw Exception('Failed to make GET request: ${response.statusCode}');
      }
    } catch (error) {
      print('Error making GET request: $error');
      rethrow;  // Rethrow the error for further handling
    }
  }
}
