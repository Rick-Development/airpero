import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../utils/app_constants.dart';
import '../../utils/services/localstorage/hive.dart';
import '../../utils/services/localstorage/keys.dart';

class ApiClient {
  static var BASE_URL = AppConstants.baseUrl;

  static Future<http.Response> get({required String ENDPOINT_URL}) async {
    var headers = {
      'Authorization': 'Bearer ${HiveHelp.read(Keys.token) ?? ''}',
      'Accept': 'application/json'
    };
    var request = http.Request('GET', Uri.parse(BASE_URL + ENDPOINT_URL));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);
    return responsedata;
  }

  static Future<http.Response> post(
      {required String ENDPOINT_URL, Map<String, dynamic>? fields}) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${HiveHelp.read(Keys.token) ?? ''}',
    };
    var request = http.Request('POST', Uri.parse(BASE_URL + ENDPOINT_URL));
    request.body = json.encode(fields);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);
    return responsedata;
  }
  
  static Future<http.Response> patch(
      {required String ENDPOINT_URL}) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${HiveHelp.read(Keys.token) ?? ''}',
    };
    var request = http.Request('PATCH', Uri.parse(BASE_URL + ENDPOINT_URL));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);
    return responsedata;
  }
  
  static Future<http.Response> put(
      {required String ENDPOINT_URL}) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${HiveHelp.read(Keys.token) ?? ''}',
    };
    var request = http.Request('PUT', Uri.parse(BASE_URL + ENDPOINT_URL));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);
    return responsedata;
  }

  static Future<http.Response> postMultipart(
      {required String ENDPOINT_URL,
      Map<String, String>? fields,
      MultipartFile? files,
      Iterable<MultipartFile>? fileList}) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${HiveHelp.read(Keys.token) ?? ''}',
    };

    var request =
        http.MultipartRequest('POST', Uri.parse(BASE_URL + ENDPOINT_URL));
    request.headers.addAll(headers);
    if (fields != null) {
      request.fields.addAll(fields);
    }

    if (files != null) {
      request.files.add(files);
    }

    if (fileList != null && fileList.isNotEmpty) {
      request.files.addAll(fileList);
    }

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);
    return responsedata;
  }

  static Future<http.Response> delete({required String ENDPOINT_URL}) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${HiveHelp.read(Keys.token) ?? ''}',
    };
    var request = http.Request('DELETE', Uri.parse(BASE_URL + ENDPOINT_URL));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);
    return responsedata;
  }
}
