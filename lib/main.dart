import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pope_desktop/core/di/dependency_injection.dart';
import 'package:pope_desktop/core/routing/app_router.dart';
import 'package:pope_desktop/features/explorer/presentaion/bloc/explorer_bloc.dart';
import 'package:pope_desktop/features/media/presentaion/bloc/media_bloc.dart';
import 'package:pope_desktop/pope.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencyInjection();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(1280, 720),
    center: true,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ExplorerBloc>.value(
        value: getIt<ExplorerBloc>(),
      ),
      BlocProvider<MediaBloc>.value(
        value: getIt<MediaBloc>(),
      )
    ],
    child: ScreenUtilInit(
      designSize: const Size(1280, 720),
      builder: (_, __) => Pope(
        appRouter: AppRouter(),
      ),
    ),
  ));
}
