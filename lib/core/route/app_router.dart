import 'package:flutter/material.dart';

import 'package:abolashin/features/auth/presentation/screen/login_screen.dart';
import 'package:abolashin/features/auth/presentation/screen/register_screen.dart';
import 'package:abolashin/features/home/presentation/screen/home_screen.dart';
import 'package:abolashin/features/splash/presentation/screen/splash_screen.dart';
import 'routing.dart';

abstract final class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final Widget page = switch (settings.name) {
      AppRoute.splash => const SplashScreen(),
      AppRoute.login => const LoginScreen(),
      AppRoute.register => const RegisterScreen(),
      AppRoute.home => const HomeScreen(),
      _ => const SplashScreen(),
    };
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}
