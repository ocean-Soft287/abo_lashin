import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/features/cart/presentation/manager/cart_cubit.dart';
import 'package:abolashin/features/cart/presentation/manager/cart_state.dart';
import 'package:abolashin/features/smart_shopping/data/model/smart_shopping_goals.dart';
import 'package:abolashin/features/smart_shopping/presentation/widgets/smart_goal_card.dart';
import 'package:abolashin/features/smart_shopping/presentation/widgets/smart_goal_suggestions.dart';
import 'package:abolashin/features/smart_shopping/presentation/widgets/smart_request_bar.dart';
import 'package:abolashin/features/smart_shopping/presentation/widgets/smart_shopping_actions.dart';
import 'package:abolashin/features/smart_shopping/presentation/widgets/smart_shopping_hero.dart';

/// Shopping assistant for store owners: pick a goal, then a suggestion that
/// opens matching products from the catalog.
class SmartShoppingScreen extends StatefulWidget {
  const SmartShoppingScreen({super.key});

  @override
  State<SmartShoppingScreen> createState() => _SmartShoppingScreenState();
}

class _SmartShoppingScreenState extends State<SmartShoppingScreen> {
  final ValueNotifier<SmartGoal?> _selected = ValueNotifier(
    SmartGoal.stockStore,
  );

  @override
  void dispose() {
    _selected.dispose();
    super.dispose();
  }

  void _toggle(SmartGoal goal) =>
      _selected.value = _selected.value == goal ? null : goal;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppTopBar(
        title: '${'smart_shopping'.tr()} ✨',
        actions: [const _CartButton(), SizedBox(width: AppSpacing.md)],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xxl,
              ),
              children: [
                const SmartShoppingHero(),
                SizedBox(height: AppSpacing.xxl),
                Text(
                  'smart_shopping_intro'.tr(),
                  style: GoogleFonts.alexandria(
                    fontSize: 15.sp,
                    height: 1.7,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSpacing.xl),
                // Only the goal list listens to the selection.
                ValueListenableBuilder<SmartGoal?>(
                  valueListenable: _selected,
                  builder:
                      (context, selected, _) => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final goal in SmartGoal.values)
                            Padding(
                              padding: EdgeInsets.only(bottom: AppSpacing.xl),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SmartGoalCard(
                                    goal: goal,
                                    selected: goal == selected,
                                    onTap: () => _toggle(goal),
                                  ),
                                  AnimatedSize(
                                    duration: const Duration(milliseconds: 220),
                                    alignment: AlignmentDirectional.topStart,
                                    child:
                                        goal == selected
                                            ? SmartGoalSuggestions(goal: goal)
                                            : const SizedBox(
                                              width: double.infinity,
                                            ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                ),
                Text(
                  'smart_shopping_note'.tr(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.alexandria(
                    fontSize: 11.sp,
                    height: 1.5,
                    color: colors.textHint,
                  ),
                ),
              ],
            ),
          ),
          const SmartRequestBar(),
        ],
      ),
    );
  }
}

class _CartButton extends StatelessWidget {
  const _CartButton();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CartCubit, CartState, int>(
      selector: (_) => context.read<CartCubit>().cartItems.length,
      builder:
          (context, count) => SizedBox.square(
            dimension: 48.r,
            child: IconButton.filled(
              tooltip: 'cart'.tr(),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.accentBlue,
                foregroundColor: Colors.white,
              ),
              onPressed: () => SmartShoppingActions.openHomeTab(context, 2),
              icon: Badge(
                isLabelVisible: count > 0,
                backgroundColor: context.colors.danger,
                label: Text('$count'),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
            ),
          ),
    );
  }
}
