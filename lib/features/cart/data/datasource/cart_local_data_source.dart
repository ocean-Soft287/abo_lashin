import 'package:abolashin/core/local/hive_service_impl.dart';
import 'package:abolashin/core/network/either.dart';
import 'package:abolashin/core/network/failure.dart';
import 'package:abolashin/features/cart/data/model/cart_item_model.dart';

const String cartBox = 'cartBox';
const String cartKey = 'cartItems';

class CartLocalDataSource {
  final IListCache _cache;

  const CartLocalDataSource(this._cache);

  Future<Either<Failure, List<CartItem>>> readItems() async {
    try {
      final stored = await _cache.readList(cartBox, cartKey);
      return Right([
        for (final e in stored ?? const [])
          if (e is Map) CartItem.fromJson(Map<String, dynamic>.from(e)),
      ]);
    } catch (error, stackTrace) {
      return Left(
        CacheFailure(message: error.toString(), stackTrace: stackTrace),
      );
    }
  }

  Future<Either<Failure, void>> saveItems(List<CartItem> items) async {
    try {
      await _cache.saveList(cartBox, cartKey, [
        for (final item in items) item.toJson(),
      ]);
      return const Right(null);
    } catch (error, stackTrace) {
      return Left(
        CacheFailure(message: error.toString(), stackTrace: stackTrace),
      );
    }
  }

  Future<Either<Failure, void>> clear() async {
    try {
      await _cache.deleteList(cartBox, cartKey);
      return const Right(null);
    } catch (error, stackTrace) {
      return Left(
        CacheFailure(message: error.toString(), stackTrace: stackTrace),
      );
    }
  }
}
