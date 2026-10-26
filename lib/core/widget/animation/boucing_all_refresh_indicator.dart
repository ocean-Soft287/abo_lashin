import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BouncingBallRefreshIndicator extends StatefulWidget {
  final double progress;
  final bool isRefreshing;

  const BouncingBallRefreshIndicator({
    super.key,
    required this.progress,
    required this.isRefreshing,
  });

  @override
  _BouncingBallRefreshIndicatorState createState() =>
      _BouncingBallRefreshIndicatorState();
}

class _BouncingBallRefreshIndicatorState
    extends State<BouncingBallRefreshIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _innerBallController;
  late Animation<double> _innerBallAnimation;

  @override
  void initState() {
    super.initState();

    _innerBallController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _innerBallAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _innerBallController, curve: Curves.easeInOut),
    );
    _innerBallController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _innerBallController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 0.0,
        end: widget.isRefreshing ? 1.0 : widget.progress,
      ),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        final outerBounceOffset = -value * 35;

        return Transform.translate(
          offset: Offset(0, outerBounceOffset),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              AnimatedBuilder(
                animation: _innerBallAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _innerBallAnimation.value),
                    child: Container(
                      width: 20.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
