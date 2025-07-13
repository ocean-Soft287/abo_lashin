import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/faq_model.dart';
import 'faq_state.dart';
List<FAQModel> faqList=[];
class FaqCubit extends Cubit<FaqState> {
  FaqCubit() : super(FaqInitial());

  void loadFaqData({required String locale}) async {
    emit(FaqLoading());
    try {
      String filePath = locale == 'ar' ? 'assets/lang/ar.json' : 'assets/lang/en.json';
      String jsonString = await rootBundle.loadString(filePath);
      Map<String, dynamic> jsonData = json.decode(jsonString);

      if (jsonData.containsKey('faq') && jsonData['faq'] is List) {
       faqList = List<FAQModel>.from(
          jsonData['faq'].map((item) => FAQModel.fromJson(item)),
        );

        emit(FaqLoaded(faqList));
      } else {
        emit(FaqError(" Error: 'faq' key is missing or not a list."));
      }
    } catch (e) {
      emit(FaqError(" Error loading FAQ data: ${e.toString()}"));
    }
  }
}