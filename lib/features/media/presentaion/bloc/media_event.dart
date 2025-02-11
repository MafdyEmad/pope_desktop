part of 'media_bloc.dart';

sealed class MediaEvent extends Equatable {
  const MediaEvent();

  @override
  List<Object> get props => [];
}

final class UploadMedia extends MediaEvent {
  final FilePickerResult filePicker;
  final String path;
  final String folderId;

  const UploadMedia({
    required this.filePicker,
    required this.path,
    required this.folderId,
  });

  @override
  List<Object> get props => [];
}

final class DeleteMedia extends MediaEvent {
  final String id;

  const DeleteMedia({required this.id});

  @override
  List<Object> get props => [];
}
