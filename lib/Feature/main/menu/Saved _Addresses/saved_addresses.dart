import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constans/app_colors.dart';
import '../../../../core/sharde/widget/navigation.dart';
import '../../Add Order/manager/add_order_cubit.dart';
import '../../Add Order/manager/add_order_state.dart';
import '../../Add_New_Address/screen/add_new_address.dart';
import '../../cart/screen/widget/address_item_component.dart';
class SavedAddressesScreen extends StatelessWidget {
  const SavedAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEFF2F7),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        toolbarHeight: 40.0,
        backgroundColor: Colors.white,

        centerTitle: true,
        title: AutoSizeText(
          'saved_addresses'.tr(),
          style: GoogleFonts.alexandria(
            color: AppColors.mainAppColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,

          ),
        ),
      ),
        body: Column(
          children: [
            BlocBuilder<AddOrderCubit, AddOrderState>(

              builder: (context, state) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      itemCount: BlocProvider.of<AddOrderCubit>(context).allAddressList.length,
                      itemBuilder: (context, index) {
                        return AddressItemComponent(
                          isSavedAddressPage: true,
                          index: index,
                          addOrderCubit: BlocProvider.of<AddOrderCubit>(context),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 15);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.mainAppColor,
        onPressed: () {
          navigato(context, AddNewAddress(isSavedAddressPage: false,));
    },
    icon: const Icon(Icons.add,color: Colors.white,),
    label: Text('add_new_address'.tr(), style: GoogleFonts.alexandria(
      color: Colors.white,
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,

    ),),
    ),


    );
  }
}
