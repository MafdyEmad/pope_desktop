import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:pope_desktop/core/error/Server_exception.dart';
import 'package:pope_desktop/core/util/constants.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class ApiServices {
  final Dio _dio;

  ApiServices({required Dio dio}) : _dio = dio;

  static Future<http.Response> get({required String url}) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      return response;
    } catch (e) {
      throw ServerException(message: Constants.errorMessage);
    }
  }

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

  Future<void> addSayings({
    required FilePickerResult filePicker,
    required String text,
    required String publishDate,
  }) async {
    try {
      final file = filePicker.files.first;
      String fileName = basename(file.name);
      String filePath = file.path!;

      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(filePath, filename: fileName),
        "text": text,
        "publishDate": publishDate,
      });

      final response = await _dio.post(
        Constants.addSayings,
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );
      print(response.statusCode);

      if (response.statusCode != 201) {
        throw ServerException(message: response.data['message'] ?? "Unknown error");
      }
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: Constants.errorMessage);
    }
  }

  Future<void> uploadAsset({
    required FilePickerResult filePicker,
    required String path,
    required String folderId,
    required void Function(double progress, int sent, int total) onProgress,
  }) async {
    try {
      for (int i = 0; i < filePicker.files.length; i++) {
        String? mimeType = lookupMimeType(filePicker.files[i].path!);
        var mediaType =
            mimeType != null ? MediaType.parse(mimeType) : MediaType('application', 'octet-stream');
        String fileName = basename(filePicker.files[i].name);
        String filePath = filePicker.files[i].path!;
        FormData formData = FormData.fromMap({
          "file": await MultipartFile.fromFile(filePath, filename: fileName, contentType: mediaType),
          "folderPath": path,
        });
        final response = await _dio.post(
          "${Constants.uploadFile}$folderId",
          onSendProgress: (count, total) {
            double progress = count / total;
            onProgress(progress, i, filePicker.files.length);
          },
          data: formData,
          options: Options(
            headers: {
              "Content-Type": "multipart/form-data",
            },
          ),
        );

        if (response.statusCode != 201) {
          throw ServerException(message: response.data['message']);
        }
      }
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: Constants.errorMessage);
    }
  }
}
