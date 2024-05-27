import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pope_desktop/models/folder_model.dart';
import 'package:pope_desktop/repository/folder_repository.dart';
import 'package:path/path.dart' as path;
part 'assets_event.dart';
part 'assets_state.dart';

class AssetsBloc extends Bloc<AssetsEvent, AssetsState> {
  final FolderRepository _folder;
  AssetsBloc(this._folder)
      : super(AssetsState(state: States.init, msg: '', folder: Folder(path: '', files: []))) {
    on<LoadFoldersEvent>(_loadFolders);
    on<CreateFolderEvent>(_createFolder);
    on<GoBackEvent>(_goBack);
  }
  void _loadFolders(LoadFoldersEvent event, Emitter emit) async {
    emit(state.copyWith(state: States.loading));
    try {
      final Folder folder = await _folder.explore(event.path);
      emit(state.copyWith(state: States.loaded, folder: folder));
    } catch (e) {
      emit(state.copyWith(state: States.failed, msg: e.toString()));
    }
  }

  void _createFolder(CreateFolderEvent event, Emitter emit) async {
    emit(state.copyWith(state: States.loading));
    try {
      final String msg = await _folder.createFolder(event.path);
      emit(state.copyWith(state: States.success, msg: msg));
    } catch (e) {
      emit(state.copyWith(state: States.failed, msg: e.toString()));
    }
  }

  void _goBack(GoBackEvent event, Emitter emit) async {
    emit(state.copyWith(state: States.loading));
    final filePath = event.path;
    List<String> parts = path.split(filePath);
    if (parts.isNotEmpty) {
      parts.removeLast();
    }
    final finalPath = path.joinAll(parts);
    try {
      final Folder folder = await _folder.explore(finalPath);
      emit(state.copyWith(state: States.loaded, folder: folder));
    } catch (e) {
      emit(state.copyWith(state: States.failed, msg: e.toString()));
    }
  }
}
