part of 'image_cubit.dart';

sealed class ImageState {}

final class ImageInitial extends ImageState {}

final class ImageFailed extends ImageState {
  final String error;

  ImageFailed(this.error);
}

final class ImageSuccess extends ImageState {
  final Folder folder;

  ImageSuccess(this.folder);
}

final class ImageCreateFolder extends ImageState {}
