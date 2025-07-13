class PreviousOrderDetailsModel {
  final int orderNo;
  final int number;
  final int productID;
  final String productArName;
  final String productEnName;
  final int quantity;
  final double price;
  final int unitId;
  final String unitArName;
  final String unitEnName;
  final int colorsId;
  final int? colorID;
  final String? colorName;
  final String? colorEName;
  final int sizeId;
  final String? size;
  final String productImage;
  final double stockQuantity;
  final String barcode;
  final String productCode;
  final double customerQuantity;
  final double totalQuantity;
  final double priceAfterDiscount;
  final int discountPercent;
  final int requiredQTY;
  final int giftQTY;
  final int yGiftQty;

  PreviousOrderDetailsModel({
    required this.orderNo,
    required this.number,
    required this.productID,
    required this.productArName,
    required this.productEnName,
    required this.quantity,
    required this.price,
    required this.unitId,
    required this.unitArName,
    required this.unitEnName,
    required this.colorsId,
    this.colorID,
    this.colorName,
    this.colorEName,
    required this.sizeId,
    this.size,
    required this.productImage,
    required this.stockQuantity,
    required this.barcode,
    required this.productCode,
    required this.customerQuantity,
    required this.totalQuantity,
    required this.priceAfterDiscount,
    required this.discountPercent,
    required this.requiredQTY,
    required this.giftQTY,
    required this.yGiftQty,
  });

  factory PreviousOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return PreviousOrderDetailsModel(
      orderNo: json['OrderNo'],
      number: json['Number'],
      productID: json['ProductID'],
      productArName: json['ProductArName'],
      productEnName: json['ProductEnName'],
      quantity: json['Quantity'],
      price: json['Price'].toDouble(),
      unitId: json['UnitId'],
      unitArName: json['UnitArName'],
      unitEnName: json['UnitEnName'],
      colorsId: json['Colors_ID'],
      colorID: json['ColorID'],
      colorName: json['ColorName'],
      colorEName: json['ColorEName'],
      sizeId: json['Size_ID'],
      size: json['Size'],
      productImage: json['ProductcImage'],
      stockQuantity: json['StockQuantity'].toDouble(),
      barcode: json['Barcode'],
      productCode: json['ProductCode'],
      customerQuantity: json['CustomerQuantity'].toDouble(),
      totalQuantity: json['TotalQuantity'].toDouble(),
      priceAfterDiscount: json['PriceAfterDiscount'].toDouble(),
      discountPercent: json['DiscountPercent'],
      requiredQTY: json['RequiredQTY'],
      giftQTY: json['GiftQTY'],
      yGiftQty: json['Y_Gift_Qty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'OrderNo': orderNo,
      'Number': number,
      'ProductID': productID,
      'ProductArName': productArName,
      'ProductEnName': productEnName,
      'Quantity': quantity,
      'Price': price,
      'UnitId': unitId,
      'UnitArName': unitArName,
      'UnitEnName': unitEnName,
      'Colors_ID': colorsId,
      'ColorID': colorID,
      'ColorName': colorName,
      'ColorEName': colorEName,
      'Size_ID': sizeId,
      'Size': size,
      'ProductcImage': productImage,
      'StockQuantity': stockQuantity,
      'Barcode': barcode,
      'ProductCode': productCode,
      'CustomerQuantity': customerQuantity,
      'TotalQuantity': totalQuantity,
      'PriceAfterDiscount': priceAfterDiscount,
      'DiscountPercent': discountPercent,
      'RequiredQTY': requiredQTY,
      'GiftQTY': giftQTY,
      'Y_Gift_Qty': yGiftQty,
    };
  }
}
