import 'package:flutter/material.dart';

import 'package:abolashin/core/themes/app_colors.dart';

/// Shopping intents of a store owner. Each one leads only to data the app
/// already loads: home product lists, catalog categories, orders,
/// favorites and the cart.
enum SmartGoal {
  stockStore(
    titleKey: 'smart_goal_stock',
    subtitleKey: 'smart_goal_stock_sub',
    icon: Icons.storefront_rounded,
    gradient: _warm,
  ),
  essentials(
    titleKey: 'smart_goal_essentials',
    subtitleKey: 'smart_goal_essentials_sub',
    icon: Icons.shopping_basket_rounded,
    gradient: _violet,
    // Backend main category IDs: sugar & flour, oils & vinegar, pasta &
    // soup, canned food, milk & cheese, spices, food additions.
    categoryIds: [37, 34, 38, 36, 39, 40, 33],
  ),
  drinksSnacks(
    titleKey: 'smart_goal_drinks_snacks',
    subtitleKey: 'smart_goal_drinks_snacks_sub',
    icon: Icons.local_drink_rounded,
    gradient: _sky,
    // Drinks, snacks & chips, biscuits & chocolate, dessert preparation.
    categoryIds: [31, 42, 32, 35],
  ),
  household(
    titleKey: 'smart_goal_household',
    subtitleKey: 'smart_goal_household_sub',
    icon: Icons.cleaning_services_rounded,
    gradient: _fresh,
    // Tools & detergents, hair & body care, consumables & batteries.
    categoryIds: [30, 41, 43],
  ),
  offers(
    titleKey: 'smart_goal_offers',
    subtitleKey: 'smart_goal_offers_sub',
    icon: Icons.local_offer_rounded,
    gradient: _offer,
  ),
  restock(
    titleKey: 'smart_goal_restock',
    subtitleKey: 'smart_goal_restock_sub',
    icon: Icons.autorenew_rounded,
    gradient: _primary,
  );

  const SmartGoal({
    required this.titleKey,
    required this.subtitleKey,
    required this.icon,
    required this.gradient,
    this.categoryIds = const [],
  });

  final String titleKey;
  final String subtitleKey;
  final IconData icon;
  final LinearGradient Function(AppPalette palette) gradient;

  /// Main categories this goal groups; any the catalog no longer returns are
  /// skipped.
  final List<int> categoryIds;
}

LinearGradient _warm(AppPalette palette) => palette.warmGradient;

LinearGradient _violet(AppPalette palette) => palette.violetGradient;

LinearGradient _sky(AppPalette palette) => palette.skyGradient;

LinearGradient _fresh(AppPalette palette) => palette.freshGradient;

LinearGradient _offer(AppPalette palette) => palette.offerGradient;

LinearGradient _primary(AppPalette palette) => palette.primaryGradient;
