class FavoriteModel {
  num? iD;
  int? productID;
  dynamic customerPhone;
  num? customerID;
  String? productCode;
  String? productName;
  String? productEnName;
  dynamic specifications;
  num? discountPercent;
  String? productImage;
  int? categoryId; // تعديل هنا إلى int؟
  num? stockQuantity;
  num? price;
  num? priceAfterDiscount;
  num? customerQuantity;
  num? totalQuantity;
  String? barCode;
  num? requiredQTY;
  num? giftQTY;
  num? yGiftQty;

  FavoriteModel({
    this.iD,
    this.productID,
    this.customerPhone,
    this.customerID,
    this.productCode,
    this.productName,
    this.productEnName,
    this.specifications,
    this.discountPercent,
    this.productImage,
    this.categoryId, // تعديل هنا إلى int؟
    this.stockQuantity,
    this.price,
    this.priceAfterDiscount,
    this.customerQuantity,
    this.totalQuantity,
    this.barCode,
    this.requiredQTY,
    this.giftQTY,
    this.yGiftQty,
  });

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    productID = json['ProductID'];
    customerPhone = json['CustomerPhone'];
    customerID = json['CustomerID'];
    productCode = json['ProductCode'];
    productName = json['ProductName'];
    categoryId = json['CategoryId'] is String ? int.tryParse(json['CategoryId']) : json['CategoryId']; // تحويل هنا إذا كان النوع String
    productEnName = json['ProductEnName'];
    specifications = json['Specifications'];
    discountPercent = json['DiscountPercent'];
    productImage = json['ProductImage'];
    stockQuantity = json['StockQuantity'];
    price = json['Price'];
    priceAfterDiscount = json['PriceAfterDiscount'];
    customerQuantity = json['CustomerQuantity'];
    totalQuantity = json['TotalQuantity'];
    barCode = json['BarCode'];
    requiredQTY = json['RequiredQTY'];
    giftQTY = json['GiftQTY'];
    yGiftQty = json['Y_Gift_Qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['ProductID'] = productID;
    data['CustomerPhone'] = customerPhone;
    data['CustomerID'] = customerID;
    data['ProductCode'] = productCode;
    data['ProductName'] = productName;
    data['ProductEnName'] = productEnName;
    data['Specifications'] = specifications;
    data['DiscountPercent'] = discountPercent;
    data['ProductImage'] = productImage;
    data['CategoryId'] = categoryId;
    data['StockQuantity'] = stockQuantity;
    data['Price'] = price;
    data['PriceAfterDiscount'] = priceAfterDiscount;
    data['CustomerQuantity'] = customerQuantity;
    data['TotalQuantity'] = totalQuantity;
    data['BarCode'] = barCode;
    data['RequiredQTY'] = requiredQTY;
    data['GiftQTY'] = giftQTY;
    data['Y_Gift_Qty'] = yGiftQty;
    return data;
  }
}
