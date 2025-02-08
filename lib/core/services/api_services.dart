import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pope_desktop/core/error/Server_exception.dart';
import 'package:pope_desktop/core/util/constants.dart';

class ApiServices {
  static Future<http.Response> post({required String url, Map<String, dynamic>? newBody}) async {
    final Map<String, dynamic> body = {};
    if (newBody != null) {
      body.addAll(newBody);
    }
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );
      return response;
    } catch (e) {
      throw ServerException(message: Constants.errorMessage);
    }
  }

  static Future<http.Response> delete({required String url}) async {
    try {
      final response = await http.delete(
        Uri.parse(url),
      );
      return response;
    } catch (e) {
      throw ServerException(message: Constants.errorMessage);
    }
  }
}
