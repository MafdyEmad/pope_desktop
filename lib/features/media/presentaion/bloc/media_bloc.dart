import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pope_desktop/features/media/data/remote_data_source/media_remote_data_source.dart';

part 'media_event.dart';
part 'media_state.dart';

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  final MediaRemoteDataSource _mediaRemoteDataSource;
  MediaBloc(MediaRemoteDataSource mediaRemoteDataSource)
      : _mediaRemoteDataSource = mediaRemoteDataSource,
        super(MediaInitial()) {
    on<UploadMedia>(_uploadMedia);
    on<DeleteMedia>(_deleteMedial);
    on<AddYoutubeLink>(_addYoutubeLink);
  }

  void _uploadMedia(UploadMedia event, Emitter emit) async {
    final result = await _mediaRemoteDataSource.uploadAsset(
      filePicker: event.filePicker,
      path: event.path,
      folderId: event.folderId,
      onProgress: (progress, total, index) {
        emit(MediaUploading(progress: Progress(progress: progress, total: total, index: index)));
      },
    );
    result.fold(
      (error) => emit(MediaUpLoadingFail(message: error.message)),
      (_) => emit(MediaUpLoadingUpSuccess()),
    );
  }

  void _addYoutubeLink(AddYoutubeLink event, Emitter emit) async {
    emit(UploadLinkLoading());
    final result = await _mediaRemoteDataSource.addYoutubeLink(
      youtubeLink: event.link,
      folderPath: event.path,
    );
    result.fold(
      (error) => emit(UploadLinkFail(message: error.message)),
      (_) => emit(UploadLinkSuccess()),
    );
  }

  void _deleteMedial(DeleteMedia event, Emitter emit) async {
    final result = await _mediaRemoteDataSource.deleteFile(folderId: event.id, isLink: event.isLink);
    result.fold(
      (error) => emit(MediaUpLoadingFail(message: error.message)),
      (_) => emit(MediaUpLoadingUpSuccess()),
    );
  }
}

class Progress {
  final double progress;
  final int total;
  final int index;

  Progress({required this.progress, required this.total, required this.index});
}
