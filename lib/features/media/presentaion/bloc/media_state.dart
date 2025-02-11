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
}

final class MediaUpLoadingUpSuccess extends MediaState {}

final class MediaUpLoadingFail extends MediaState {
  final String message;

  const MediaUpLoadingFail({required this.message});
}
