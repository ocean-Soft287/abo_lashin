
class AllAddressModel {
  final int customerID;
  final String arabicName;
  final String englishName;
  final String customerPhone;
  final String? lastName; // الحقول التي قد تكون null
  final String passWord;
  final String email;
  final int regionId;
  final String? regionName;
  final int placeId;
  final String? districtName;
  final String? streetName;
  final String? gada; // تعديل النوع ليسمح بـ null
  final String? houseNo;
  final String? block;
  final String? floor;
  final String? apartment;
  final String? addressNotes; // تعديل النوع ليسمح بـ null
  final String customerAddress;
  final String? billValue;
  final String? paymentMethod;
  final String? deliveryValue;
  final String? districtName2;
  final String? districtEName2;
  final String? token;
  final String? mapCustomerAddress;
  final String? mapPlaceID;
  final String addressID;
  final String? customerLastName;
  final int regionID3;
  final String? regionname3;
  final String? regionEname3;
  final String? addressNotes3;
  final String? address;

  AllAddressModel({
    required this.customerID,
    required this.arabicName,
    required this.englishName,
    required this.customerPhone,
    this.lastName,
    required this.passWord,
    required this.email,
    required this.regionId,
    this.regionName,
    required this.placeId,
    this.districtName,
    this.streetName,
    this.gada,
    this.houseNo,
    this.block,
    this.floor,
    this.apartment,
    this.addressNotes,
    required this.customerAddress,
    this.billValue,
    this.paymentMethod,
    this.deliveryValue,
    this.districtName2,
    this.districtEName2,
    this.token,
    this.mapCustomerAddress,
    this.mapPlaceID,
    required this.addressID,
    this.customerLastName,
    required this.regionID3,
    this.regionname3,
    this.regionEname3,
    this.addressNotes3,
    this.address,
  });

  // تحويل JSON إلى الموديل
  factory AllAddressModel.fromJson(Map<String, dynamic> json) {
    return AllAddressModel(
      customerID: json['CustomerID'],
      arabicName: json['ArabicName'] ?? '',
      englishName: json['EnglishName'] ?? '',
      customerPhone: json['CustomerPhone'] ?? '',
      lastName: json['LastName'],
      passWord: json['PassWord'] ?? '',
      email: json['Email'] ?? '',
      regionId: json['region_id'],
      regionName: json['RegionName'],
      placeId: json['place_id'],
      districtName: json['DistrictName'],
      streetName: json['StreetName'],
      gada: json['Gada'] ?? '', // قيمة افتراضية
      houseNo: json['HouseNo'],
      block: json['Block'],
      floor: json['Floor'],
      apartment: json['Apartment'],
      addressNotes: json['AddressNotes'] ?? '', // قيمة افتراضية
      customerAddress: json['CustomerAddress'] ?? '',
      billValue: json['BillValue'],
      paymentMethod: json['PaymentMethod'],
      deliveryValue: json['DeliveryValue'],
      districtName2: json['DistrictName2'],
      districtEName2: json['DistrictEName2'],
      token: json['Token'],
      mapCustomerAddress: json['MapCustomerAddress'],
      mapPlaceID: json['MapPlaceID'],
      addressID: json['AddressID'] ?? '',
      customerLastName: json['CustomerLastName'],
      regionID3: json['RegionID3'],
      regionname3: json['Regionname3'],
      regionEname3: json['RegionEname3'],
      addressNotes3: json['AddressNotes3'],
      address: json['Address'],
    );
  }

  // تحويل الموديل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'CustomerID': customerID,
      'ArabicName': arabicName,
      'EnglishName': englishName,
      'CustomerPhone': customerPhone,
      'LastName': lastName,
      'PassWord': passWord,
      'Email': email,
      'region_id': regionId,
      'RegionName': regionName,
      'place_id': placeId,
      'DistrictName': districtName,
      'StreetName': streetName,
      'Gada': gada,
      'HouseNo': houseNo,
      'Block': block,
      'Floor': floor,
      'Apartment': apartment,
      'AddressNotes': addressNotes,
      'CustomerAddress': customerAddress,
      'BillValue': billValue,
      'PaymentMethod': paymentMethod,
      'DeliveryValue': deliveryValue,
      'DistrictName2': districtName2,
      'DistrictEName2': districtEName2,
      'Token': token,
      'MapCustomerAddress': mapCustomerAddress,
      'MapPlaceID': mapPlaceID,
      'AddressID': addressID,
      'CustomerLastName': customerLastName,
      'RegionID3': regionID3,
      'Regionname3': regionname3,
      'RegionEname3': regionEname3,
      'AddressNotes3': addressNotes3,
      'Address': address,
    };
  }
}
