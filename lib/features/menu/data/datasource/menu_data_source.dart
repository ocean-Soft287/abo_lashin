import 'package:abolashin/core/network/data_source/encrypted_data_source.dart';
import 'package:abolashin/core/network/either.dart';
import 'package:abolashin/core/network/end_point.dart';
import 'package:abolashin/core/network/failure.dart';
import 'package:abolashin/features/menu/data/model/image_model.dart';

class MenuDataSource {
  final EncryptedDataSource _api;

  const MenuDataSource(this._api);

  Future<Either<Failure, List<ImageModel>>> getAboutUsImages() =>
      _api.getList(Endpoints.aboutUs, fromJson: ImageModel.fromJson);

  Future<Either<Failure, List<ImageModel>>> getPrivacyPolicyImages() =>
      _api.getList(Endpoints.privacy, fromJson: ImageModel.fromJson);
}
