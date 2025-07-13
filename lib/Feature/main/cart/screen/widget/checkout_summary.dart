import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constans/app_colors.dart';
import '../../../../../core/sharde/widget/default_button.dart';
import '../../../../../core/sharde/widget/navigation.dart';
import '../../../Add Order/manager/add_order_cubit.dart';
import '../../../Add Order/screen/add_order_screen.dart';
import '../../../Add Order/screen/widget/inactive_account_dialog.dart';
import '../manager/cart_cubit.dart';
import '../manager/chat_state.dart';
import 'custom_button_sheet.dart'; // assuming this is where CartState classes are defined

class CheckoutSummary extends StatelessWidget {
  final AddOrderCubit addOrderCubit;
  final String selectaddress;

  const CheckoutSummary({
    super.key,
    required this.addOrderCubit,
    required this.selectaddress,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is CartFailure) {
          return Center(child: Text(state.error));
        }

        final cartItems = context.read<CartCubit>().cartItems;
        final totalPrice = context.read<CartCubit>().calculateTotalPrice();
        final address =
            addOrderCubit.allAddressList[addOrderCubit.selectAddress];
        final billValue =
            double.tryParse(address.billValue?.toString() ?? '0') ?? 0;

        return Container(
          color: const Color(0xffE7E7E7),
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: totalPrice.toStringAsFixed(2),
                          style: GoogleFonts.alexandria(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff313131),
                          ),
                        ),
                        TextSpan(
                          text: 'currency'.tr(),
                          style: GoogleFonts.alexandria(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff313131),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'subtotal'.tr(),
                    style: GoogleFonts.alexandria(
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w200,
                        color: Color(0xff313131),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: DefaultButton(
                    heightButton: 40,
                    text: 'complete_purchase'.tr(),
                    function: () async {
                      final isActive =
                          await addOrderCubit.checkCustomerIsActive();

                      // if (selectaddress == "null") {
                      //   addOrderCubit.getAllAddress();
                      //   showModalBottomSheet(
                      //     context: context,
                      //     backgroundColor: Colors.white,
                      //     isScrollControlled: true,
                      //     shape: const RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.zero,
                      //     ),
                      //     builder: (context) {
                      //       return CustomButtonSheet(
                      //         addOrderCubit: addOrderCubit,
                      //       );
                      //     },
                      //   );
                      // } else
                        if (isActive.contains("True")) {
                        if (cartItems.isNotEmpty && totalPrice >= billValue) {
                          navigato(
                            context,
                            AddOrderScreen(
                              listItemName: cartItems,
                              allAddressModel: address,
                              listItem:
                                  cartItems
                                      .map((item) => item.toMap())
                                      .toList(),
                              total: totalPrice,
                              address: selectaddress,
                            ),
                          );
                        } else {
                          _showMinimumOrderError(context, billValue);
                        }
                      } else {
                        showInactiveAccountDialog(context);
                      }
                    },

                    backgroundColor: AppColors.mainAppColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMinimumOrderError(BuildContext context, double billValue) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${'minimum_order_value'.tr()} $billValue'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
