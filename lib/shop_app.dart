import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/core/utils/dependency_management/service_locator.dart';
import 'package:shop_app/core/utils/router/app_router.dart';
import 'package:shop_app/core/utils/theme/dark_theme.dart';
import 'package:shop_app/core/utils/theme/light_theme.dart';
import 'package:shop_app/core/utils/theme/theme_cubit.dart';

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<ThemeCubit>(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Shops',
            routerConfig: AppRouter.router,
            themeMode: themeMode,
            theme: buildLightTheme(),
            darkTheme: buildDarkTheme(),
          );
        },
      ),
    );
  }
}
