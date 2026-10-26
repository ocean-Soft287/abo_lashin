import 'package:abolashin/features/cart/data/model/cart_item_model.dart';
import 'package:abolashin/features/products/data/model/product_details_model.dart';

abstract class ProductUnits {
  static bool supportsIndependentQuantities(List<UnitsModel> units) {
    if (units.length < 2) return false;
    final barcodes = units.map((u) => u.barcode.trim()).toList();
    if (barcodes.any((b) => b.isEmpty)) return false;
    return barcodes.toSet().length == barcodes.length;
  }

  static UnitsModel? baseUnit(List<UnitsModel> units) {
    for (final unit in units) {
      if (unit.unitValue == 1) return unit;
    }
    return null;
  }

  static String? contents(
    UnitsModel unit,
    List<UnitsModel> units, {
    required bool isArabic,
  }) {
    final base = baseUnit(units);
    final value = unit.unitValue;
    if (base == null || value == null || value <= 1 || identical(base, unit)) {
      return null;
    }
    final amount =
        value == value.roundToDouble()
            ? value.toInt().toString()
            : value.toString();
    final baseName = isArabic ? base.unitArName : base.unitEnName;
    if (baseName.trim().isEmpty) return null;
    return '$amount $baseName';
  }

  static int? discountPercent(UnitsModel unit) {
    if (unit.price <= 0 || unit.priceAfterDiscount >= unit.price) return null;
    final percent =
        ((unit.price - unit.priceAfterDiscount) / unit.price * 100).round();
    return percent > 0 ? percent : null;
  }

  static List<CartItem> cartLines(List<CartItem> cart, List<UnitsModel> units) {
    final barcodes =
        units.map((u) => u.barcode).where((b) => b.trim().isNotEmpty).toSet();
    return cart.where((item) => barcodes.contains(item.barcode)).toList();
  }

  static double linesTotal(List<CartItem> lines) => lines.fold<double>(
    0,
    (sum, line) => sum + line.quantity * line.priceAfterDiscount,
  );

  static CartItem cartItemFor({
    required UnitsModel unit,
    required int productId,
    required String productArName,
    required String productEnName,
    required String image,
  }) {
    return CartItem(
      productId: productId,
      nameAr: '$productArName * ${unit.unitArName}',
      nameEn: '$productEnName * ${unit.unitEnName}',
      barcode: unit.barcode,
      priceBeforeDiscount: unit.price,
      priceAfterDiscount: unit.priceAfterDiscount,
      image: image,
      stockQuantity: unit.stockQty,
      customerQuantity: unit.customerQuantity,
      quantity: unit.customerQuantity.toInt(),
    );
  }
}

String formatQuantity(num value) =>
    value == value.roundToDouble() ? value.toInt().toString() : '$value';
