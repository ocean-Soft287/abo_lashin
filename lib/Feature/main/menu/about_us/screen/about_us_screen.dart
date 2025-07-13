import 'package:abolashin/Feature/main/menu/about_us/manager/about_us_state.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constans/app_colors.dart';
import '../manager/about_us_cubit.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

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
          'about_us'.tr(),
          style: GoogleFonts.alexandria(
            color: AppColors.mainAppColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,

          ),
        ),
      ),
      body: 
      BlocProvider(
        create: (context)=>AboutUsCubit()..getImageAboutUs(),

        child: BlocBuilder<AboutUsCubit,AboutUsState>(
          builder: (context,state)
          {
            AboutUsCubit aboutUsCubit =BlocProvider.of<AboutUsCubit>(context);
            return  ConditionalBuilder(
              builder: (context) {
                return ListView.builder(
                  itemCount: aboutUsCubit.aboutUsList.length,
                  itemBuilder: (context, index) {
                    return
                      CachedNetworkImage(
                        imageUrl: aboutUsCubit.aboutUsList[index].imagePath??'',
                        placeholder: (context, url) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              value: 1.0,
                              color: AppColors.mainAppColor,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),

                      );


                  },
                );
              },
              fallback: (context) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return const Center(child: CircularProgressIndicator());
                  },
                );
              },
              condition: (state is !GetImageAboutUsLoading||state is !GetImageAboutUsError||aboutUsCubit.aboutUsList.isNotEmpty),

            );
          },

        ),
      ),
    );
  }
}
