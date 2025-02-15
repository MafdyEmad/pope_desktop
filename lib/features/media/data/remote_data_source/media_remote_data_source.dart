import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pope_desktop/core/error/Server_exception.dart';
import 'package:pope_desktop/core/error/failure.dart';
import 'package:pope_desktop/core/services/api_services.dart';
import 'package:pope_desktop/core/util/constants.dart';

class MediaRemoteDataSource {
  final ApiServices _api;

  MediaRemoteDataSource({required ApiServices api}) : _api = api;
  Future<Either<Failure, void>> uploadAsset(
      {required FilePickerResult filePicker,
      required String path,
      required String folderId,
      required void Function(double, int, int) onProgress}) async {
    try {
      await _api.uploadAsset(filePicker: filePicker, path: path, folderId: folderId, onProgress: onProgress);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  Future<Either<Failure, void>> deleteFile({
    bool isLink = false,
    required String folderId,
  }) async {
    try {
      await ApiServices.delete(
          url: !isLink ? Constants.deleteFile + folderId : Constants.deleteLink + folderId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  Future<Either<Failure, void>> addYoutubeLink({
    required String youtubeLink,
    required String folderPath,
  }) async {
    try {
      await ApiServices.post(url: Constants.addYoutubeLink, newBody: {
        "youtubeLink": youtubeLink,
        "folderPath": folderPath,
      });
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
