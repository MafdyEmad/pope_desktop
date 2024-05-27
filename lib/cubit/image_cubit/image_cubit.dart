import 'package:bloc/bloc.dart';
import 'package:pope_desktop/models/folder_model.dart';
import 'package:pope_desktop/repository/folder_repository.dart';

part 'image_state.dart';

class ImageCubit extends Cubit<ImageState> {
  final FolderRepository _folder;
  ImageCubit(this._folder) : super(ImageInitial());

  Future<Folder> loadFiles(String path) async {
    return await _folder.explore(path);
  }

  // Future<Folder> getAssets(String path) async {
  //   final Folder response = await _folder.explore(path);
  //   return response;
  // }

  Future createFolder(path) async {
    try {
      final String msg = await _folder.createFolder(path);
      emit(ImageSuccess(msg));
    } catch (e) {
      emit(ImageFailed(e.toString()));
    }
  }

  void navigateToFolder() {
    emit(ImageNavigateToFolder());
  }

  String getFolderPath(List folderPath) {
    String path = '';
    for (var file in folderPath) {
      if (path.isEmpty) {
        path += file;
      } else {
        path += '/$file';
      }
    }
    return path;
  }
}
