import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
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

  Future getAssets(String path) async {
    try {
      final request = await http.post(
        Uri.parse('${API.explore}$path'),
      );
    } catch (e) {
      throw "حدث خطأ";
    }
  }

  Future<void> uploadAssets(FilePickerResult filePickerResult, String path, String type, String id,
      Function(double) onProgress) async {
    String url = '${API.uploadAsset}?path=$path&id=12&type=image';

    final file = File(filePickerResult.files.single.path!);

    final request = http.MultipartRequest('POST', Uri.parse(url));

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: filePickerResult.files.single.name,
      ),
    );
    final response = await http.Client().send(request);
    if (response.statusCode == 200) {
      print('File uploaded successfully');
    } else {
      print('File upload failed with status: ${response.statusCode}');
    }
  }
}
