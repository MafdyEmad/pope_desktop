import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:pope_desktop/core/error/Server_exception.dart';
import 'package:pope_desktop/core/util/constants.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

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

  static Future uploadAsset(
      {required FilePickerResult filePicker,
      required String path,
      required String folderId,
      required void Function(double, int, int) onProgress}) async {
    try {
      for (int i = 0; i < filePicker.files.length; i++) {
        final file = File(filePicker.files[i].path!);
        final totalBytes = file.lengthSync();
        final url = Uri.parse('${Constants.uploadFile}$folderId');
        final request = http.MultipartRequest('POST', url);
        final byteStream = file.openRead();

        double uploadedBytes = 0;

        // MIME type detection
        String? mimeType = lookupMimeType(file.path);
        var mediaType =
            mimeType != null ? MediaType.parse(mimeType) : MediaType('application', 'octet-stream');

        final uploadByteStream = byteStream.transform(
          StreamTransformer<List<int>, List<int>>.fromHandlers(
            handleData: (data, sink) {
              uploadedBytes += data.length;
              double progress = uploadedBytes / totalBytes;
              onProgress(progress, filePicker.files.length, i);
              sink.add(data);
            },
          ),
        );

        request.fields['folderPath'] = path;
        request.files.add(
          http.MultipartFile(
            'file',
            uploadByteStream,
            totalBytes,
            filename: file.path.split('/').last,
            contentType: mediaType,
          ),
        );

        final response = await request.send();

        if (response.statusCode != 201) {
          final body = await response.stream.bytesToString();
          throw ServerException(message: jsonDecode(body)['message']);
        }
      }
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: Constants.errorMessage);
    }
  }

  // }
  static Future<void> ss({
    required FilePickerResult filePicker,
    required String path,
    required String folderId,
    required void Function(double, int, int) onProgress,
  }) async {
    try {
      var uri = Uri.parse("${Constants.uploadFile}$folderId");

      var request = http.MultipartRequest('POST', uri);

      // Get the file's MIME type
      String? mimeType = lookupMimeType(filePicker.files.first.path!);

      // Attach the file
      var fileStream = http.MultipartFile.fromBytes(
        'file',
        await File(filePicker.files.first.path!).readAsBytes(),
        filename: basename(filePicker.files.first.path!),
        contentType: mimeType != null ? MediaType.parse(mimeType) : null,
      );

      request.files.add(fileStream);

      // Send request
      var response = await request.send();

      // Read response
      if (response.statusCode == 201) {
        print("File uploaded successfully");
      } else {
        print("Upload failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Error uploading file: $e");
    }
  }
}
