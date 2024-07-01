import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pope_desktop/core/utile/enums.dart';
import 'package:pope_desktop/models/config_model.dart';
import 'package:pope_desktop/models/folder_model.dart';
import 'package:pope_desktop/models/progress_model.dart';
import 'package:pope_desktop/models/saying_model.dart';
import 'package:pope_desktop/models/video_model.dart';
import 'package:pope_desktop/repository/folder_repository.dart';
part 'assets_event.dart';
part 'assets_state.dart';

class AssetsBloc extends Bloc<AssetsEvent, AssetsState> {
  final FolderRepository _folder;
  AssetsBloc(this._folder)
      : super(
          AssetsState(
            state: AssetState.init,
            msg: '',
            folder: Folder(path: '', files: [], config: Config(type: FilesType.folder)),
            progress: Progress(index: 0, total: 0, progress: 0),
            saying: Sayings(rows: []),
            video: const [],
          ),
        ) {
    on<LoadFoldersEvent>(_loadFolders);
    on<CreateFolderEvent>(_createFolder);
    on<GoBackEvent>(_goBack);
    on<UploadAssetsEvent>(_uploadAssets);
    on<DeleteAssetsEvent>(_delete);
    on<AddSayingEvent>(_addSaying);
    on<GetSayingEvent>(_getSaying);
    on<DeleteSayingEvent>(_deleteSaying);
    on<GetVideosEvent>(_getVideos);
    on<AddVideosEvent>(_addVideos);
    on<DeleteVideosEvent>(_deleteVideos);
    on<ShowErrorEvent>(_showError);
  }
  void _loadFolders(LoadFoldersEvent event, Emitter emit) async {
    emit(state.copyWith(state: AssetState.loading));
    try {
      final folder = await _folder.explore(event.path);
      emit(state.copyWith(state: AssetState.loaded, folder: folder));
    } catch (e) {
      emit(state.copyWith(state: AssetState.failed, msg: e.toString()));
    }
  }

  void _createFolder(CreateFolderEvent event, Emitter emit) async {
    emit(state.copyWith(state: AssetState.loading));
    try {
      final String msg = await _folder.createFolder(event.path, event.type);
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

  void _uploadAssets(UploadAssetsEvent event, Emitter emit) async {
    final FilePickerResult? file = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: event.type == FilesType.image
          ? ['jpeg', 'jpg' 'gif', 'png']
          : event.type == FilesType.audio
              ? ['mp3']
              : ['pdf'],
    );
    if (file == null) return;
    try {
      final msg = await _folder.uploadAssets(
          filePicker: file,
          path: event.path,
          onProgress: (progress, total, index) => emit(state.copyWith(
              state: AssetState.progress,
              progress: Progress(progress: progress, total: total, index: index))));
      emit(state.copyWith(state: AssetState.success, msg: msg));
    } catch (e) {
      emit(state.copyWith(state: AssetState.failed, msg: e.toString()));
    }
  }

  void _addSaying(AddSayingEvent event, Emitter emit) async {
    emit(state.copyWith(state: AssetState.loading));
    try {
      final msg = await _folder.addSaying(
          date: event.date,
          saying: event.saying,
          filePicker: event.file,
          onProgress: (progress) => emit(state.copyWith(
              state: AssetState.progress, progress: Progress(progress: progress, total: 1, index: 1))));
      emit(state.copyWith(state: AssetState.success, msg: msg));
    } catch (e) {
      emit(state.copyWith(state: AssetState.failed, msg: e.toString()));
    }
  }

  void _getSaying(GetSayingEvent event, Emitter emit) async {
    try {
      final saying = await _folder.getSaying();
      emit(state.copyWith(saying: saying));
    } catch (e) {
      emit(state.copyWith(state: AssetState.failed, msg: e.toString()));
    }
  }

  void _deleteSaying(DeleteSayingEvent event, Emitter emit) async {
    emit(state.copyWith(state: AssetState.loading));
    try {
      final msg = await _folder.deleteSaying(path: event.path, id: event.id);
      emit(state.copyWith(state: AssetState.success, msg: msg));
    } catch (e) {
      emit(state.copyWith(state: AssetState.failed, msg: e.toString()));
    }
  }

  void _delete(DeleteAssetsEvent event, Emitter emit) async {
    emit(state.copyWith(state: AssetState.loading));
    try {
      final msg = await _folder.delete(path: event.path, isDirectory: event.isDirectory);
      emit(state.copyWith(state: AssetState.success, msg: msg));
    } catch (e) {
      emit(state.copyWith(state: AssetState.failed, msg: e.toString()));
    }
  }

  void _getVideos(GetVideosEvent event, Emitter emit) async {
    try {
      final video = await _folder.getVideos(event.path);
      emit(state.copyWith(video: video));
    } catch (e) {
      emit(state.copyWith(state: AssetState.failed, msg: e.toString()));
    }
  }

  void _addVideos(AddVideosEvent event, Emitter emit) async {
    emit(state.copyWith(state: AssetState.loading));
    try {
      final msg = await _folder.addVideos(path: event.path, link: event.link);
      emit(state.copyWith(state: AssetState.loaded, msg: msg));
    } catch (e) {
      emit(state.copyWith(state: AssetState.failed, msg: e.toString()));
    }
  }

  void _deleteVideos(DeleteVideosEvent event, Emitter emit) async {
    emit(state.copyWith(state: AssetState.loading));
    try {
      final msg = await _folder.deleteVideos(
        id: event.id,
      );
      emit(state.copyWith(state: AssetState.loaded, msg: msg));
    } catch (e) {
      emit(state.copyWith(state: AssetState.failed, msg: e.toString()));
    }
  }

  void _showError(ShowErrorEvent event, Emitter emit) async {
    emit(state.copyWith(state: AssetState.failed, msg: event.error));
  }
}
