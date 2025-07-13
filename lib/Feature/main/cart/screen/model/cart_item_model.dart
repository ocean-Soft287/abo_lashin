import '../../../Home/model/product_model.dart';
class CartItem {
  final int productId;
  final String nameAr;
  final String nameEn;
  final String barcode;
  final double priceBeforeDiscount;
  final double priceAfterDiscount;
  final String image;
  final num stockQuantity;
  final num customerQuantity;
  final int quantity;

  CartItem( {
    required this.productId,
    required this.nameAr,
    required this.nameEn,
    required this.barcode,
    required this.priceBeforeDiscount,
    required this.priceAfterDiscount,
    required this.image,
    required this.stockQuantity,
    required this.customerQuantity,
    required this.quantity,
    });

  CartItem copyWith({
    int? productId,
    String? nameAr,
    String? nameEn,
    String? barcode,
    double? priceBeforeDiscount,
    double? priceAfterDiscount,
    String? image,
    num? stockQuantity,
    num? customerQuantity,
    int? quantity,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      barcode: barcode ?? this.barcode,
      priceBeforeDiscount: priceBeforeDiscount ?? this.priceBeforeDiscount,
      priceAfterDiscount: priceAfterDiscount ?? this.priceAfterDiscount,
      image: image ?? this.image,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      customerQuantity: customerQuantity ?? this.customerQuantity,
      quantity: quantity ?? this.quantity,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      barcode: json['barcode'],
      priceBeforeDiscount: (json['priceBeforeDiscount'] as num).toDouble(),
      priceAfterDiscount: (json['priceAfterDiscount'] as num).toDouble(),
      image: json['image'],
      stockQuantity: json['stockQuantity'],
      customerQuantity: json['BillCustomerQty'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'barcode': barcode,
      'priceBeforeDiscount': priceBeforeDiscount,
      'priceAfterDiscount': priceAfterDiscount,
      'image': image,
      'stockQuantity': stockQuantity,
      'BillCustomerQty': customerQuantity,
      'quantity': quantity,
    };
  }

  Map<String, dynamic> toMap() => toJson(); // alias for compatibility

  factory CartItem.empty(int productId) {
    return CartItem(
      productId: productId,
      nameAr: '',
      nameEn: '',
      barcode: '',
      priceBeforeDiscount: 0,
      priceAfterDiscount: 0,
      image: '',
      stockQuantity: 0,
      customerQuantity: 0,
      quantity: 0,
    );
  }
}
