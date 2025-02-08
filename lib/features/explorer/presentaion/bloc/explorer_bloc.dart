import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pope_desktop/features/explorer/data/models/folder.dart';
import 'package:pope_desktop/features/explorer/data/remote_data_source/explorer_remote_data_source.dart';

part 'explorer_event.dart';
part 'explorer_state.dart';

class ExplorerBloc extends Bloc<ExplorerEvent, ExplorerState> {
  final ExplorerRemoteDataSource _explorerRemoteDataSource;
  ExplorerBloc({required ExplorerRemoteDataSource explorerRemoteDataSource})
      : _explorerRemoteDataSource = explorerRemoteDataSource,
        super(ExplorerInitial()) {
    on<ExploreEvent>(_explore);
    on<GoHomeEvent>(_goHome);
    on<CreateFolderEvent>(_createFolder);
    on<DeleteFolderEvent>(_deleteFolder);
  }
  void _explore(ExploreEvent event, Emitter emit) async {
    emit(ExplorerExploreLoading());
    final result = await _explorerRemoteDataSource.explore(event.folderPath);
    result.fold(
      (error) => emit(ExplorerExploreFail(message: error.message)),
      (folder) => emit(ExplorerExploreSuccess(folder: folder)),
    );
  }

  void _goHome(GoHomeEvent event, Emitter emit) {
    emit(ExplorerInitial());
  }

  void _createFolder(CreateFolderEvent event, Emitter emit) async {
    emit(CRUDFolderLoading());
    final result = await _explorerRemoteDataSource.createFolder(
      folderName: event.folderName,
      folderType: event.folderType,
      folderPath: event.folderPath,
    );
    result.fold(
      (error) => emit(CRUDFolderFail(message: error.message)),
      (message) => emit(CRUDFolderSuccess(message: message)),
    );
  }

  void _deleteFolder(DeleteFolderEvent event, Emitter emit) async {
    emit(CRUDFolderLoading());
    final result = await _explorerRemoteDataSource.deleteFolder(folderId: event.folderId);
    result.fold(
      (error) => emit(CRUDFolderFail(message: error.message)),
      (message) => emit(CRUDFolderSuccess(message: message)),
    );
  }
}
