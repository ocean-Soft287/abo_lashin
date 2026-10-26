import 'dart:async';

import 'package:abolashin/features/auth/presentation/screen/login_screen.dart';
import 'package:abolashin/features/home/presentation/screen/home_screen.dart';
import 'package:abolashin/features/splash/presentation/manager/splash_startup.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:abolashin/core/constants/app_assets.dart';
import 'package:abolashin/core/services/app_update/app_update_view.dart';
import 'package:abolashin/core/route/navigation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static bool _holdingFirstFrame = false;

  static void holdFirstFrame() {
    if (_holdingFirstFrame) return;
    _holdingFirstFrame = true;
    WidgetsBinding.instance.deferFirstFrame();
    // Never leave the app stuck on the launch screen.
    Timer(const Duration(seconds: 3), releaseFirstFrame);
  }

  static void releaseFirstFrame() {
    if (!_holdingFirstFrame) return;
    _holdingFirstFrame = false;
    WidgetsBinding.instance.allowFirstFrame();
  }

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  static const double _logoWidth = 146.5;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  );
  late final Animation<double> _opacity = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, 0.7, curve: Curves.easeOut),
  );
  late final Animation<double> _scale = Tween<double>(
    begin: 0.97,
    end: 1,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  bool _started = false;
  bool _navigated = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    precacheImage(
      const AssetImage(AppAssets.splashLogo),
      context,
    ).whenComplete(_start);
  }

  Future<void> _start() async {
    SplashScreen.releaseFirstFrame();
    if (!mounted) return;

    final results = await Future.wait<Object?>([
      SplashStartup.decide(),
      _controller.forward().orCancel.catchError((_) {}),
    ]);
    _navigate(results.first! as StartupDecision);
  }

  void _navigate(StartupDecision decision) {
    if (!mounted || _navigated) return;
    _navigated = true;
    switch (decision.destination) {
      case StartupDestination.forceUpdate:
        context.replaceAllWith(ForceUpdateScreen(result: decision.update));
      case StartupDestination.home:
        context.replaceAllWith(const HomeScreen());
      case StartupDestination.login:
        context.replaceAllWith(const LoginScreen());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.brandNavy,
        body: Center(
          child: FadeTransition(
            opacity: _opacity,
            child: ScaleTransition(
              scale: _scale,
              child: Image.asset(
                AppAssets.splashLogo,
                width: _logoWidth.w,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.medium,
                gaplessPlayback: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
