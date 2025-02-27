import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pope_desktop/bloc/app_cubit/app_cubit.dart';
import 'package:pope_desktop/bloc/assets_bloc/assets_bloc.dart';
import 'package:pope_desktop/core/theme/app_theme.dart';
import 'package:pope_desktop/data_provider/folder_provider.dart';
import 'package:pope_desktop/presentation/screens/main_screen.dart';
import 'package:pope_desktop/repository/folder_repository.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(1280, 720),
    center: true,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(ScreenUtilInit(
    designSize: const Size(1280, 720), // specify the design size
    builder: (_, __) => const Pope(),
  ));
}

class Pope extends StatelessWidget {
  const Pope({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AssetsBloc(FolderRepository(FolderProvider()))),
        BlocProvider(create: (context) => AppCubit()),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ar')],
        theme: lightTheme,
        title: 'pope117 admin',
        locale: const Locale('ar'),
        home: const MainScreen(),
      ),
    );
  }
}
