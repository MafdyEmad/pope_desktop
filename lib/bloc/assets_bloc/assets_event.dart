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
  List<Object> get props => [];
}

class CreateFolderEvent extends AssetsEvent {
  final String path;

  const CreateFolderEvent(this.path);

  @override
  List<Object> get props => [];
}

class GoBackEvent extends AssetsEvent {
  final String path;
  const GoBackEvent(this.path);

  @override
  List<Object> get props => [];
}

class UploadAssetsEvent extends AssetsEvent {
  final String path;
  final String type;
  final int fileLength;
  const UploadAssetsEvent(this.path, this.type, this.fileLength);

  @override
  List<Object> get props => [];
}

class AddSayingEvent extends AssetsEvent {
  final String saying;
  final FilePickerResult file;
  final DateTime date;
  const AddSayingEvent({required this.file, required this.saying, required this.date});

  @override
  List<Object> get props => [];
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
  List<Object> get props => [];
}

class DeleteAssetsEvent extends AssetsEvent {
  final String path;
  final bool isDirectory;
  const DeleteAssetsEvent(this.path, this.isDirectory);

  @override
  List<Object> get props => [];
}
