import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_app/core/utils/dependency_management/service_locator.dart';
import 'package:shop_app/features/shops/presentation/view_models/shops_cubit/shops_cubit.dart';
import 'package:shop_app/features/shops/presentation/views/home_view.dart';

abstract final class AppRouter {
  static const String kHomeView = '/';

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: kHomeView,
    debugLogDiagnostics: kDebugMode,
    routes: [
      GoRoute(
        path: kHomeView,
        name: 'shops-home',
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt<ShopsCubit>()..fetchShops(),
            child: const HomeView(),
          );
        },
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              state.error?.toString() ?? 'Route not found',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    },
  );
}
