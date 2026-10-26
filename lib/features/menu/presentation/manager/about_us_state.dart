import 'package:abolashin/core/network/failure.dart';

abstract class AboutUsState {}

class InitializeAboutUs extends AboutUsState {}

class GetImageAboutUsLoading extends AboutUsState {}

class GetImageAboutUsSuccess extends AboutUsState {}

class GetImageAboutUsError extends AboutUsState {
  final Failure? failure;

  GetImageAboutUsError([this.failure]);
}
