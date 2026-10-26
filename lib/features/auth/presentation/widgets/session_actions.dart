import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:abolashin/core/route/navigation.dart';
import 'package:abolashin/core/servise_locator/services_locator.dart';
import 'package:abolashin/features/auth/data/datasource/auth_data_source.dart';
import 'package:abolashin/features/auth/presentation/screen/login_screen.dart';
import 'package:abolashin/features/cart/presentation/manager/cart_cubit.dart';
import 'package:abolashin/features/checkout/presentation/manager/add_order_cubit.dart';
import 'package:abolashin/features/checkout/presentation/manager/coupon_cubit.dart';
import 'package:abolashin/features/favorites/presentation/manager/favorite_cubit.dart';
import 'package:abolashin/features/home/presentation/manager/home_cubit.dart';

void reloadSessionData(BuildContext context) {
  context.read<CouponCubit>().remove();
  context.read<AddOrderCubit>().loadForSession();
  context.read<CartCubit>().syncWithServer();
  context.read<FavoriteCubit>().getFavoriteCategory();
  context.read<HomeCubit>().loadData();
}

Future<void> signOutAndReset(BuildContext context) async {
  final cart = context.read<CartCubit>();
  final home = context.read<HomeCubit>();
  final orders = context.read<AddOrderCubit>();
  final coupon = context.read<CouponCubit>();
  await getIt<AuthDataSource>().signOut();
  await cart.clearCart();
  coupon.remove();
  await orders.loadForSession();
  if (!context.mounted) return;
  context.replaceAllWith(const LoginScreen());
  home.changeSelectIndexBottom(index: 0);
}
