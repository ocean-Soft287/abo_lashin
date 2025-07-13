import 'package:abolashin/Feature/main/menu/PreviousOrders/screen/widget/empty_order_widget.dart';
import 'package:abolashin/Feature/main/menu/PreviousOrders/screen/widget/order_tracking_card.dart';
import 'package:abolashin/Feature/main/menu/PreviousOrders/screen/widget/previous_order_item.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constans/app_colors.dart';
import '../../../../../core/constans/constants.dart';
import '../../../../../core/network/local/cachehelper.dart';
import '../manager/previous_order_cubit.dart';
import '../manager/previous_order_state.dart';
import '../model/previous_order_model.dart';


class PreviousOrders extends StatelessWidget {
  const PreviousOrders({super.key});

  @override
  Widget build(BuildContext context) {
    currentLang = CacheHelper.getData(key: 'changeLang') ?? 'ar';
    final currentLocale = context.locale;
    return DefaultTabController(
      length: 2,

      animationDuration: const Duration(milliseconds: 500),
      //animationDuration: ,//

      child: Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          elevation: 0,
          toolbarHeight: 40.0,

          backgroundColor: Colors.white,bottom: TabBar(
          labelColor: AppColors.mainAppColor,
          unselectedLabelColor: Colors.black.withOpacity(0.4),
          indicator: const BoxDecoration(

          ),
          labelStyle: GoogleFonts.alexandria(
          fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          tabs: [
            Tab(text: 'current_orders'.tr()),
            Tab(text: 'previous_orders'.tr()),
          ],
        ),
          centerTitle: true,
          title: AutoSizeText(
            'previous_orders'.tr(),
            style: GoogleFonts.alexandria(
              color: AppColors.mainAppColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        body:TabBarView(
          physics: const BouncingScrollPhysics(),
          children: [

            BlocProvider(
              create: (context) => PreviousOrderCubit()..startOrderTrackingRealtime(),
              child: BlocBuilder<PreviousOrderCubit, PreviousOrderState>(
                builder: (context, state) {
                  return StreamBuilder<List<PreviousOrdersModel>>(
                    stream: BlocProvider.of<PreviousOrderCubit>(context).orderTrackingDetailsStream,
                    builder: (context, snapshot) {

                      var orderTrackingDetails = snapshot.data ?? [];

                      return orderTrackingDetails.isEmpty
                          ? EmptyOrdersWidget(
                        actionText: 'no_tracking_orders'.tr(),
                        message: 'browse_and_order'.tr(),
                      )
                          : OrderTrackingCard(orderTrackingCubit: BlocProvider.of<PreviousOrderCubit>(context));
                    },
                  );
                },
              ),
            ),


            BlocProvider(
              create: (context) => PreviousOrderCubit()..getPreviousOrders(),
              child: BlocBuilder<PreviousOrderCubit, PreviousOrderState>(
              builder: (context, state) {
                return   StreamBuilder<List<PreviousOrdersModel>>(
        stream: BlocProvider.of<PreviousOrderCubit>(context).previousOrdersStream,
        builder: (context, snapshot) {


          var previousOrders = snapshot.data ?? [];

          return previousOrders.isEmpty
              ? EmptyOrdersWidget(
            actionText: 'shop_now'.tr(),
            message: 'no_previous_orders'.tr(),
          )
              : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: previousOrders.length,
              itemBuilder: (context, index) {
                return PreviousOrderItem(previousOrder: previousOrders[index]);
              },
            ),
          );
        },
                );
              }

              ),
            ),
          ],
        )

      ),
    );
  }
}














