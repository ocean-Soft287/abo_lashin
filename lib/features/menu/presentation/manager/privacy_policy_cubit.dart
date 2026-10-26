import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:abolashin/core/servise_locator/services_locator.dart';
import 'package:abolashin/features/menu/data/datasource/menu_data_source.dart';
import 'package:abolashin/features/menu/data/model/image_model.dart';
import 'package:abolashin/features/menu/presentation/manager/privacy_policy_state.dart';

class PrivacyPolicyCubit extends Cubit<PrivacyPolicyState> {
  PrivacyPolicyCubit({MenuDataSource? dataSource})
    : _dataSource = dataSource ?? getIt<MenuDataSource>(),
      super(InitializePrivacyPolicy());

  final MenuDataSource _dataSource;

  List<ImageModel> privacyPolicyList = [];

  Future<void> getImagePrivacyPolicy() async {
    emit(GetImagePrivacyPolicyLoading());
    final result = await _dataSource.getPrivacyPolicyImages();
    if (isClosed) return;
    result.fold((failure) => emit(GetImagePrivacyPolicyError(failure)), (
      images,
    ) {
      privacyPolicyList = images;
      emit(GetImagePrivacyPolicySuccess());
    });
  }
}
