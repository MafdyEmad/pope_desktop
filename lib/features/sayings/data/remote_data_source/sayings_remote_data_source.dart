import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pope_desktop/core/error/Server_exception.dart';
import 'package:pope_desktop/core/error/failure.dart';
import 'package:pope_desktop/core/services/api_services.dart';
import 'package:pope_desktop/core/util/constants.dart';
import 'package:pope_desktop/features/sayings/data/models/saying_model.dart';

class SayingsRemoteDataSource {
  final ApiServices _api;

  SayingsRemoteDataSource({required ApiServices api}) : _api = api;

  Future<Either<Failure, void>> addSaying({
    required FilePickerResult filePicker,
    required String text,
    required String publishDate,
  }) async {
    try {
      await _api.addSayings(filePicker: filePicker, text: text, publishDate: publishDate);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  Future<Either<Failure, void>> deleteSaying({
    required String id,
  }) async {
    try {
      await ApiServices.delete(url: Constants.deleteSayings + id);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  Future<Either<Failure, List<SayingModel>>> getSayings() async {
    try {
      final result = await ApiServices.get(url: Constants.getSayings);
      final data = jsonDecode(result.body)['data'] as List<dynamic>;
      return right(data.map((e) => SayingModel.fromJson(e)).toList());
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
