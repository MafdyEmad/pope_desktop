import 'dart:convert';

import 'package:http/http.dart' as http;

class FolderProvider {
  Future<http.Response> explore() async {
    try {
      final response = await http.get(Uri.parse('https://beec-197-59-60-25.ngrok-free.app/explore/'));
      return response;
    } catch (e) {
      throw "حدث خطأ";
    }
  }

  Future<http.Response> createFolder(String path) async {
    try {
      final body = jsonEncode({'path': path});
      final response = await http.post(
        Uri.parse('https://beec-197-59-60-25.ngrok-free.app/create_folder'),
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      return response;
    } catch (e) {
      throw "حدث خطأ";
    }
  }

  Future getAssets(String path) async {
    try {
      final body = jsonEncode({'path': path});
      final response = await http.post(
        Uri.parse('https://beec-197-59-60-25.ngrok-free.app/explore/$path'),
        headers: {"Content-Type": "application/json"},
        body: body,
      );
    } catch (e) {
      throw "حدث خطأ";
    }
  }
}
