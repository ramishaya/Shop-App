import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_app/core/utils/dependency_management/service_locator.dart';
import 'package:shop_app/core/utils/theme/theme_cubit.dart';
import 'package:shop_app/shop_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  await setupServiceLocator();
  await getIt<ThemeCubit>().loadTheme();

  runApp(const ShopApp());
}