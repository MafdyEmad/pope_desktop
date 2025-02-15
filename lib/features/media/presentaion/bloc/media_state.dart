part of 'media_bloc.dart';

sealed class MediaState extends Equatable {
  const MediaState();

  @override
  List<Object> get props => [];
}

final class MediaInitial extends MediaState {}

final class MediaUploading extends MediaState {
  final Progress progress;

  const MediaUploading({required this.progress});
  @override
  List<Object> get props => [progress];
}

final class MediaUpLoadingUpSuccess extends MediaState {}

final class UploadLinkLoading extends MediaState {}

final class UploadLinkSuccess extends MediaState {}

final class UploadLinkFail extends MediaState {
  final String message;

  const UploadLinkFail({required this.message});
  @override
  List<Object> get props => [message];
}

final class MediaUpLoadingFail extends MediaState {
  final String message;

  const MediaUpLoadingFail({required this.message});
}
