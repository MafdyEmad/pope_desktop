import 'package:get_it/get_it.dart';
import 'package:pope_desktop/features/explorer/data/remote_data_source/explorer_remote_data_source.dart';
import 'package:pope_desktop/features/explorer/presentaion/bloc/explorer_bloc.dart';
import 'package:pope_desktop/features/media/data/remote_data_source/media_remote_data_source.dart';
import 'package:pope_desktop/features/media/presentaion/bloc/media_bloc.dart';

final getIt = GetIt.instance;

void setupDependencyInjection() async {
  // explorer bloc
  getIt.registerLazySingleton<ExplorerRemoteDataSource>(() => ExplorerRemoteDataSource());
  getIt.registerLazySingleton<ExplorerBloc>(
      () => ExplorerBloc(explorerRemoteDataSource: getIt<ExplorerRemoteDataSource>()));

  // media bloc
  getIt.registerLazySingleton<MediaRemoteDataSource>(() => MediaRemoteDataSource());
  getIt.registerLazySingleton<MediaBloc>(() => MediaBloc(getIt<MediaRemoteDataSource>()));
}
