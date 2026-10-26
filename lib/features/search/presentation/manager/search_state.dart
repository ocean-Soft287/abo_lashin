import 'package:abolashin/core/network/failure.dart';

abstract class SearchState {}

class InitializeSearch extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {}

class SearchError extends SearchState {
  final Failure? failure;

  SearchError([this.failure]);
}
