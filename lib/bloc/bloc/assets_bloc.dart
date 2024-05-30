import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pope_desktop/data_provider/folder_provider.dart';
import 'package:pope_desktop/models/folder_model.dart';
import 'package:pope_desktop/repository/folder_repository.dart';
part 'assets_event.dart';
part 'assets_state.dart';

class AssetsBloc extends Bloc<AssetsEvent, AssetsState> {
  final FolderRepository _folder;
  AssetsBloc(this._folder)
      : super(AssetsState(state: AssetState.init, msg: '', folder: Folder(path: '', files: []))) {
    on<LoadFoldersEvent>(_loadFolders);
    on<CreateFolderEvent>(_createFolder);
    on<GoBackEvent>(_goBack);
    on<UploadAssetsEvent>(_uploadAssets);
  }
  void _loadFolders(LoadFoldersEvent event, Emitter emit) async {
    emit(state.copyWith(state: AssetState.loading));
    try {
      final Folder folder = await _folder.explore(event.path);
      emit(state.copyWith(state: AssetState.loaded, folder: folder));
    } catch (e) {
      emit(state.copyWith(state: AssetState.failed, msg: e.toString()));
    }
  }

  void _createFolder(CreateFolderEvent event, Emitter emit) async {
    emit(state.copyWith(state: AssetState.loading));
    try {
      final String msg = await _folder.createFolder(event.path);
      emit(state.copyWith(state: AssetState.success, msg: msg));
    } catch (e) {
      emit(state.copyWith(state: AssetState.failed, msg: e.toString()));
    }
  }

  void _goBack(GoBackEvent event, Emitter emit) async {
    emit(state.copyWith(state: AssetState.loading));
    final filePath = event.path;
    final parts = filePath.split('/');
    parts.removeLast();
    final fullPath = parts.join('/');
    try {
      final Folder folder = await _folder.explore(fullPath);
      emit(state.copyWith(state: AssetState.loaded, folder: folder));
    } catch (e) {
      emit(state.copyWith(state: AssetState.failed, msg: e.toString()));
    }
  }

  bool _isImage(String filePath) {
    final RegExp regex = RegExp(r'(jpeg|jpg|gif|png)$', caseSensitive: false);
    return regex.hasMatch(filePath);
  }

  void _uploadAssets(UploadAssetsEvent event, Emitter emit) async {
    final FilePickerResult? file = await FilePicker.platform.pickFiles();
    if (file == null) return;

    if (!_isImage(file.files[0].extension.toString())) {
      emit(state.copyWith(state: AssetState.failed, msg: 'يجب اختيار صوره'));
      emit(state.copyWith(state: AssetState.loaded));
      return;
    }
    emit(state.copyWith(state: AssetState.loading));
    try {
      final msg = await _folder.uploadAsserts(filePicker: file, path: event.path);
      emit(state.copyWith(state: AssetState.success, msg: msg));
    } catch (e) {
      emit(state.copyWith(state: AssetState.failed, msg: e.toString()));
    }
  }
}
