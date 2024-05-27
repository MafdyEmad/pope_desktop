import 'dart:convert';
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
      throw e.toString();
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
}
