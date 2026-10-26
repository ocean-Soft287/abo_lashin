import 'package:equatable/equatable.dart';

class PaginationParams extends Equatable {
  final int page;
  final int pageSize;
  final String? search;
  final Map<String, dynamic>? extra;

  const PaginationParams({
    required this.page,
    this.pageSize = 15,
    this.search,
    this.extra,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{'page': page, 'pageSize': pageSize};

    if (search != null && search!.isNotEmpty) {
      data['search'] = search;
    }

    if (extra != null) {
      data.addAll(extra!);
    }

    return data;
  }

  @override
  List<Object?> get props => [page, pageSize, search, extra];
}
