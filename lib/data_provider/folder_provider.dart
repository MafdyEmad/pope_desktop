import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:pope_desktop/core/share/app_api.dart';

class FolderProvider {
  Future<http.Response> explore(String path) async {
    try {
      final response = await http.get(Uri.parse(API.explore + path));
      return response;
    } catch (e) {
      throw "حدث خطأ";
    }
  }

  Future<http.Response> createFolder(String path) async {
    try {
      final body = jsonEncode({'path': path});
      final response = await http.post(
        Uri.parse(API.createFolder),
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      return response;
    } catch (e) {
      throw "حدث خطأ";
    }
  }

  Future<StreamedResponse> uploadAssets({
    required FilePickerResult filePicker,
    required String path,
  }) async {
    try {
      String url = '${API.uploadAsset}?path=$path';
      final file = File(filePicker.files.single.path!);
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          filename: filePicker.files.single.name,
        ),
      );

      return await http.Client().send(request);
    } catch (e) {
      throw 'حدث خطأ';
    }
  }
}
