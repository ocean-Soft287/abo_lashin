import 'package:abolashin/features/auth/presentation/screen/profile_screen.dart';
import 'package:abolashin/features/home/presentation/manager/home_cubit.dart';
import 'package:abolashin/features/menu/presentation/screen/privacy_policy_screen.dart';
import 'package:abolashin/core/route/navigation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:abolashin/core/constants/app_assets.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/auth/auth_guard.dart';
import 'package:abolashin/core/auth/session_manager.dart';
import 'package:abolashin/core/local/app_preferences.dart';
import 'package:abolashin/core/route/routing.dart';
import 'package:abolashin/core/servise_locator/services_locator.dart';
import 'package:abolashin/core/themes/theme_cubit.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/features/auth/presentation/widgets/logout_dialog.dart';
import 'package:abolashin/features/auth/presentation/screen/change_password_screen.dart';
import 'package:abolashin/features/favorites/presentation/screen/favorite_screen.dart';
import 'package:abolashin/features/orders/presentation/screen/previous_orders.dart';
import 'package:abolashin/features/addresses/presentation/screen/saved_addresses_screen.dart';
import 'package:abolashin/features/menu/presentation/screen/about_app_screen.dart';
import 'package:abolashin/features/menu/presentation/screen/customer_support_screen.dart';
import 'package:abolashin/features/smart_shopping/presentation/screen/smart_shopping_screen.dart';
import 'package:abolashin/features/menu/presentation/screen/faq_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _toggleLanguage(BuildContext context) {
    final code = context.locale.languageCode == 'ar' ? 'en' : 'ar';
    context.setLocale(Locale(code));
    getIt<AppPreferences>().saveLanguageCode(code);
    BlocProvider.of<HomeCubit>(context).changeSelectIndexBottom(index: 0);
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final isSignedIn = context.isSignedIn;

    Future<void> openAccountPage(Widget screen) async {
      if (await context.ensureSignedIn() && context.mounted) {
        context.pushScreen(screen);
      }
    }

    return ListView(
      padding: EdgeInsets.only(bottom: AppSpacing.xxl),
      children: [
        _MenuHeader(
          isGuest: !isSignedIn,
          onTap:
              isSignedIn
                  ? () => context.pushScreen(const ProfileScreen())
                  : () => Navigator.of(context).pushNamed(AppRoute.login),
        ),
        SizedBox(height: AppSpacing.lg),
        _MenuGroup(
          title: 'my_account'.tr(),
          children: [
            AppMenuTile(
              icon: Icons.receipt_long_rounded,
              title: 'my_orders'.tr(),
              onTap: () => openAccountPage(const PreviousOrders()),
            ),
            AppMenuTile(
              icon: Icons.auto_awesome_rounded,
              title: 'smart_shopping'.tr(),
              subtitle: 'smart_shopping_cta'.tr(),
              onTap: () => context.pushScreen(const SmartShoppingScreen()),
            ),
            AppMenuTile(
              icon: Icons.favorite_border_rounded,
              title: 'favorites'.tr(),
              onTap: () => openAccountPage(const FavoriteScreen()),
            ),
            AppMenuTile(
              icon: Icons.location_on_outlined,
              title: 'saved_addresses'.tr(),
              onTap: () => openAccountPage(const SavedAddressesScreen()),
            ),
            AppMenuTile(
              icon: Icons.person_outline_rounded,
              title: 'profile'.tr(),
              subtitle: 'account_info'.tr(),
              onTap: () => openAccountPage(const ProfileScreen()),
            ),
            AppMenuTile(
              icon: Icons.lock_outline_rounded,
              title: 'change_password'.tr(),
              onTap: () => openAccountPage(const ChangePasswordScreen()),
            ),
          ],
        ),
        _MenuGroup(
          title: 'settings'.tr(),
          children: [
            AppMenuTile(
              icon: Icons.translate_rounded,
              title: 'change_language'.tr(),
              trailing: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: context.colors.primarySoft,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  isArabic ? 'English' : 'العربية',
                  style: GoogleFonts.alexandria(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: context.colors.primary,
                  ),
                ),
              ),
              onTap: () => _toggleLanguage(context),
            ),
            const _ThemeModeTile(),
          ],
        ),
        _MenuGroup(
          title: 'help_and_info'.tr(),
          children: [
            AppMenuTile(
              icon: Icons.support_agent_rounded,
              title: 'customer_support'.tr(),
              subtitle: 'customer_support_hint'.tr(),
              onTap: () => context.pushScreen(const CustomerSupportScreen()),
            ),
            AppMenuTile(
              icon: Icons.help_outline_rounded,
              title: 'frequently_asked_questions'.tr(),
              onTap: () => context.pushScreen(const FAQPage()),
            ),
            AppMenuTile(
              icon: Icons.privacy_tip_outlined,
              title: 'policy_privacy'.tr(),
              onTap: () => context.pushScreen(const PrivacyPolicyScreen()),
            ),
            AppMenuTile(
              icon: Icons.info_outline_rounded,
              title: 'about_app'.tr(),
              onTap: () => context.pushScreen(const AboutAppScreen()),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: AppCard(
            padding: EdgeInsets.all(AppSpacing.xs),
            child:
                isSignedIn
                    ? AppMenuTile(
                      icon: Icons.logout_rounded,
                      title: 'logout'.tr(),
                      color: context.colors.danger,
                      trailing: const SizedBox.shrink(),
                      onTap:
                          () => showLogoutConfirmationDialog(context: context),
                    )
                    : AppMenuTile(
                      icon: Icons.login_rounded,
                      title: 'login'.tr(),
                      trailing: const SizedBox.shrink(),
                      onTap:
                          () => Navigator.of(context).pushNamed(AppRoute.login),
                    ),
          ),
        ),
      ],
    );
  }
}

