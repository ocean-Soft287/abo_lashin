import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constans/app_colors.dart';
import '../manager/privacy_policy_cubit.dart';
import '../manager/privacy_policy_state.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          'policy_privacy'.tr(),
          style: GoogleFonts.alexandria(
            color: AppColors.mainAppColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,

          ),
        ),
      ),
      body: 
      BlocProvider(
        create: (context)=>PrivacyPolicyCubit()..getImagePrivacyPolicy(),

        child: BlocBuilder<PrivacyPolicyCubit,PrivacyPolicyState>(
          builder: (context,state)
          {
            PrivacyPolicyCubit aboutUsCubit =BlocProvider.of<PrivacyPolicyCubit>(context);
            return  ConditionalBuilder(
              builder: (context) {
                return ListView.builder(
                  itemCount: aboutUsCubit.privacyPolicyList.length,
                  itemBuilder: (context, index) {
                    return
                      CachedNetworkImage(
                        imageUrl: aboutUsCubit.privacyPolicyList[index].imagePath,
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
              condition: (state is !GetImagePrivacyPolicyLoading||state is !GetImagePrivacyPolicyError||aboutUsCubit.privacyPolicyList.isNotEmpty),

            );
          },

        ),
      ),
    );
  }
}
