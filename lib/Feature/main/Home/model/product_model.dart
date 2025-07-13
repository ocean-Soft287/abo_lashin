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
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productCode: json['ProductCode'] ?? '',
      productId: json["ProductID"],
      barCode: json['BarCode'] ?? '',
      colorArName: json['ColorArName'],
      colorEnName: json['ColorEnName'],
      sizeName: json['SizeName'],
      categoryId: json['CategoryId'],
      sizeEName: json['SizeEName'],
      productArName:
          '${json['ProductArName'] ?? ''}${(json['DefaultUnitArName'] ?? json['UnitArName'])?.toString().isNotEmpty == true ? ' (${json['DefaultUnitArName'] ?? json['UnitArName']})' : ''}',

      productEnName:
          '${json['ProductEnName'] ?? ''}${(json['DefaultUnitEnName'] ?? json['UnitEnName'])?.toString().isNotEmpty == true ? ' (${json['DefaultUnitEnName'] ?? json['UnitEnName']})' : ''}',

      unitArName: json['UnitArName'] ?? '',
      unitEnName: json['UnitEnName'] ?? '',
      defaultUnitArName: json['DefaultUnitArName'],
      defaultUnitEnName: json['DefaultUnitEnName'],
      unitValue: json['UnitValue'],

      categoryArName: json['CategoryArName'] ?? '',
      categoryEnName: json['CategoryEnName'] ?? '',
      productImage: json['ProductcImage'],
      isFavorite: json['IsFavorite'] == 1,
      stockQuantity: json['StockQuantity'] ?? 0.0,
      price: json['Price'] ?? 0.0,
      priceAfterDiscount: json['PriceAfterDiscount'] ?? 0.0,
      registrationDate: json['RegisterationDate'] ?? '',
      description1: json['Description1'],
      description2: json['Description2'],
      description3: json['Description3'],
      description4: json['Description4'],
      description5: json['Description5'],
      description6: json['Description6'],
      description7: json['Description7'],
      description8: json['Description8'],
      description9: json['Description9'],
      description10: json['Description10'],
      customerQuantity: json['BillCustomerQty'],
    );
  }
}
