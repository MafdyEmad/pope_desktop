import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pope_desktop/bloc/app_cubit/app_cubit.dart';
import 'package:pope_desktop/core-old/theme/app_theme.dart';
import 'package:pope_desktop/core/config/app_theme.dart';
import 'package:pope_desktop/core/routing/app_router.dart';
import 'package:pope_desktop/core/routing/routes.dart';
import 'package:pope_desktop/data_provider/folder_provider.dart';
import 'package:pope_desktop/repository/folder_repository.dart';

class Pope extends StatelessWidget {
  final AppRouter appRouter;
  const Pope({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar')],
      theme: AppTheme.light,
      title: 'pope117 admin',
      locale: const Locale('ar'),
      onGenerateRoute: appRouter.generateRoute,
      initialRoute: Routes.explorerScreen,
    );
  }
}
