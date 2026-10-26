import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/notifications/messaging_config.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/services/app_update/app_update_view.dart';
import 'package:abolashin/features/cart/presentation/manager/cart_cubit.dart';
import 'package:abolashin/features/cart/presentation/manager/cart_state.dart';
import 'package:abolashin/features/home/presentation/manager/home_cubit.dart';
import 'package:abolashin/features/home/presentation/manager/home_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _OptionalUpdatePrompt(child: _buildShell());
  }

  Widget _buildShell() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen:
          (previous, current) =>
              current is ChangeIndexBottom || current is InitializeHome,
      builder: (context, state) {
        HomeCubit homeCubit = BlocProvider.of(context);
        return Scaffold(
          body: SafeArea(
            top: homeCubit.currentIndex != 0,
            bottom: false,
            child: homeCubit.screen[homeCubit.currentIndex],
          ),
          bottomNavigationBar: _AppBottomNav(
            currentIndex: homeCubit.currentIndex,
            onTap: (index) => homeCubit.changeSelectIndexBottom(index: index),
          ),
        );
      },
    );
  }
}

class _OptionalUpdatePrompt extends StatefulWidget {
  final Widget child;

  const _OptionalUpdatePrompt({required this.child});

  @override
  State<_OptionalUpdatePrompt> createState() => _OptionalUpdatePromptState();
}

class _OptionalUpdatePromptState extends State<_OptionalUpdatePrompt> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) showPendingOptionalUpdate(context);
      MessagingConfig.onAppReady();
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String labelKey;

  const _NavItem(this.icon, this.activeIcon, this.labelKey);
}

class _AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _AppBottomNav({required this.currentIndex, required this.onTap});

  static const _items = [
    _NavItem(Icons.home_outlined, Icons.home_rounded, 'home'),
    _NavItem(Icons.grid_view_outlined, Icons.grid_view_rounded, 'categories'),
    _NavItem(Icons.shopping_cart_outlined, Icons.shopping_cart_rounded, 'cart'),
    _NavItem(Icons.person_outline_rounded, Icons.person_rounded, 'menu'),
  ];

  static const int _cartIndex = 2;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(top: BorderSide(color: context.colors.cardBorder)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64.h,
          child: Row(
            children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: _NavButton(
                    item: _items[i],
                    selected: i == currentIndex,
                    showCartBadge: i == _cartIndex,
                    onTap: () => onTap(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final _NavItem item;
  final bool selected;
  final bool showCartBadge;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.selected,
    required this.showCartBadge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? context.colors.primary : context.colors.textHint;
    final baseIcon = Icon(selected ? item.activeIcon : item.icon, color: color);
    Widget icon = baseIcon;
    if (showCartBadge) {
      icon = BlocSelector<CartCubit, CartState, int>(
        selector: (_) => context.read<CartCubit>().cartItems.length,
        builder:
            (context, count) => Badge(
              isLabelVisible: count > 0,
              backgroundColor: context.colors.danger,
              label: Text('$count'),
              child: baseIcon,
            ),
      );
    }

    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3.h,
              width: selected ? 32 : 0,
              decoration: BoxDecoration(
                color: context.colors.primary,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(3.r),
                ),
              ),
            ),
            const Spacer(),
            icon,
            SizedBox(height: 4.h),
            Text(
              item.labelKey.tr(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.alexandria(
                fontSize: 11.sp,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                color: color,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
