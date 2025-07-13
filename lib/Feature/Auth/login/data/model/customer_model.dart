class Customer {
  final int customerId;
  final String? arabicName;
  final String? englishName;
  final String? customerPhone;
  final String? lastName;
  final String password;
  final String email;
  final int regionId;
  final String? regionName;
  final int placeId;
  final String? districtName;
  final String? streetName;
  final String? gada;
  final String? houseNo;
  final String? block;
  final String? floor;
  final String? apartment;
  final String? addressNotes;
  final String? customerAddress;
  final double? billValue;
  final String? paymentMethod;
  final double? deliveryValue;
  final String? districtName2;
  final String? districtEName2;
  final String? token;
  final String? mapCustomerAddress;
  final String? mapPlaceId;
  final String addressId;
  final String? customerLastName;

  Customer({
    required this.customerId,
    this.arabicName,
    this.englishName,
    this.customerPhone,
    this.lastName,
    required this.password,
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
    this.customerAddress,
    this.billValue,
    this.paymentMethod,
    this.deliveryValue,
    this.districtName2,
    this.districtEName2,
    this.token,
    this.mapCustomerAddress,
    this.mapPlaceId,
    required this.addressId,
    this.customerLastName,
  });

  Customer.fromJson(Map<String, dynamic> json)
      : customerId = json['CustomerID'],
        arabicName = json['ArabicName'],
        englishName = json['EnglishName'],
        customerPhone = json['CustomerPhone'],
        lastName = json['LastName'],
        password = json['PassWord'],
        email = json['Email'],
        regionId = json['region_id'],
        regionName = json['RegionName'],
        placeId = json['place_id'],
        districtName = json['DistrictName'],
        streetName = json['StreetName'],
        gada = json['Gada'],
        houseNo = json['HouseNo'],
        block = json['Block'],
        floor = json['Floor'],
        apartment = json['Apartment'],
        addressNotes = json['AddressNotes'],
        customerAddress = json['CustomerAddress'],
        billValue = double.tryParse(json['BillValue']?.toString() ?? ''),
        paymentMethod = json['PaymentMethod'],
        deliveryValue = double.tryParse(json['DeliveryValue']?.toString() ?? ''),
        districtName2 = json['DistrictName2'],
        districtEName2 = json['DistrictEName2'],
        token = json['Token'],
        mapCustomerAddress = json['MapCustomerAddress'],
        mapPlaceId = json['MapPlaceID'],
        addressId = json['AddressID'],
        customerLastName = json['CustomerLastName'];

}
