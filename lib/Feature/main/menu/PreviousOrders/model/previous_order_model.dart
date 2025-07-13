class PreviousOrdersModel {
  final int orderNo;
  final int branchID;
  final DateTime orderDate;
  final DateTime deliveryDate;
  final int customerID;
  final String customerPhone;
  final String customerName;
  final String customerEnName;
  final String? customerAddress;
  final int onlineStoreId;
  final double totalValue;
  final String details;
  final double additions;
  final String orderTime;
  final double discount;
  final double finalValue;
  final String? additionalDescription1;
  final String? additionalDescription2;
  final String? additionalDescription3;
  final String? additionalDescription4;
  final String? additionalDescription5;
  final String? additionalDescription6;
  final String? additionalDescription7;
  final String? additionalDescription8;
  final String? additionalDescription9;
  final String? additionalDescription10;
  final int salesManID;
  final String salesManName;
  final String description1;
  final String description2;
  final String description3;
  final String refrenceNumber;
  final int userID;
  final String userName;
  final double taxesPercent;
  final double taxesValue;
  final int payID;
  final double payValue;
  final String? districtName;
  final String? block;
  final String? street;
  final String? house;
  final String? paymentID;
  final String? groupID;
  final String? secondPhone;
  final String? gada;
  final String? email;
  final String? floor;
  final String? apartment;
  final String? deliveryDay;
  final int deliveryID;
  final String orderAddress;
  final String discountCode;
  final double discountCardValue;
  final String? mapCustomerAddress;
  final String? mapPlaceID;
  final bool delivered;
  final bool prepare;
  final bool startDeliver;
  final bool sendingOrder;
  final bool underDeliver;

  PreviousOrdersModel({
    required this.orderNo,
    required this.branchID,
    required this.orderDate,
    required this.deliveryDate,
    required this.customerID,
    required this.customerPhone,
    required this.customerName,
    required this.customerEnName,
    this.customerAddress,
    required this.onlineStoreId,
    required this.totalValue,
    required this.details,
    required this.additions,
    required this.orderTime,
    required this.discount,
    required this.finalValue,
    this.additionalDescription1,
    this.additionalDescription2,
    this.additionalDescription3,
    this.additionalDescription4,
    this.additionalDescription5,
    this.additionalDescription6,
    this.additionalDescription7,
    this.additionalDescription8,
    this.additionalDescription9,
    this.additionalDescription10,
    required this.salesManID,
    required this.salesManName,
    required this.description1,
    required this.description2,
    required this.description3,
    required this.refrenceNumber,
    required this.userID,
    required this.userName,
    required this.taxesPercent,
    required this.taxesValue,
    required this.payID,
    required this.payValue,
    this.districtName,
    this.block,
    this.street,
    this.house,
    this.paymentID,
    this.groupID,
    this.secondPhone,
    this.gada,
    this.email,
    this.floor,
    this.apartment,
    this.deliveryDay,
    required this.deliveryID,
    required this.orderAddress,
    required this.discountCode,
    required this.discountCardValue,
    this.mapCustomerAddress,
    this.mapPlaceID,
    required this.delivered,
    required this.prepare,
    required this.startDeliver,
    required this.sendingOrder,
    required this.underDeliver,
  });

  factory PreviousOrdersModel.fromJson(Map<String, dynamic> json) {
    return PreviousOrdersModel(
      orderNo: json['OrderNo'],
      branchID: json['BranchID'],
      orderDate: DateTime.parse(json['OrderDate']),
      deliveryDate: DateTime.parse(json['DeliveryDate']),
      customerID: json['CustomerID'],
      customerPhone: json['CustomerPhone'],
      customerName: json['CustomerName'],
      customerEnName: json['CustomerEnName'],
      customerAddress: json['CustomerAddress'],
      onlineStoreId: json['OnlineStoreId'],
      totalValue: json['TotalValue'],
      details: json['Details'] ?? '',
      additions: json['Additions'],
      orderTime: json['OrderTime'],
      discount: json['Discount'],
      finalValue: json['FinalValue'],
      additionalDescription1: json['AdditionalDescription1'],
      additionalDescription2: json['AdditionalDescription2'],
      additionalDescription3: json['AdditionalDescription3'],
      additionalDescription4: json['AdditionalDescription4'],
      additionalDescription5: json['AdditionalDescription5'],
      additionalDescription6: json['AdditionalDescription6'],
      additionalDescription7: json['AdditionalDescription7'],
      additionalDescription8: json['AdditionalDescription8'],
      additionalDescription9: json['AdditionalDescription9'],
      additionalDescription10: json['AdditionalDescription10'],
      salesManID: json['SalesManID'],
      salesManName: json['SalesManName'],
      description1: json['Description1'],
      description2: json['Description2'],
      description3: json['Description3'],
      refrenceNumber: json['RefrenceNumber'],
      userID: json['UserID'],
      userName: json['UserName'],
      taxesPercent: json['TaxesPercent'],
      taxesValue: json['TaxesValue'],
      payID: json['PayID'],
      payValue: json['PayValue'],
      districtName: json['DistrictName'],
      block: json['Block'],
      street: json['Street'],
      house: json['House'],
      paymentID: json['PaymentID'],
      groupID: json['GroupID'],
      secondPhone: json['SecondPhone'],
      gada: json['Gada'],
      email: json['Email'],
      floor: json['Floor'],
      apartment: json['Apartment'],
      deliveryDay: json['DeliveryDay'],
      deliveryID: json['DeliveryID'],
      orderAddress: json['OrderAddress'],
      discountCode: json['DiscountCode'],
      discountCardValue: json['DiscountCardValue'],
      mapCustomerAddress: json['MapCustomerAddress'],
      mapPlaceID: json['MapPlaceID'],
      delivered: json['Delivered'],
      prepare: json['Prepare'],
      startDeliver: json['StartDeliver'],
      sendingOrder: json['SendingOrder'],
      underDeliver: json['UnderDeliver'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'OrderNo': orderNo,
      'BranchID': branchID,
      'OrderDate': orderDate.toIso8601String(),
      'DeliveryDate': deliveryDate.toIso8601String(),
      'CustomerID': customerID,
      'CustomerPhone': customerPhone,
      'CustomerName': customerName,
      'CustomerEnName': customerEnName,
      'CustomerAddress': customerAddress,
      'OnlineStoreId': onlineStoreId,
      'TotalValue': totalValue,
      'Details': details,
      'Additions': additions,
      'OrderTime': orderTime,
      'Discount': discount,
      'FinalValue': finalValue,
      'AdditionalDescription1': additionalDescription1,
      'AdditionalDescription2': additionalDescription2,
      'AdditionalDescription3': additionalDescription3,
      'AdditionalDescription4': additionalDescription4,
      'AdditionalDescription5': additionalDescription5,
      'AdditionalDescription6': additionalDescription6,
      'AdditionalDescription7': additionalDescription7,
      'AdditionalDescription8': additionalDescription8,
      'AdditionalDescription9': additionalDescription9,
      'AdditionalDescription10': additionalDescription10,
      'SalesManID': salesManID,
      'SalesManName': salesManName,
      'Description1': description1,
      'Description2': description2,
      'Description3': description3,
      'RefrenceNumber': refrenceNumber,
      'UserID': userID,
      'UserName': userName,
      'TaxesPercent': taxesPercent,
      'TaxesValue': taxesValue,
      'PayID': payID,
      'PayValue': payValue,
      'DistrictName': districtName,
      'Block': block,
      'Street': street,
      'House': house,
      'PaymentID': paymentID,
      'GroupID': groupID,
      'SecondPhone': secondPhone,
      'Gada': gada,
      'Email': email,
      'Floor': floor,
      'Apartment': apartment,
      'DeliveryDay': deliveryDay,
      'DeliveryID': deliveryID,
      'OrderAddress': orderAddress,
      'DiscountCode': discountCode,
      'DiscountCardValue': discountCardValue,
      'MapCustomerAddress': mapCustomerAddress,
      'MapPlaceID': mapPlaceID,
      'Delivered': delivered,
      'Prepare': prepare,
      'StartDeliver': startDeliver,
      'SendingOrder': sendingOrder,
      'UnderDeliver': underDeliver,
    };
  }
}