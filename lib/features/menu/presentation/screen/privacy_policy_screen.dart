import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/features/menu/presentation/screen/about_us_screen.dart';
import 'package:abolashin/features/menu/presentation/manager/privacy_policy_cubit.dart';
import 'package:abolashin/features/menu/presentation/manager/privacy_policy_state.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(title: 'policy_privacy'.tr()),
      body: BlocProvider(
        create: (context) => PrivacyPolicyCubit()..getImagePrivacyPolicy(),
        child: BlocBuilder<PrivacyPolicyCubit, PrivacyPolicyState>(
          builder: (context, state) {
            final cubit = BlocProvider.of<PrivacyPolicyCubit>(context);
            return InfoImagePages(
              imageUrls: [for (final e in cubit.privacyPolicyList) e.imagePath],
              loading:
                  state is GetImagePrivacyPolicyLoading ||
                  state is InitializePrivacyPolicy,
              failed: state is GetImagePrivacyPolicyError,
              failure:
                  state is GetImagePrivacyPolicyError ? state.failure : null,
              onRetry: cubit.getImagePrivacyPolicy,
            );
          },
        ),
      ),
    );
  }
}
