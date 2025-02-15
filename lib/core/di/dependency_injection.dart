import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pope_desktop/core/services/api_services.dart';
import 'package:pope_desktop/features/explorer/data/remote_data_source/explorer_remote_data_source.dart';
import 'package:pope_desktop/features/explorer/presentaion/bloc/explorer_bloc.dart';
import 'package:pope_desktop/features/media/data/remote_data_source/media_remote_data_source.dart';
import 'package:pope_desktop/features/media/presentaion/bloc/media_bloc.dart';
import 'package:pope_desktop/features/sayings/data/remote_data_source/sayings_remote_data_source.dart';
import 'package:pope_desktop/features/sayings/ui/bloc/saying_bloc.dart';

final getIt = GetIt.instance;

void setupDependencyInjection() async {
  //dio
  getIt.registerLazySingleton<Dio>(() => Dio());

  // api services
  getIt.registerLazySingleton<ApiServices>(() => ApiServices(dio: getIt<Dio>()));

  // explorer bloc
  getIt.registerLazySingleton<ExplorerRemoteDataSource>(() => ExplorerRemoteDataSource());
  getIt.registerLazySingleton<ExplorerBloc>(
      () => ExplorerBloc(explorerRemoteDataSource: getIt<ExplorerRemoteDataSource>()));

  // media bloc
  getIt.registerLazySingleton<MediaRemoteDataSource>(() => MediaRemoteDataSource(api: getIt<ApiServices>()));
  getIt.registerLazySingleton<MediaBloc>(() => MediaBloc(getIt<MediaRemoteDataSource>()));

  //sayings bloc
  getIt.registerLazySingleton<SayingsRemoteDataSource>(
      () => SayingsRemoteDataSource(api: getIt<ApiServices>()));
  getIt.registerLazySingleton<SayingBloc>(() => SayingBloc(getIt<SayingsRemoteDataSource>()));
}
