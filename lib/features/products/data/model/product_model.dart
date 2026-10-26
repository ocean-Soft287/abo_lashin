class ProductModel {
  final String productCode;
  final String barCode;
  final String? colorArName;
  final String? colorEnName;
  final String? sizeName;
  final String? sizeEName;
  final String productArName;
  final String productEnName;
  final String categoryArName;
  final String categoryEnName;
  final String? productImage;
  final bool isFavorite;
  final double price;
  final num stockQuantity;
  final num customerQuantity;
  String? categoryId;
  final double priceAfterDiscount;
  final String registrationDate;
  final int productId;
  String? description1;
  String? description2;
  String? description3;
  String? description4;
  String? description5;
  String? description6;
  String? description7;
  String? description8;
  String? description9;
  String? description10;
  String? defaultUnitArName;
  String? defaultUnitEnName;
  num? unitValue;
  String? unitArName;
  String? unitEnName;
  String? orderUnitArName;
  String? orderUnitEnName;

  ProductModel({
    required this.customerQuantity,
    required this.productCode,
    required this.barCode,
    this.colorArName,
    this.colorEnName,
    this.sizeName,
    this.sizeEName,
    required this.productId,
    required this.productArName,
    required this.productEnName,
    required this.categoryArName,
    required this.categoryEnName,
    this.productImage,
    required this.isFavorite,
    required this.price,
    required this.priceAfterDiscount,
    required this.registrationDate,
    required this.stockQuantity,
    this.description1,
    this.description2,
    this.description3,
    this.description4,
    this.description5,
    this.description6,
    this.description7,
    this.description8,
    this.description9,
    this.description10,
    this.categoryId,
    this.defaultUnitEnName,
    this.defaultUnitArName,
    this.unitValue,
    this.unitEnName,
    this.unitArName,
    this.orderUnitArName,
    this.orderUnitEnName,
  });

  static num _toNum(dynamic value, {num fallback = 0}) {
    if (value == null) return fallback;
    if (value is num) return value;
    if (value is String) {
      return num.tryParse(value.trim()) ?? fallback;
    }
    return fallback;
  }

  static int _toInt(dynamic value, {int? fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      return int.tryParse(value.trim()) ??
          num.tryParse(value.trim())?.toInt() ??
          fallback ??
          0;
    }
    return fallback ?? 0;
  }

  static String? _toNullableString(dynamic value) {
    if (value == null) return null;
    final result = value.toString().trim();
    return result.isEmpty ? null : result;
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final defaultUnitArName = _toNullableString(json['DefaultUnitArName']);
    final unitArName = _toNullableString(json['UnitArName']);
    final defaultUnitEnName = _toNullableString(json['DefaultUnitEnName']);
    final unitEnName = _toNullableString(json['UnitEnName']);

    // Some endpoints return ProductArName, while others return ProductName.
    final productArName =
        _toNullableString(json['ProductArName']) ??
        _toNullableString(json['ProductName']) ??
        '';

    final productEnName = _toNullableString(json['ProductEnName']) ?? '';

    final effectiveArUnit = defaultUnitArName ?? unitArName;
    final effectiveEnUnit = defaultUnitEnName ?? unitEnName;

    return ProductModel(
      productCode: _toNullableString(json['ProductCode']) ?? '',
      productId: _toInt(json['ProductID']),
      barCode: _toNullableString(json['BarCode']) ?? '',
      colorArName: _toNullableString(json['ColorArName']),
      colorEnName: _toNullableString(json['ColorEnName']),
      sizeName: _toNullableString(json['SizeName']),
      sizeEName: _toNullableString(json['SizeEName']),
      categoryId: _toNullableString(json['CategoryId']),

      productArName:
          effectiveArUnit == null
              ? productArName
              : '$productArName ($effectiveArUnit)',

      productEnName:
          effectiveEnUnit == null
              ? productEnName
              : '$productEnName ($effectiveEnUnit)',

      unitArName: unitArName,
      unitEnName: unitEnName,
      orderUnitArName: _toNullableString(json['OrderUnitName']),
      orderUnitEnName: _toNullableString(json['OrderUnitEName']),
      defaultUnitArName: defaultUnitArName,
      defaultUnitEnName: defaultUnitEnName,
      unitValue: json['UnitValue'] == null ? null : _toNum(json['UnitValue']),

      categoryArName: _toNullableString(json['CategoryArName']) ?? '',
      categoryEnName: _toNullableString(json['CategoryEnName']) ?? '',
      productImage: _toNullableString(json['ProductcImage']),
      isFavorite: _toInt(json['IsFavorite']) == 1,

      stockQuantity: _toNum(json['StockQuantity']),
      price: _toNum(json['Price']).toDouble(),
      priceAfterDiscount:
          _toNum(
            json['PriceAfterDiscount'],
            fallback: _toNum(json['Price']),
          ).toDouble(),

      registrationDate: _toNullableString(json['RegisterationDate']) ?? '',

      description1: _toNullableString(json['Description1']),
      description2: _toNullableString(json['Description2']),
      description3: _toNullableString(json['Description3']),
      description4: _toNullableString(json['Description4']),
      description5: _toNullableString(json['Description5']),
      description6: _toNullableString(json['Description6']),
      description7: _toNullableString(json['Description7']),
      description8: _toNullableString(json['Description8']),
      description9: _toNullableString(json['Description9']),
      description10: _toNullableString(json['Description10']),

      customerQuantity: _toNum(
        json['CustomerQuantity'] ?? json['BillCustomerQty'],
      ),
    );
  }
}
