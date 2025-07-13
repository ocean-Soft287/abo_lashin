import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constans/app_colors.dart';
import '../../../../../core/sharde/widget/navigation.dart';
import '../../../Add Order/manager/add_order_cubit.dart';
import '../../../Add Order/manager/add_order_state.dart';
import '../../../Add_New_Address/screen/add_new_address.dart';
import 'address_item_component.dart';
class CustomButtonSheet extends StatelessWidget {
  final AddOrderCubit addOrderCubit;
  const CustomButtonSheet({super.key,required this.addOrderCubit});

  @override
  Widget build(BuildContext context) {
    //addOrderCubit.getAllAddress();
    return BlocBuilder<AddOrderCubit,AddOrderState>(
      bloc: addOrderCubit,

      builder: (context,state)
      {

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'choose_address'.tr(),
                        style: GoogleFonts.alexandria(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          navigato(context, AddNewAddress());

                        },
                        child: Text(
                          'add_new_address'.tr(),
                          style: GoogleFonts.alexandria(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.mainAppColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close,
                        color: AppColors.mainAppColor),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(color: Colors.black, height: 2),
              const SizedBox(height: 20),
              Text(
                'existing_address'.tr(),
                style: GoogleFonts.alexandria(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                height: 200,
                child: ListView.separated(
                  itemCount:addOrderCubit.allAddressList.length,
                  itemBuilder: (context, index) {
                    return   AddressItemComponent(index: index,addOrderCubit: addOrderCubit,);
                  },
                  separatorBuilder: (context,index)
                  {
                    return const SizedBox(height: 15,);
                  },
                ),
              )

            ],
          ),
        );
      },

    );
  }
}