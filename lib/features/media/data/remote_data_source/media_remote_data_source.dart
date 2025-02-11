import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pope_desktop/core/error/Server_exception.dart';
import 'package:pope_desktop/core/error/failure.dart';
import 'package:pope_desktop/core/services/api_services.dart';

class MediaRemoteDataSource {
  Future<Either<Failure, void>> uploadAsset(
      {required FilePickerResult filePicker,
      required String path,
      required String folderId,
      required void Function(double, int, int) onProgress}) async {
    try {
      await ApiServices.uploadAsset(
          filePicker: filePicker, path: path, folderId: folderId, onProgress: onProgress);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
