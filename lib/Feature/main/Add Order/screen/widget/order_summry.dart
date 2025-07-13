import 'package:abolashin/Feature/main/Home/home_screen.dart';
import 'package:abolashin/Feature/main/Home/manager/home_cubit.dart';
import 'package:abolashin/core/constans/app_colors.dart';
import 'package:abolashin/core/constans/constants.dart';
import 'package:abolashin/core/sharde/widget/navigation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/sharde/widget/default_button.dart';

import '../../../cart/screen/model/cart_item_model.dart'as cart;
import '../../model/order_summry_model.dart';
class OrderSummery extends StatelessWidget {
  final List listItemName;
  final OrderSummryModel orderSummryModel;
  final String id;
  const OrderSummery({
    super.key,
    required this.orderSummryModel,
    required this.listItemName, required this.id,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                20.verticalSpace,
                _buildRowLabel(context, 'invoice_number', id),
                _buildRowLabel(context, 'date', orderSummryModel.orderDate),
                10.verticalSpace,
                _buildRowLabel(context, 'payment_method', 'cash_on_delivery'.tr()),
                10.verticalSpace,
                _buildRowLabel(context, 'total_quantity', '${orderSummryModel.orderItems.length}'),
                _buildRowLabel(context, 'total', orderSummryModel.totalValue.toStringAsFixed(2)),
                10.verticalSpace,
                _buildRowLabel(context, 'discount', orderSummryModel.discount.toStringAsFixed(3)),
                _buildRowLabel(context, 'final_price', orderSummryModel.finalValue.toStringAsFixed(3)),
                20.verticalSpace,
                _buildItemsHeader(),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * .3,
                  child: ListView.builder(
                    itemCount: orderSummryModel.orderItems.length,
                    itemBuilder: (context, index) {
                      final item = orderSummryModel.orderItems[index];
                      final product = listItemName.firstWhere(
                            (element) => element.productId == item.itemId,
                        orElse: () => cart.CartItem.empty(item.itemId.toInt()),
                      );
                      return _buildItemRow(
                        name: currentLang == 'ar' ? product.nameAr : product.nameEn ,
                        quantity: item.quantity.toInt(),
                        price: item.price,
                      );
                    },
                  ),
                ),
                40.verticalSpace,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DefaultButton(
                    function: () {
                      BlocProvider.of<HomeCubit>(context).changeSelectIndexBottom(index: 0);
                      navigatofinsh(context, const HomeScreen(), false);
                    },
                    text: 'home_page'.tr(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.mainAppColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'order_success'.tr(),
          style: GoogleFonts.alexandria(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildRowLabel(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${label.tr()} : ',
                style: GoogleFonts.alexandria(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: value,
                style: GoogleFonts.alexandria(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w300,
                  color: AppColors.mainAppColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemsHeader() {
    return Container(
      color: AppColors.mainAppColor,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text('item_name'.tr(), style: _headerTextStyle()),
          ),
          Expanded(
            flex: 1,
            child: Text('quantity'.tr(), textAlign: TextAlign.center, style: _headerTextStyle()),
          ),
          Expanded(
            flex: 1,
            child: Text('unit_price'.tr(), textAlign: TextAlign.center, style: _headerTextStyle()),
          ),
          Expanded(
            flex: 1,
            child: Text('total'.tr(), textAlign: TextAlign.center, style: _headerTextStyle()),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow({required String name, required int quantity, required double price}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              name,
              maxLines: 2,
              style: _itemTextStyle(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: _itemTextStyle(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              price.toStringAsFixed(2),
              textAlign: TextAlign.center,
              style: _itemTextStyle(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              (price * quantity).toStringAsFixed(2),
              textAlign: TextAlign.center,
              style: _itemTextStyle(),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _headerTextStyle() => GoogleFonts.alexandria(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  TextStyle _itemTextStyle() => GoogleFonts.alexandria(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
}
