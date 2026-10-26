import 'package:flutter/material.dart';

extension AppNavigation on BuildContext {
  Future<T?> pushScreen<T extends Object?>(Widget screen) {
    return Navigator.of(
      this,
    ).push<T>(MaterialPageRoute<T>(builder: (_) => screen));
  }

  Future<T?> replaceAllWith<T extends Object?>(Widget screen) {
    return Navigator.of(this).pushAndRemoveUntil<T>(
      PageRouteBuilder<T>(
        pageBuilder: (_, __, ___) => screen,
        transitionsBuilder:
            (_, animation, __, child) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
      ),
      (_) => false,
    );
  }

  Future<T?> replaceAllWithNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(
      this,
    ).pushNamedAndRemoveUntil<T>(routeName, (_) => false, arguments: arguments);
  }
}
