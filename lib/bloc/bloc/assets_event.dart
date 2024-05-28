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
  const UploadAssetsEvent(this.path);

  @override
  List<Object> get props => [];
}
