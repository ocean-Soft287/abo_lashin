class DiscountCodeModel {
  int? iD;
  String? discountCode;
  double? discountValue;
  int? discountPercent;
  String? fromDate;
  String? toDate;

  DiscountCodeModel(
      {this.iD,
        this.discountCode,
        this.discountValue,
        this.discountPercent,
        this.fromDate,
        this.toDate});

  DiscountCodeModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    discountCode = json['DiscountCode'];
    discountValue = json['DiscountValue'];
    discountPercent = json['DiscountPercent'];
    fromDate = json['FromDate'];
    toDate = json['ToDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['DiscountCode'] = discountCode;
    data['DiscountValue'] = discountValue;
    data['DiscountPercent'] = discountPercent;
    data['FromDate'] = fromDate;
    data['ToDate'] = toDate;
    return data;
  }
}