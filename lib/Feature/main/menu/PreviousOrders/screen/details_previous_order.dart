import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
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



class DetailsPreviousOrder extends StatelessWidget {

  PreviousOrdersModel? perviousOrderModel;
  DetailsPreviousOrder({super.key, required this.perviousOrderModel, });

  @override
  Widget build(BuildContext context) {
    currentLang = CacheHelper.getData(key: 'changeLang') ?? 'ar';
    final currentLocale = context.locale;




    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        scrolledUnderElevation: 0,

        toolbarHeight: 40.0,
        backgroundColor: Colors.white,
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
      body: BlocProvider(
        create: (context)=>PreviousOrderCubit()..getPreviousOrderDetails(orderId: perviousOrderModel!.orderNo),
        child: BlocBuilder<PreviousOrderCubit,PreviousOrderState>(

          builder: (context,state)
          {
            return Column(
              children: [


                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'order_number'.tr(),
                                  style: GoogleFonts.alexandria(
                                    fontSize: 13.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,

                                  ),
                                ),
                                const WidgetSpan(child: SizedBox(width: 4)),
                                TextSpan(
                                  text: '${perviousOrderModel?.orderNo??0}',
                                  style: GoogleFonts.alexandria(
                                    fontSize: 14.sp,
                                    color: AppColors.mainAppColor,
                                    fontWeight: FontWeight.w400,

                                  ),
                                ),
                              ],
                            ),
                          ),

                          Text(
                            (perviousOrderModel?.underDeliver??false)?
                            'received'.tr():'not_delivered'.tr(),
                            style: GoogleFonts.alexandria(
                              color: const Color(0xff52A756),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,

                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      _buildRichText('order_date'.tr(), DateFormat('dd/MM/yyyy','en').format(perviousOrderModel!.orderDate),),
                      const SizedBox(height: 4),
                      _buildRichText('delivery_address'.tr(), perviousOrderModel?.orderAddress??''),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xff979797)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'products'.tr(),
                    style: GoogleFonts.alexandria(
                      color: const Color(0xff52A756),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,

                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ListView.separated(
                      itemCount:BlocProvider.of<PreviousOrderCubit>(context).previousOrderDetailsList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            // Handle item tap here
                          },
                          child: Container(
                            height: 100.h,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    width: 90.w,
                                    height: 90.h,
                                    imageUrl: BlocProvider.of<PreviousOrderCubit>(context).previousOrderDetailsList[index].productImage,
                                    placeholder: (context, url) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value: 1.0,
                                          color: AppColors.mainAppColor,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                    fadeInDuration: const Duration(seconds: 1),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                    (currentLocale.languageCode == 'ar')?
                                          BlocProvider.of<PreviousOrderCubit>(context).previousOrderDetailsList[index].productArName
                                          :
                                    BlocProvider.of<PreviousOrderCubit>(context).previousOrderDetailsList[index].productEnName
                                          ,
                                          style: GoogleFonts.alexandria(
                                            color: AppColors.mainAppColor,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,

                                          ),
                                        ),
                                      const SizedBox(height: 5,),
                                        Text(
                                          '${'quantity'.tr()}: ${BlocProvider.of<PreviousOrderCubit>(context).previousOrderDetailsList[index].quantity ?? 0}', // استبدل 22 بالمتغير الفعلي للكمية
                                          style: GoogleFonts.alexandria(
                                            color: Colors.red,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),

                                        const SizedBox(height: 5,),
                                        _buildRichText('${BlocProvider.of<PreviousOrderCubit>(context).previousOrderDetailsList[index].price}', 'currency'.tr()),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                    ),
                  ),
                ),
              ],
            );
          },

        ),
      ),
    );
  }

  Widget _buildRichText(String label, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: GoogleFonts.alexandria(
              fontSize: 13.sp,
              color: Colors.red,
              fontWeight: FontWeight.w400,

            ),
          ),
          const WidgetSpan(child: SizedBox(width: 8)),
          TextSpan(
            text: value,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.mainAppColor,
              fontWeight: FontWeight.w400,
              fontFamily: 'Madani',
            ),
          ),
        ],
      ),
    );
  }
}

