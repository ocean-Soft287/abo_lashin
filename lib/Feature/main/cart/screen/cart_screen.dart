import 'package:abolashin/Feature/main/Add%20Order/manager/add_order_state.dart';
import 'package:abolashin/Feature/main/cart/screen/widget/cart_widget.dart';
import 'package:abolashin/Feature/main/cart/screen/widget/checkout_summary.dart';
import 'package:abolashin/Feature/main/cart/screen/widget/counter_box_component.dart';
import 'package:abolashin/Feature/main/cart/screen/widget/custom_button_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constans/app_assets.dart';
import '../../../../core/constans/app_colors.dart';
import '../../../../core/network/local/cachehelper.dart';
import '../../Add Order/manager/add_order_cubit.dart';
import 'manager/cart_cubit.dart';
import 'manager/chat_state.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late String currentLang;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentLang = CacheHelper.getData(key: 'changeLang') ?? 'ar';
    final currentLocale = context.locale;

    return BlocBuilder<AddOrderCubit, AddOrderState>(
      builder: (context, addOrderState) {
        final addOrderCubit = context.read<AddOrderCubit>();

        return BlocBuilder<CartCubit, CartState>(
          builder: (context, cartState) {
            final cartCubit = context.read<CartCubit>();
            final cartItems = cartCubit.cartItems;

            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 80,
                    left: 8,
                    top: 8,
                    right: 8,
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SvgPicture.asset(AppAssets.cartIcon, height: 60),
                          const SizedBox(width: 5),
                          Text(
                            'cart'.tr(),
                            style: GoogleFonts.alexandria(
                              textStyle: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.mainAppColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          addOrderCubit.getAllAddress();
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.white,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            builder: (context) {
                              return CustomButtonSheet(
                                addOrderCubit: addOrderCubit,
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                AppAssets.locationIcon,
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'delivery_to'.tr(),
                                          style: GoogleFonts.alexandria(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.mainAppColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              addOrderCubit
                                                      .allAddressList
                                                      .isNotEmpty
                                                  ? addOrderCubit
                                                          .allAddressList[addOrderCubit
                                                              .selectAddress]
                                                          .address ??
                                                      ''
                                                  : '',
                                          style: GoogleFonts.alexandria(
                                            fontSize: 8,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.mainAppColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    addOrderCubit.allAddressList.isNotEmpty
                                        ? addOrderCubit
                                                .allAddressList[addOrderCubit
                                                    .selectAddress]
                                                .addressNotes ??
                                            ''
                                        : '',
                                    style: GoogleFonts.alexandria(
                                      textStyle: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.mainAppColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 25,
                                color: AppColors.secondAppColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ConditionalBuilder(
                          condition:
                              addOrderState is! GetCustomerSalesBasketLoading,
                          builder: (context) {
                            return ListView.separated(
                              itemCount: cartItems.length,
                              itemBuilder: (context, index) {
                                final item = cartItems[index];

                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: CachedNetworkImage(
                                                fit: BoxFit.contain,
                                                placeholder:
                                                    (context, url) => Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            8.0,
                                                          ),
                                                      child: Center(
                                                        child: CircularProgressIndicator(
                                                          value: 1.0,
                                                          color:
                                                              AppColors
                                                                  .mainAppColor,
                                                        ),
                                                      ),
                                                    ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                                imageUrl: item.image,
                                                height: 80,
                                              ),
                                            ),
                                            if (item.priceBeforeDiscount !=
                                                item.priceAfterDiscount)
                                              Positioned(
                                                top: 5,
                                                right: 5,
                                                child: Container(
                                                  decoration: const BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadiusDirectional.horizontal(
                                                          start:
                                                              Radius.circular(
                                                                5,
                                                              ),
                                                          end: Radius.circular(
                                                            5,
                                                          ),
                                                        ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                        vertical: 2,
                                                      ),
                                                  child: Text(
                                                    'special_offer'.tr(),
                                                    style:
                                                        GoogleFonts.alexandria(
                                                          fontSize: 8.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              (currentLocale.languageCode ==
                                                      'ar')
                                                  ? item.nameAr
                                                  : item.nameEn,
                                              maxLines: 2,
                                              style: GoogleFonts.alexandria(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w300,
                                                color: const Color(0xff313131),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: item
                                                            .priceAfterDiscount
                                                            .toStringAsFixed(2),
                                                        style:
                                                            GoogleFonts.alexandria(
                                                              fontSize: 15.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  const Color(
                                                                    0xff313131,
                                                                  ),
                                                            ),
                                                      ),
                                                      TextSpan(
                                                        text: 'currency'.tr(),
                                                        style:
                                                            GoogleFonts.alexandria(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  const Color(
                                                                    0xff313131,
                                                                  ),
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                CounterBox(
                                                  barcode: item.barcode,
                                                  customerQuantity:
                                                      item.customerQuantity,
                                                  stockQuantity:
                                                      item.stockQuantity,
                                                  image: item.image,
                                                  nameAr: item.nameAr,
                                                  nameEn: item.nameEn,
                                                  priceAfterDiscount:
                                                      item.priceAfterDiscount,
                                                  priceBeforeDiscount:
                                                      item.priceBeforeDiscount,
                                                  productId: item.productId,
                                                  customerquntatiy:
                                                      item.customerQuantity,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (context, index) => const SizedBox(height: 5),
                            );
                          },
                          fallback: (context) => const SkeletonizerCart(),
                        ),
                      ),
                    ],
                  ),
                ),
                CheckoutSummary(
                  addOrderCubit: addOrderCubit,
                  selectaddress:
                      addOrderCubit
                          .allAddressList[addOrderCubit.selectAddress]
                          .address
                          .toString(),

                    ),

                 ],
            );
          },
        );
      },
    );
  }
}
