import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import 'package:pope_desktop/data_provider/folder_provider.dart';
import 'package:pope_desktop/models/folder_model.dart';

class FolderRepository {
  final FolderProvider _folder;
  FolderRepository(this._folder);

  Future<Folder> explore(String path) async {
    try {
      final result = await _folder.explore(path);
      final json = jsonDecode(result.body);
      if (result.statusCode != 200) {
        throw json['msg'];
      } else {
        return Folder.fromJson(json);
      }
    } catch (e) {
      throw 'حدث خطأ';
    }
  }

  Future createFolder(String path) async {
    try {
      final result = await _folder.createFolder(path);
      final json = jsonDecode(result.body);
      if (result.statusCode != 200) {
        throw json['msg'];
      } else {
        return json['msg'];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future uploadAssets({
    required FilePickerResult filePicker,
    required String path,
    required void Function(double) onProgress,
  }) async {
    try {
      final StreamedResponse result =
          await _folder.uploadAssets(filePicker: filePicker, path: path, onProgress: onProgress);

      if (result.statusCode == 200) {
        return 'تم رفع الملف بنجاح';
      } else {
        throw 'حدث خطأ';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future delete({required String path, required bool isDirectory}) async {
    try {
      final result = await _folder.delete(path: path, isDirectory: isDirectory);

      if (result.statusCode == 200) {
        return jsonDecode(result.body)['msg'];
      } else {
        throw jsonDecode(result.body)['msg'];
      }
    } catch (e) {
      throw 'حدث خطأ';
    }
  }
}
