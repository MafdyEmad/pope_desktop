part of 'image_cubit.dart';

sealed class ImageState {}

final class ImageInitial extends ImageState {}

final class ImageFailed extends ImageState {
  final String error;

  ImageFailed(this.error);
}

final class ImageSuccess extends ImageState {
  final String msg;

  ImageSuccess(this.msg);
}

final class ImageLoading extends ImageState {}

final class ImageNavigateToFolder extends ImageState {
  ImageNavigateToFolder();
}
