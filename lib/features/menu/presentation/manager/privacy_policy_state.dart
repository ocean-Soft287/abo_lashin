import 'package:abolashin/core/network/failure.dart';

abstract class PrivacyPolicyState {}

class InitializePrivacyPolicy extends PrivacyPolicyState {}

class GetImagePrivacyPolicyLoading extends PrivacyPolicyState {}

class GetImagePrivacyPolicySuccess extends PrivacyPolicyState {}

class GetImagePrivacyPolicyError extends PrivacyPolicyState {
  final Failure? failure;

  GetImagePrivacyPolicyError([this.failure]);
}
