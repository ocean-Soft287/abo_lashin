class AreaModel {
  num? districtID;
  String? districtName;
  num? governorateID;
  String? districtEName;
  num? deliveryValue;
  num? billValue;
  num? paymentMethod;



  AreaModel.fromJson(Map<String, dynamic> json) {
    districtID = json['DistrictID'];
    districtName = json['DistrictName'];
    governorateID = json['GovernorateID'];
    districtEName = json['DistrictEName'];
    deliveryValue = json['DeliveryValue'];
    billValue = json['BillValue'];
    paymentMethod = json['PaymentMethod'];
  }


}