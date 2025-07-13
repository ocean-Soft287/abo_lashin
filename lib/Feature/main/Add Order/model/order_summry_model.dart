class OrderSummryModel {
  final String orderDate;
  final String customerPhone;
  final String customerName;
  final String districtName;
  final int payID;
  final String regionName;
  final double totalValue;
  final String orderAddress;
  final double discount;
  final num additions;
  final double finalValue;
  final int onlineStoreId;
  final List<OrderItem> orderItems;

  OrderSummryModel({
    required this.orderDate,
    required this.customerPhone,
    required this.customerName,
    required this.districtName,
    required this.payID,
    required this.regionName,
    required this.totalValue,
    required this.orderAddress,
    required this.discount,
    required this.additions,
    required this.finalValue,
    required this.onlineStoreId,
    required this.orderItems,
  });

  factory OrderSummryModel.fromJson(Map<String, dynamic> json) {
    return OrderSummryModel(
      orderDate: json['OrderDate'],
      customerPhone: json['CustomerPhone'],
      customerName: json['CustomerName'],
      districtName: json['DistrictName'] ?? '',
      payID: json['PayID'],
      regionName: json['RegionName'],
      totalValue: (json['TotalValue'] as num).toDouble(),
      orderAddress: json['OrderAddress'],
      discount: (json['Discount'] as num).toDouble(),
      additions: json['Additions'],
      finalValue: (json['FinalValue'] as num).toDouble(),
      onlineStoreId: json['OnlineStoreId'],
      orderItems: (json['OrderItems'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }
}

class OrderItem {
  final int itemId;
  final int quantity;
  final double price;
  final String barcode;

  OrderItem({
    required this.itemId,
    required this.quantity,
    required this.price,
    required this.barcode,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      itemId: json['ItemID'],
      quantity: json['Quantity'],
      price: (json['Price'] as num).toDouble(),
      barcode: json['Barcode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ItemID': itemId,
      'Quantity': quantity,
      'Price': price,
      'Barcode': barcode,
    };
  }
}