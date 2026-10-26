import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/features/search/presentation/manager/search_cubit.dart';
import 'package:abolashin/features/search/presentation/widgets/search_header.dart';
import 'package:abolashin/features/search/presentation/widgets/search_results_view.dart';

class SearchScreen extends StatelessWidget {
  final String? initialQuery;

  const SearchScreen({super.key, this.initialQuery});

  @override
  Widget build(BuildContext context) {
    // Scoped to the screen so results, the debounce timer and in-flight
    // requests end with it instead of reappearing on the next visit.
    return BlocProvider(
      create: (_) => SearchCubit(),
      child: _SearchView(initialQuery: initialQuery?.trim() ?? ''),
    );
  }
}

class _SearchView extends StatefulWidget {
  final String initialQuery;

  const _SearchView({required this.initialQuery});

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialQuery,
  );
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery.isNotEmpty) {
      context.read<SearchCubit>().searchKey(searchKey: widget.initialQuery);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();
    return Scaffold(
      backgroundColor: context.colors.scaffold,
      body: Column(
        children: [
          SearchHeader(
            controller: _controller,
            focusNode: _focusNode,
            autofocus: widget.initialQuery.isEmpty,
            onChanged: cubit.onQueryChanged,
            onSubmitted: cubit.submit,
          ),
          const Expanded(child: SearchResultsView()),
        ],
      ),
    );
  }
}
