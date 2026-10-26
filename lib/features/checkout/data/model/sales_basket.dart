class SalesBasket {
  int? customerID;
  String? customerName;
  String? customerEName;
  int? productID;
  String? productCode;
  String? productName;
  String? productEnName;
  int? salesQuantity;
  String? barCode;
  String? customerPhone;
  String? specifications;
  int? discountPercent;
  String? productImage;
  double? stockQuantity;
  double? price;
  double? customerQuantity;
  double? totalQuantity;
  int? requiredQTY;
  int? giftQTY;
  int? yGiftQty;

  SalesBasket({
    this.customerID,
    this.customerName,
    this.customerEName,
    this.productID,
    this.productCode,
    this.productName,
    this.productEnName,
    this.salesQuantity,
    this.barCode,
    this.customerPhone,
    this.specifications,
    this.discountPercent,
    this.productImage,
    this.stockQuantity,
    this.price,
    this.customerQuantity,
    this.totalQuantity,
    this.requiredQTY,
    this.giftQTY,
    this.yGiftQty,
  });

  SalesBasket.fromJson(Map<String, dynamic> json) {
    customerID = (json['CustomerID'] as num?)?.toInt();
    customerName = json['CustomerName'];
    customerEName = json['CustomerEName'];
    productID = (json['ProductID'] as num?)?.toInt();
    productCode = json['ProductCode'];
    productName = json['ProductName'];
    productEnName = json['ProductEnName'];
    salesQuantity = (json['SalesQuantity'] as num?)?.toInt();
    barCode = json['BarCode'];
    customerPhone = json['CustomerPhone'];
    specifications = json['Specifications'];
    discountPercent = (json['DiscountPercent'] as num?)?.toInt();
    productImage = json['ProductImage'];
    stockQuantity = (json['StockQuantity'] as num?)?.toDouble();
    price = (json['Price'] as num?)?.toDouble();
    customerQuantity = (json['CustomerQuantity'] as num?)?.toDouble();
    totalQuantity = (json['TotalQuantity'] as num?)?.toDouble();
    requiredQTY = (json['RequiredQTY'] as num?)?.toInt();
    giftQTY = (json['GiftQTY'] as num?)?.toInt();
    yGiftQty = (json['Y_Gift_Qty'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CustomerID'] = customerID;
    data['CustomerName'] = customerName;
    data['CustomerEName'] = customerEName;
    data['ProductID'] = productID;
    data['ProductCode'] = productCode;
    data['ProductName'] = productName;
    data['ProductEnName'] = productEnName;
    data['SalesQuantity'] = salesQuantity;
    data['BarCode'] = barCode;
    data['CustomerPhone'] = customerPhone;
    data['Specifications'] = specifications;
    data['DiscountPercent'] = discountPercent;
    data['ProductImage'] = productImage;
    data['StockQuantity'] = stockQuantity;
    data['Price'] = price;
    data['CustomerQuantity'] = customerQuantity;
    data['TotalQuantity'] = totalQuantity;
    data['RequiredQTY'] = requiredQTY;
    data['GiftQTY'] = giftQTY;
    data['Y_Gift_Qty'] = yGiftQty;
    return data;
  }
}
