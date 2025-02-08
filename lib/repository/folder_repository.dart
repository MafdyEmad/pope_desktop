import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import 'package:pope_desktop/core-old/utile/enums.dart';
import 'package:pope_desktop/data_provider/folder_provider.dart';
import 'package:pope_desktop/models/folder_model.dart';
import 'package:pope_desktop/models/saying_model.dart';
import 'package:pope_desktop/models/video_model.dart';

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

  Future createFolder(String path, FilesType type) async {
    try {
      final result = await _folder.createFolder(path, type);
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
    required void Function(double, int, int) onProgress,
  }) async {
    try {
      await _folder.uploadAssets(filePicker: filePicker, path: path, onProgress: onProgress);
    } catch (e) {
      throw e.toString();
    }
  }

  Future addSaying({
    required FilePickerResult filePicker,
    required String saying,
    required DateTime date,
    required void Function(double) onProgress,
  }) async {
    try {
      final StreamedResponse result =
          await _folder.addSaying(filePicker: filePicker, onProgress: onProgress, saying: saying, date: date);
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

  Future<Sayings> getSaying() async {
    try {
      final result = await _folder.getSaying();
      if (result.statusCode == 200) {
        return Sayings.fromJson(jsonDecode(result.body));
      } else {
        throw jsonDecode(result.body)['msg'];
      }
    } catch (e) {
      throw 'حدث خطأ';
    }
  }

  Future deleteSaying({required String path, required int id}) async {
    try {
      final result = await _folder.deleteSaying(path: path, id: id);
      if (result.statusCode == 200) {
        return jsonDecode(result.body)['msg'];
      } else {
        throw jsonDecode(result.body)['msg'];
      }
    } catch (e) {
      throw 'حدث خطأ';
    }
  }

  Future<List<Video>> getVideos(String path) async {
    try {
      final result = await _folder.getVideos(path);
      if (result.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(result.body);
        List<Video> videos = jsonList.map((json) => Video.fromJson(json)).toList();
        return videos;
      } else {
        throw jsonDecode(result.body)['msg'];
      }
    } catch (e) {
      throw 'حدث خطأ';
    }
  }

  Future addVideos({required String path, required String link}) async {
    try {
      final result = await _folder.addVideos(path: path, link: link);
      if (result.statusCode == 200) {
        return jsonDecode(result.body)['msg'];
      } else {
        throw jsonDecode(result.body)['msg'];
      }
    } catch (e) {
      throw 'حدث خطأ';
    }
  }

  Future deleteVideos({required int id}) async {
    try {
      final result = await _folder.deleteVideos(id: id);
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
