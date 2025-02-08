part of 'explorer_bloc.dart';

sealed class ExplorerState extends Equatable {
  const ExplorerState();

  @override
  List<Object> get props => [];
}

final class ExplorerInitial extends ExplorerState {}

// explore
final class ExplorerExploreLoading extends ExplorerState {}

final class ExplorerExploreSuccess extends ExplorerState {
  final Folder folder;

  const ExplorerExploreSuccess({required this.folder});
}

final class ExplorerExploreFail extends ExplorerState {
  final String message;

  const ExplorerExploreFail({required this.message});
}

// create folder
final class CRUDFolderLoading extends ExplorerState {}

final class CRUDFolderSuccess extends ExplorerState {
  final String message;

  const CRUDFolderSuccess({required this.message});
}

final class CRUDFolderFail extends ExplorerState {
  final String message;

  const CRUDFolderFail({required this.message});
}
