import 'package:equatable/equatable.dart';

import '../network/failure.dart';

enum Status { initial, loading, success, failure, isLoadingMore, custom }

extension BaseStateX<T> on BaseState<T> {
  bool get isInitial => status == Status.initial;

  bool get isLoading => status == Status.loading;

  bool get isSuccess => status == Status.success;

  bool get isFailure => status == Status.failure;

  bool get isCustom => status == Status.custom;

  bool get isLoadingMore => status == Status.isLoadingMore;

  bool get isEmpty => isSuccess && items.isEmpty;

  bool get hasData => data != null;
}

class BaseState<T> extends Equatable {
  final Status status;
  final String? errorMessage;
  final Failure? failure;
  final T? data;
  final List<T> items;
  final DateTime? lastUpdated;
  final Map<String, dynamic> metadata;
  final List<Map<String, dynamic>> secondaryMetadata;
  final bool hasMoreData;
  final String? imagePath;

  final String? action;

  const BaseState({
    this.status = Status.initial,
    this.errorMessage,
    this.data,
    this.lastUpdated,
    this.items = const [],
    this.failure,
    this.metadata = const {},
    this.secondaryMetadata = const [],
    this.hasMoreData = true,
    this.imagePath,
    this.action,
  });

  BaseState<T> copyWith({
    Status? status,
    String? errorMessage,
    T? data,
    DateTime? lastUpdated,
    List<Map<String, dynamic>>? secondaryMetadata,
    List<T>? items,
    Failure? failure,
    Map<String, dynamic>? metadata,
    bool? hasMoreData,
    String? imagePath,
    String? action,
  }) {
    return BaseState<T>(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
      items: items ?? this.items,
      secondaryMetadata: secondaryMetadata ?? this.secondaryMetadata,
      metadata: metadata ?? this.metadata,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      failure: failure ?? this.failure,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      imagePath: imagePath ?? this.imagePath,
      action: action ?? this.action,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    data,
    items,
    metadata,
    secondaryMetadata,
    lastUpdated,
    failure,
    hasMoreData,
    imagePath,
    action,
  ];
}