class _MenuHeader extends StatelessWidget {
  final VoidCallback onTap;
  final bool isGuest;

  const _MenuHeader({required this.onTap, this.isGuest = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: context.colors.headerGradient,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppRadius.xl),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.xl,
        AppSpacing.page,
        AppSpacing.xxl,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.xs),
            child: Row(
              children: [
                Container(
                  width: 64.w,
                  height: 64.h,
                  padding: EdgeInsets.all(3.r),
                  decoration: BoxDecoration(
                    color: context.colors.brandYellow,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(AppAssets.logo, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isGuest
                            ? 'guest_banner_title'.tr()
                            : '${'welcome_message'.tr()}'
                                '${getIt<SessionManager>().customerName}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.alexandria(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        isGuest
                            ? 'guest_banner_subtitle'.tr()
                            : 'account_info'.tr(),
                        style: GoogleFonts.alexandria(
                          fontSize: 12.sp,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _MenuGroup({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.page,
        0,
        AppSpacing.page,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: AppSpacing.xs,
              bottom: AppSpacing.sm,
            ),
            child: AppSectionTitle(title: title),
          ),
          AppCard(
            padding: EdgeInsets.all(AppSpacing.xs),
            child: Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  if (i > 0)
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: 64.w,
                        end: AppSpacing.md,
                      ),
                      child: const Divider(),
                    ),
                  children[i],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeModeTile extends StatelessWidget {
  const _ThemeModeTile();

  static String _label(ThemeMode mode) => switch (mode) {
    ThemeMode.system => 'theme_system'.tr(),
    ThemeMode.light => 'theme_light'.tr(),
    ThemeMode.dark => 'theme_dark'.tr(),
  };

  static IconData _icon(ThemeMode mode) => switch (mode) {
    ThemeMode.system => Icons.brightness_auto_rounded,
    ThemeMode.light => Icons.light_mode_rounded,
    ThemeMode.dark => Icons.dark_mode_rounded,
  };

  void _pick(BuildContext context, ThemeMode current) {
    final cubit = context.read<ThemeCubit>();
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder:
          (sheetContext) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final mode in ThemeMode.values)
                  ListTile(
                    leading: Icon(_icon(mode)),
                    title: Text(_label(mode)),
                    trailing:
                        mode == current
                            ? Icon(
                              Icons.check_rounded,
                              color: sheetContext.colors.primary,
                            )
                            : null,
                    onTap: () {
                      cubit.setThemeMode(mode);
                      Navigator.of(sheetContext).pop();
                    },
                  ),
                SizedBox(height: AppSpacing.sm),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder:
          (context, mode) => AppMenuTile(
            icon: _icon(mode),
            title: 'appearance'.tr(),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: context.colors.primarySoft,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(
                _label(mode),
                style: GoogleFonts.alexandria(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: context.colors.primary,
                ),
              ),
            ),
            onTap: () => _pick(context, mode),
          ),
    );
  }
}
