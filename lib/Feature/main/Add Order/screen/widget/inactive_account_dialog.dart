import 'package:abolashin/core/constans/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/constans/app_colors.dart';
import '../../../../../core/sharde/widget/default_button.dart';

class InactiveAccountDialog extends StatelessWidget {

  final String ownerPhoneNumber = "201289064242";



   const InactiveAccountDialog({super.key});

  void _makePhoneCall({required String phone}) async {
    final Uri phoneUri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color:  AppColors.mainAppColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.account_circle_outlined,
                  color: AppColors.mainAppColor,
                  size: 60,
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'account_inactive'.tr(),
                style: GoogleFonts.alexandria(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color:  AppColors.mainAppColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),

              Text(
                'cannot_place_order_contact_service'.tr(),
                 style: GoogleFonts.alexandria(
                  fontSize: 13.sp,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25,),
              Row(
                children: [

                  Expanded(
                    child: DefaultButton(
                      text: 'call'.tr(),
                      function:(){
                        _makePhoneCall(phone: ownerPhoneNumber);
    },
                      backgroundColor: AppColors.mainAppColor,
                      textColor: Colors.white,
                      hasIcon: true,
                      icon: const Icon(
                        Icons.call,
                        color: Colors.white,
                        size: 20,
                      ),
                      borderRadius: 4,
                    ),
                  ),

                  const SizedBox(width: 10),



                  Expanded(
                    child: DefaultButton(
                      text: 'whatsapp'.tr(),
                      function: () => openWhatsApp(phoneNumber: ownerPhoneNumber,message: 'يرجى تفعيل الحساب الخاص بى  رقم $customerPhone '),
                      backgroundColor: const Color(0xFF25D366),
                      textColor: Colors.white,
                      hasIcon: true,
                      icon: const Icon(
                        Icons.chat_bubble,
                        color: Colors.white,
                        size: 20,
                      ),
                      borderRadius: 4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.secondAppColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: AppColors.secondAppColor,
                  size: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


void showInactiveAccountDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const InactiveAccountDialog();
    },
  );
}









void openWhatsApp({required String phoneNumber, required String message}) async {
  final Uri whatsappUri = Uri.parse(
    'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}',
  );

  if (await canLaunchUrl(whatsappUri)) {
    await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $whatsappUri';
  }
}