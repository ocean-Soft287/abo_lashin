

class UserModel {
  final int customerID;
  final String arabicName;
  final String englishName;
  final String customerPhone;
  final String? lastName;
  final String? password;
  final String email;
  final int regionId;
  final String regionName;
  final int placeId;
  final String districtName;
  final String? streetName;
  final String? gada;
  final String? houseNo;
  final String? block;
  final String? floor;
  final String? apartment;
  final String? addressNotes;
  final String? customerAddress;
  final String billValue;
  final String paymentMethod;
  final String deliveryValue;
  final String? districtName2;
  final String? districtEName2;
  final String? token;
  final String? mapCustomerAddress;
  final String? mapPlaceID;
  final String addressID;
  final String customerLastName;
  final int regionID3;
  final String? regionName3;
  final String? regionEName3;
  final String? addressNotes3;
  final String? address;
  final int mainAddress;
  final String? customerWork;

  UserModel({
    required this.customerID,
    required this.arabicName,
    required this.englishName,
    required this.customerPhone,
    this.lastName,
    this.password,
    required this.email,
    required this.regionId,
    required this.regionName,
    required this.placeId,
    required this.districtName,
    this.streetName,
    this.gada,
    this.houseNo,
    this.block,
    this.floor,
    this.apartment,
    this.addressNotes,
    this.customerAddress,
    required this.billValue,
    required this.paymentMethod,
    required this.deliveryValue,
    this.districtName2,
    this.districtEName2,
    this.token,
    this.mapCustomerAddress,
    this.mapPlaceID,
    required this.addressID,
    required this.customerLastName,
    required this.regionID3,
    this.regionName3,
    this.regionEName3,
    this.addressNotes3,
    this.address,
    required this.mainAddress,
    this.customerWork,
  });


  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      customerID: json["CustomerID"] ?? 0,
      arabicName: json["ArabicName"] ?? "",
      englishName: json["EnglishName"] ?? "",
      customerPhone: json["CustomerPhone"] ?? "",
      lastName: json["LastName"],
      password: json["PassWord"],
      email: json["Email"] ?? "",
      regionId: json["region_id"] ?? 0,
      regionName: json["RegionName"] ?? "",
      placeId: json["place_id"] ?? 0,
      districtName: json["DistrictName"] ?? "",
      streetName: json["StreetName"],
      gada: json["Gada"],
      houseNo: json["HouseNo"],
      block: json["Block"],
      floor: json["Floor"],
      apartment: json["Apartment"],
      addressNotes: json["AddressNotes"],
      customerAddress: json["CustomerAddress"],
      billValue: json["BillValue"] ?? "0",
      paymentMethod: json["PaymentMethod"] ?? "0",
      deliveryValue: json["DeliveryValue"] ?? "0",
      districtName2: json["DistrictName2"],
      districtEName2: json["DistrictEName2"],
      token: json["Token"],
      mapCustomerAddress: json["MapCustomerAddress"],
      mapPlaceID: json["MapPlaceID"],
      addressID: json["AddressID"] ?? "0",
      customerLastName: json["CustomerLastName"] ?? "",
      regionID3: json["RegionID3"] ?? 0,
      regionName3: json["Regionname3"],
      regionEName3: json["RegionEname3"],
      addressNotes3: json["AddressNotes3"],
      address: json["Address"],
      mainAddress: json["MainAddress"] ?? 0,
      customerWork: json["CustomerWork"],
    );
  }



}


