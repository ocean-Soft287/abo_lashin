import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:abolashin/core/servise_locator/services_locator.dart';
import 'package:abolashin/features/menu/data/datasource/menu_data_source.dart';
import 'package:abolashin/features/menu/data/model/image_model.dart';
import 'package:abolashin/features/menu/presentation/manager/about_us_state.dart';

class AboutUsCubit extends Cubit<AboutUsState> {
  AboutUsCubit({MenuDataSource? dataSource})
    : _dataSource = dataSource ?? getIt<MenuDataSource>(),
      super(InitializeAboutUs());

  final MenuDataSource _dataSource;

  List<ImageModel> aboutUsList = [];

  Future<void> getImageAboutUs() async {
    emit(GetImageAboutUsLoading());
    final result = await _dataSource.getAboutUsImages();
    if (isClosed) return;
    result.fold((failure) => emit(GetImageAboutUsError(failure)), (images) {
      aboutUsList = images;
      emit(GetImageAboutUsSuccess());
    });
  }
}
