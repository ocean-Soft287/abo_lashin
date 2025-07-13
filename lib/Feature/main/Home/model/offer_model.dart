class OfferModel {
  int offersNo;
  String offerName;
  bool showOffer;
  List<OfferItem> offerItems;

  OfferModel({
    required this.offersNo,
    required this.offerName,
    required this.showOffer,
    required this.offerItems,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      offersNo: json['OffersNo'],
      offerName: json['OfferName'],
      showOffer: json['ShowOffer'],
      offerItems: (json['OfferItems'] as List)
          .map((item) => OfferItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'OffersNo': offersNo,
      'OfferName': offerName,
      'ShowOffer': showOffer,
      'OfferItems': offerItems.map((item) => item.toJson()).toList(),
    };
  }
}

class OfferItem {
  int offersNo;
  int productId;
  String? productCode;
  String? productArName;
  String? productEnName;
  double price;
  String? barCode;
  double priceAfterDiscount;
  double stockQuantity;
  String? productImage;
  int discountPercent;
  bool isFavorite; // نوع الحقل سيبقى bool
  double customerQuantity;
  double totalQuantity;
  int requiredQTY;
  int giftQTY;
  int yGiftQty;
  String? categoryId;

  OfferItem({
    required this.offersNo,
    required this.productId,
    this.productCode,
    this.productArName,
    this.productEnName,
    required this.price,
    this.barCode,
    required this.priceAfterDiscount,
    required this.stockQuantity,
    this.productImage,
    required this.discountPercent,
    required this.isFavorite,
    required this.customerQuantity,
    required this.totalQuantity,
    required this.requiredQTY,
    required this.giftQTY,
    required this.yGiftQty,
    this.categoryId

  });

  factory OfferItem.fromJson(Map<String, dynamic> json) {
    return OfferItem(
      offersNo: json['OffersNo'] ?? 0,
      productId: json['ProductID'] ?? 0,
      productCode: json['ProductCode'] as String?,
      productArName: json['ProductName'] as String?,
      productEnName: json['ProductEnName'] as String?,
      price: (json['Price'] ?? 0.0).toDouble(),
      barCode: json['BarCode'] as String?,
      priceAfterDiscount: (json['PriceAfterDiscount'] ?? 0.0).toDouble(),
      stockQuantity: (json['StockQuantity'] ?? 0.0).toDouble(),
      productImage: json['ProductcImage'] as String?,
      discountPercent: json['DiscountPercent'] ?? 0,
      isFavorite: (json['IsFavorite'] == 1), // تحويل العدد إلى bool
      customerQuantity: (json['CustomerQuantity'] ?? 0.0).toDouble(),
      totalQuantity: (json['TotalQuantity'] ?? 0.0).toDouble(),
      requiredQTY: json['RequiredQTY'] ?? 0,
      giftQTY: json['GiftQTY'] ?? 0,
      yGiftQty: json['Y_Gift_Qty'] ?? 0,
      categoryId:json['CategoryId'] ,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'OffersNo': offersNo,
      'ProductID': productId,
      'ProductCode': productCode,
      'ProductName': productArName,
      'ProductEnName': productEnName,
      'Price': price,
      'BarCode': barCode,
      'PriceAfterDiscount': priceAfterDiscount,
      'StockQuantity': stockQuantity,
      'ProductcImage': productImage,
      'DiscountPercent': discountPercent,
      'IsFavorite': isFavorite ? 1 : 0, // تحويل bool إلى عدد
      'BillCustomerQty': customerQuantity,
      'TotalQuantity': totalQuantity,
      'RequiredQTY': requiredQTY,
      'GiftQTY': giftQTY,
      'Y_Gift_Qty': yGiftQty,
    };
  }
}


