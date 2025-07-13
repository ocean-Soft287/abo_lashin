import '../model/faq_model.dart';

abstract class FaqState {}

class FaqInitial extends FaqState {}
class FaqLoading extends FaqState {}
class FaqLoaded extends FaqState {
  final List<FAQModel> faqList;
  FaqLoaded(this.faqList);
}
class FaqError extends FaqState {
  final String message;
  FaqError(this.message);
}