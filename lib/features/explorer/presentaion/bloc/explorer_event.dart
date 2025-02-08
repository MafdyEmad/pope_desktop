part of 'explorer_bloc.dart';

sealed class ExplorerEvent extends Equatable {
  const ExplorerEvent();

  @override
  List<Object> get props => [];
}

final class ExploreEvent extends ExplorerEvent {
  final String folderPath;

  const ExploreEvent({required this.folderPath});
}

final class GoHomeEvent extends ExplorerEvent {}

final class CreateFolderEvent extends ExplorerEvent {
  final String folderName;
  final String folderType;
  final String folderPath;

  const CreateFolderEvent({required this.folderName, required this.folderType, required this.folderPath});
}

final class DeleteFolderEvent extends ExplorerEvent {
  final String folderId;

  const DeleteFolderEvent({required this.folderId});
}
