class ProductModel {
  List<Products>? products;

  ProductModel({this.products});

  ProductModel.fromJson(Map<String, dynamic> json) {
    if (json['Products'] != null) {
      products = <Products>[];
      json['Products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (products != null) {
      data['Products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String? productCode;
  String? barCode;
  int? colorID;
  dynamic colorArName;
  dynamic colorEnName;
  int? sizeID;
  dynamic sizeName;
  dynamic sizeEName;
  String? productArName;
  String? productEnName;
  String? categoryId;
  String? categoryCode;
  String? categoryArName;
  String? categoryEnName;
  int? departmentId;
  dynamic departmentArName;
  dynamic departmentEnName;
  int? descriptionID;
  dynamic descriptionArName;
  dynamic descriptionEnName;
  dynamic seasonID;
  dynamic seasonArName;
  dynamic seasonEnName;
  dynamic brandID;
  dynamic brandArName;
  dynamic brandEnName;
  int? countryID;
  dynamic countryArName;
  dynamic countryEnName;
  int? patternId;

  dynamic patternArName;
  dynamic patternEnName;
  int? stockQuantity;
  int? customerquantity;
  double? price;
  double? priceAfterDiscount;
  int? wholePrice;
  int? halfWholePrice;
  int? salePrice;
  int? lastBuyPrice;
  int? localCost;
  dynamic exportPrice;

  Products({
    this.productCode,
    this.barCode,

    this.colorID,
    this.colorArName,
    this.colorEnName,
    this.sizeID,
    this.sizeName,
    this.sizeEName,
    this.productArName,
    this.productEnName,
    this.categoryId,
    this.categoryCode,
    this.categoryArName,
    this.categoryEnName,
    this.departmentId,
    this.departmentArName,
    this.departmentEnName,
    this.descriptionID,
    this.descriptionArName,
    this.descriptionEnName,
    this.seasonID,
    this.seasonArName,
    this.seasonEnName,
    this.brandID,
    this.brandArName,
    this.brandEnName,
    this.countryID,
    this.countryArName,
    this.countryEnName,
    this.patternId,
    this.patternArName,
    this.patternEnName,
    this.stockQuantity,
    this.price,
    this.priceAfterDiscount,
    this.wholePrice,
    this.halfWholePrice,
    this.salePrice,
    this.lastBuyPrice,
    this.localCost,
    this.exportPrice,
    this.customerquantity
  });

  Products.fromJson(Map<String, dynamic> json) {
    productCode = json['ProductCode'];
    barCode = json['BarCode'];
    colorID = json['ColorID'] != null ? json['ColorID'] as int : null;
    colorArName = json['ColorArName'];
    colorEnName = json['ColorEnName'];
    sizeID = json['SizeID'] != null ? json['SizeID'] as int : null;
    sizeName = json['SizeName'];
    sizeEName = json['SizeEName'];
    productArName = json['ProductArName'];
    productEnName = json['ProductEnName'];
    categoryId = json['CategoryId'];
    categoryCode = json['CategoryCode'];
    categoryArName = json['CategoryArName'];
    categoryEnName = json['CategoryEnName'];
    departmentId =
        json['DepartmentId'] != null ? json['DepartmentId'] as int : null;
    departmentArName = json['DepartmentArName'];
    departmentEnName = json['DepartmentEnName'];
    descriptionID =
        json['DescriptionID'] != null ? json['DescriptionID'] as int : null;
    descriptionArName = json['DescriptionArName'];
    descriptionEnName = json['DescriptionEnName'];
    seasonID = json['SeasonID'] != null ? json['SeasonID'] as int : null;
    seasonArName = json['SeasonArName'];
    seasonEnName = json['SeasonEnName'];
    brandID = json['BrandID'];
    brandArName = json['BrandArName'];
    brandEnName = json['BrandEnName'];
    countryID = json['CountryID'] != null ? json['CountryID'] as int : null;
    countryArName = json['CountryArName'];
    countryEnName = json['CountryEnName'];
    patternId = json['PatternId'] != null ? json['PatternId'] as int : null;
    patternArName = json['PatternArName'];
    patternEnName = json['PatternEnName'];
    stockQuantity =
        json['StockQuantity'] != null ? json['StockQuantity'] as int : null;
    customerquantity=json['CustomerQuantity']!= null ? json['CustomerQuantity'] as int : null;
    price = json['Price'] != null ? json['Price'] as double : null;
    priceAfterDiscount =
        json['PriceAfterDiscount'] != null
            ? json['PriceAfterDiscount'] as double
            : null;
    wholePrice = json['WholePrice'] != null ? json['WholePrice'] as int : null;
    halfWholePrice =
        json['HalfWholePrice'] != null ? json['HalfWholePrice'] as int : null;
    salePrice = json['SalePrice'] != null ? json['SalePrice'] as int : null;
    lastBuyPrice =
        json['LastBuyPrice'] != null ? json['LastBuyPrice'] as int : null;
    localCost = json['LocalCost'] != null ? json['LocalCost'] as int : null;
    exportPrice = json['ExportPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ProductCode'] = productCode;
    data['BarCode'] = barCode;

    data['ColorID'] = colorID;
    data['ColorArName'] = colorArName;
    data['ColorEnName'] = colorEnName;
    data['SizeID'] = sizeID;
    data['SizeName'] = sizeName;
    data['SizeEName'] = sizeEName;
    data['ProductArName'] = productArName;
    data['ProductEnName'] = productEnName;
    data['CategoryId'] = categoryId;
    data['CategoryCode'] = categoryCode;
    data['CategoryArName'] = categoryArName;
    data['CategoryEnName'] = categoryEnName;
    data['DepartmentId'] = departmentId;
    data['DepartmentArName'] = departmentArName;
    data['DepartmentEnName'] = departmentEnName;
    data['DescriptionID'] = descriptionID;
    data['DescriptionArName'] = descriptionArName;
    data['DescriptionEnName'] = descriptionEnName;
    data['SeasonID'] = seasonID;
    data['SeasonArName'] = seasonArName;
    data['SeasonEnName'] = seasonEnName;
    data['BrandID'] = brandID;
    data['BrandArName'] = brandArName;
    data['BrandEnName'] = brandEnName;
    data['CountryID'] = countryID;
    data['CountryArName'] = countryArName;
    data['CountryEnName'] = countryEnName;
    data['PatternId'] = patternId;
    data['PatternArName'] = patternArName;
    data['PatternEnName'] = patternEnName;
    data['StockQuantity'] = stockQuantity;

    data['Price'] = price;
    data['PriceAfterDiscount'] = priceAfterDiscount;
    data['WholePrice'] = wholePrice;
    data['HalfWholePrice'] = halfWholePrice;
    data['SalePrice'] = salePrice;
    data['LastBuyPrice'] = lastBuyPrice;
    data['LocalCost'] = localCost;
    data['ExportPrice'] = exportPrice;
    return data;
  }
}
