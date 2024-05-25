import 'package:bloc/bloc.dart';
import 'package:pope_desktop/models/folder_model.dart';
import 'package:pope_desktop/repository/folder_repository.dart';

part 'image_state.dart';

class ImageCubit extends Cubit<ImageState> {
  final FolderRepository _folder;
  ImageCubit(this._folder) : super(ImageInitial());

  Future<Folder> loadFiles() async {
    final Folder response = await _folder.explore();
    return response;
  }

  Future<Folder> getAssets() async {
    final Folder response = await _folder.explore();
    return response;
  }

  Future createFolder(path) async {
    try {
      await _folder.createFolder(path);
      emit(ImageCreateFolder());
    } catch (e) {
      emit(ImageFailed(e.toString()));
    }
  }
}
