import 'package:abolashin/Feature/main/menu/frequently_asked_questions/manager/faq_cubit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constans/app_colors.dart';
import '../../../../../core/constans/constants.dart';
import '../../../../../core/network/local/cachehelper.dart';

import '../manager/faq_state.dart';
class FAQPage extends StatelessWidget {
  const FAQPage({super.key});



@override
Widget build(BuildContext context) {
  currentLang = CacheHelper.getData(key: 'changeLang')??'ar';
  final currentLocale = context.locale;
  return Scaffold(
    backgroundColor: const Color(0xffF5F5F5),
    appBar: AppBar(
scrolledUnderElevation: 0.0,
      elevation: 0,
      toolbarHeight: 40.0,
      backgroundColor: Colors.white,

      centerTitle: true,
      title: AutoSizeText(
        'frequently_asked_questions'.tr(),

     style: GoogleFonts.alexandria(
          color: AppColors.mainAppColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,

        ),
      ),
    ),
    body: BlocProvider(
      create: (context) => FaqCubit()..loadFaqData(locale:currentLocale.languageCode),
      child: BlocBuilder<FaqCubit, FaqState>(
    builder: (context, state) {
      if (state is FaqLoaded) {
        return ListView.builder(
          itemCount: state.faqList.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: ExpansionTile(  shape: const RoundedRectangleBorder(
                side: BorderSide.none,
              ),

                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${index + 1}. '),
                    Expanded(
                      child: Text(
                        state.faqList[index].question,
                        style: GoogleFonts.alexandria(
                          color: AppColors.mainAppColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      state.faqList[index].answer,
                      style: GoogleFonts.alexandria(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
      return const SizedBox();
    },
    ),

    )

  );
}
}