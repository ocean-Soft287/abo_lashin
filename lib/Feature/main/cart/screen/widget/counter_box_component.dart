import 'package:abolashin/Feature/main/cart/screen/manager/cart_cubit.dart';
import 'package:abolashin/Feature/main/cart/screen/manager/chat_state.dart';
import 'package:abolashin/Feature/main/cart/screen/model/cart_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constans/app_colors.dart';

class CounterBox extends StatelessWidget {
  final int productId;
  final String nameAr;
  final String nameEn;
  final double priceBeforeDiscount;
  final double priceAfterDiscount;
  final String image;
  final num customerQuantity;
  final num stockQuantity;
  final String barcode;
  final num customerquntatiy;

  const CounterBox({
    super.key,
    required this.productId,
    required this.nameAr,
    required this.nameEn,
    required this.priceBeforeDiscount,
    required this.priceAfterDiscount,
    required this.image,
    required this.customerQuantity,
    required this.stockQuantity,
    required this.barcode,
    required this.customerquntatiy,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final cartCubit = context.read<CartCubit>();
        final itemCount = cartCubit.getItemCount(
          productId: productId,
          nameAr: nameAr,
          nameEn: nameEn,
          customerQuantity: customerQuantity,
          stockQuantity: stockQuantity,
          barcode: barcode,
          image: image,
          price: priceBeforeDiscount,
          priceAfterDiscount: priceAfterDiscount,
        );

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IntrinsicWidth(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 30.h,
                padding: EdgeInsets.symmetric(
                  horizontal: itemCount > 0 ? 6.w : 0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade300, blurRadius: 5),
                  ],
                ),
                margin: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (itemCount > 0)
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.remove,
                          color: AppColors.mainAppColor,
                          size: 15.sp,
                        ),
                        onPressed: () => cartCubit.removeItem(barcode),
                      ),
                    if (itemCount > 0)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Text('$itemCount'),
                      ),
                    if (
                    (stockQuantity > 0 && customerQuantity <= 0 && itemCount < stockQuantity) || // الحالة الافتراضية (مفيش customerQuantity)
                        (customerQuantity > 0 && itemCount < customerQuantity) || // فيه customer limit، امشي عليه
                        (stockQuantity <= 0 && customerQuantity > 0 && itemCount < customerQuantity) // ❗ الحالة الجديدة المضافة
                        ||
                        (stockQuantity<=0&&itemCount<customerQuantity)||
                        (customerQuantity==0)
                    )

                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.add,
                          color: AppColors.mainAppColor,
                          size: 15.sp,
                        ),
                        onPressed: () {
                          cartCubit.addItem(
                            CartItem(
                              productId: productId,
                              nameAr: nameAr,
                              nameEn: nameEn,
                              barcode: barcode,
                              priceBeforeDiscount: priceBeforeDiscount,
                              priceAfterDiscount: priceAfterDiscount,
                              image: image,
                              stockQuantity: stockQuantity,
                              customerQuantity: customerQuantity,
                              quantity: customerquntatiy.toInt(),



                            ),
                          );
print(stockQuantity);
print(customerQuantity);
                          // print(customerquntatiy);
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
