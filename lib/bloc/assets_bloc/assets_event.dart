part of 'assets_bloc.dart';

sealed class AssetsEvent extends Equatable {
  const AssetsEvent();

  @override
  List<Object> get props => [];
}

class LoadFoldersEvent extends AssetsEvent {
  final String path;
  const LoadFoldersEvent(this.path);

  @override
  List<Object> get props => [path];
}

class CreateFolderEvent extends AssetsEvent {
  final String path;
  final FilesType type;

  const CreateFolderEvent(this.path, this.type);

  @override
  List<Object> get props => [path, type];
}

class GoBackEvent extends AssetsEvent {
  final String path;
  const GoBackEvent(this.path);

  @override
  List<Object> get props => [path];
}

class UploadAssetsEvent extends AssetsEvent {
  final String path;
  final FilesType type;
  final int fileLength;
  const UploadAssetsEvent(this.path, this.type, this.fileLength);

  @override
  List<Object> get props => [path, type, fileLength];
}

class AddSayingEvent extends AssetsEvent {
  final String saying;
  final FilePickerResult file;
  final DateTime date;
  const AddSayingEvent({required this.file, required this.saying, required this.date});

  @override
  List<Object> get props => [saying, file, date];
}

class GetSayingEvent extends AssetsEvent {
  const GetSayingEvent();

  @override
  List<Object> get props => [];
}

class DeleteSayingEvent extends AssetsEvent {
  final int id;
  final String path;
  const DeleteSayingEvent({required this.id, required this.path});

  @override
  List<Object> get props => [id, path];
}

class DeleteAssetsEvent extends AssetsEvent {
  final String path;
  final bool isDirectory;
  const DeleteAssetsEvent(this.path, this.isDirectory);

  @override
  List<Object> get props => [path, isDirectory];
}

class GetVideosEvent extends AssetsEvent {
  final String path;
  const GetVideosEvent(this.path);

  @override
  List<Object> get props => [path];
}

class AddVideosEvent extends AssetsEvent {
  final String path;
  final String link;

  const AddVideosEvent(this.path, this.link);

  @override
  List<Object> get props => [path, link];
}

class DeleteVideosEvent extends AssetsEvent {
  final int id;

  const DeleteVideosEvent(this.id);

  @override
  List<Object> get props => [id];
}

class ShowErrorEvent extends AssetsEvent {
  final String error;

  const ShowErrorEvent(this.error);

  @override
  List<Object> get props => [error];
}
