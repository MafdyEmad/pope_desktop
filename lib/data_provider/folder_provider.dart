import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:pope_desktop/core/share/app_api.dart';
import 'package:pope_desktop/core/utile/enums.dart';

class FolderProvider {
  Future<http.Response> explore(String path) async {
    try {
      final response = await http.get(Uri.parse(API.explore + path));
      return response;
    } catch (e) {
      throw "حدث خطأ";
    }
  }

  Future<http.Response> createFolder(String path, FilesType type) async {
    try {
      final response = await http.post(
        Uri.parse('${API.createFolder}?path=$path'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"path": path, "type": type.index}),
      );
      return response;
    } catch (e) {
      throw "حدث خطأ";
    }
  }

  Future<http.StreamedResponse> uploadAssets({
    required FilePickerResult filePicker,
    required String path,
    required void Function(double) onProgress,
  }) async {
    try {
      final url = Uri.parse('${API.uploadAsset}?path=$path');
      final file = File(filePicker.files.single.path!);
      final request = http.MultipartRequest('POST', url);
      final totalBytes = file.lengthSync();

      final byteStream = file.openRead().asBroadcastStream();
      double uploadProgress = 0;

      final uploadByteStream = byteStream.transform(
        StreamTransformer<List<int>, List<int>>.fromHandlers(
          handleData: (data, sink) {
            uploadProgress += data.length / totalBytes;
            onProgress(uploadProgress);
            sink.add(data);
          },
        ),
      );
      request.files.add(http.MultipartFile(
        'file',
        uploadByteStream,
        totalBytes,
        filename: file.path.split('/').last,
      ));

      return await request.send();
    } catch (e) {
      throw 'حدث خطأ';
    }
  }

  Future<Response> delete({required String path, required bool isDirectory}) async {
    try {
      final result = await http.delete(
        Uri.parse('${API.deleteFile}?path=$path'),
      );
      return result;
    } catch (e) {
      throw 'حدث خطأ';
    }
  }

  Future<http.StreamedResponse> addSaying({
    required FilePickerResult filePicker,
    required String saying,
    required DateTime date,
    required void Function(double) onProgress,
  }) async {
    try {
      final url = Uri.parse('${API.saying}?path=اقوال يومية&saying=$saying&date=${date.toString()}');
      final file = File(filePicker.files.single.path!);
      final request = http.MultipartRequest('POST', url);
      final totalBytes = file.lengthSync();

      final byteStream = file.openRead().asBroadcastStream();
      double uploadProgress = 0;

      final uploadByteStream = byteStream.transform(
        StreamTransformer<List<int>, List<int>>.fromHandlers(
          handleData: (data, sink) {
            uploadProgress += data.length / totalBytes;
            onProgress(uploadProgress);
            sink.add(data);
          },
        ),
      );
      request.files.add(http.MultipartFile(
        'file',
        uploadByteStream,
        totalBytes,
        filename: file.path.split('/').last,
      ));

      return await request.send();
    } catch (e) {
      throw 'حدث خطأ';
    }
  }

  Future<Response> getSaying() async {
    try {
      final result = await http.get(Uri.parse(API.saying));
      return result;
    } catch (e) {
      throw 'حدث خطأ';
    }
  }

  Future<Response> deleteSaying({required String path, required int id}) async {
    try {
      final result = await http.delete(
        Uri.parse(API.saying),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"path": path, "id": id}),
      );

      return result;
    } catch (e) {
      throw 'حدث خطأ';
    }
  }

  Future<Response> getVideos(String path) async {
    try {
      final result = await http.get(Uri.parse("${API.videos}?path=$path"));
      return result;
    } catch (e) {
      throw 'حدث خطأ';
    }
  }

  Future<Response> addVideos({required String path, required String link}) async {
    try {
      final result = await http.post(
        Uri.parse(API.videos),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"path": path, "link": link}),
      );
      return result;
    } catch (e) {
      throw 'حدث خطأ';
    }
  }

  Future<Response> deleteVideos({required int id}) async {
    try {
      final result = await http.delete(
        Uri.parse("${API.videos}$id"),
      );
      return result;
    } catch (e) {
      throw 'حدث خطأ';
    }
  }
}
