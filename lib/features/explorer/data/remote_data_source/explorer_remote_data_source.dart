import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:pope_desktop/core/error/Server_exception.dart';
import 'package:pope_desktop/core/error/failure.dart';
import 'package:pope_desktop/core/services/api_services.dart';
import 'package:pope_desktop/core/util/constants.dart';
import 'package:pope_desktop/features/explorer/data/models/folder.dart';

class ExplorerRemoteDataSource {
  Future<Either<Failure, Folder>> explore(String folderPath) async {
    try {
      final response = await ApiServices.post(
        url: Constants.explore,
        newBody: {'folderPath': folderPath},
      );
      final json = jsonDecode(response.body);
      if (response.statusCode != 200) {
        return left(Failure(message: json['message']));
      }
      final folder = Folder.fromJson(json);
      return right(folder);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  Future<Either<Failure, String>> createFolder({
    required String folderName,
    required String folderType,
    required String folderPath,
  }) async {
    try {
      final response = await ApiServices.post(
        url: Constants.createFolder,
        newBody: {
          'folderName': folderName,
          'folderType': folderType,
          'folderPath': folderPath,
        },
      );

      final json = jsonDecode(response.body);
      if (response.statusCode != 201) {
        return left(Failure(message: json['message']));
      }
      return right(json['message']);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  Future<Either<Failure, String>> deleteFolder({
    required String folderId,
  }) async {
    try {
      final response = await ApiServices.delete(
        url: Constants.deleteFolder + folderId,
      );

      final json = jsonDecode(response.body);
      if (response.statusCode != 200) {
        return left(Failure(message: json['message']));
      }
      return right(json['message']);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
