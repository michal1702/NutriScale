import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class ApiConnector {
  final String baseURL;
  final String apiKey;

  ApiConnector(this.baseURL, this.apiKey);

  Future<Map<String, dynamic>> request(
      String path, Map<String, String> parameters) async {
    final uri = Uri.https(baseURL, path, parameters);
    try {
      final response = await http.get(uri, headers: buildHeaders());
      return json.decode(response.body);
    } catch (e) {
      print("Request error: $e");
      throw e.toString();
    }
  }

  Future<List<dynamic>> requestList(
      String path, Map<String, String> parameters) async {
    final uri = Uri.https(baseURL, path, parameters);
    try {
      final response = await http.get(uri, headers: buildHeaders());
      return json.decode(response.body);
    } catch (e) {
      print("Request error: $e");
      throw e.toString();
    }
  }

  Map<String, String> buildHeaders();
}
