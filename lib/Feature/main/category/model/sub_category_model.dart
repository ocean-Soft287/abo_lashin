class SubCategoryModel {
  int? parentCategoryId;
  dynamic parentCategoryCode;
  dynamic parentCategoryArName;
  dynamic parentCategoryEnName;
  int? categoryId;
  dynamic categoryCode;
  String? categoryArName;
  String? categoryEnName;
  dynamic notes;
  bool? addCategoryToClinics;
  bool? addCategoryToRest;
  bool? addCategoryToSalon;
  bool? invisibleCategory;
  bool? stopedCategory;
  bool? clinicCategory;
  dynamic categoryImage;

  SubCategoryModel(
      {this.parentCategoryId,
        this.parentCategoryCode,
        this.parentCategoryArName,
        this.parentCategoryEnName,
        this.categoryId,
        this.categoryCode,
        this.categoryArName,
        this.categoryEnName,
        this.notes,
        this.addCategoryToClinics,
        this.addCategoryToRest,
        this.addCategoryToSalon,
        this.invisibleCategory,
        this.stopedCategory,
        this.clinicCategory,
        this.categoryImage});

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    parentCategoryId = json['ParentCategoryId'];
    parentCategoryCode = json['ParentCategoryCode'];
    parentCategoryArName = json['ParentCategoryArName'];
    parentCategoryEnName = json['ParentCategoryEnName'];
    categoryId = json['CategoryId'];
    categoryCode = json['CategoryCode'];
    categoryArName = json['CategoryArName'];
    categoryEnName = json['CategoryEnName'];
    notes = json['Notes'];
    addCategoryToClinics = json['AddCategoryToClinics'];
    addCategoryToRest = json['AddCategoryToRest'];
    addCategoryToSalon = json['AddCategoryToSalon'];
    invisibleCategory = json['InvisibleCategory'];
    stopedCategory = json['StopedCategory'];
    clinicCategory = json['ClinicCategory'];
    categoryImage = json['CategoryImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ParentCategoryId'] = parentCategoryId;
    data['ParentCategoryCode'] = parentCategoryCode;
    data['ParentCategoryArName'] = parentCategoryArName;
    data['ParentCategoryEnName'] = parentCategoryEnName;
    data['CategoryId'] = categoryId;
    data['CategoryCode'] = categoryCode;
    data['CategoryArName'] = categoryArName;
    data['CategoryEnName'] = categoryEnName;
    data['Notes'] = notes;
    data['AddCategoryToClinics'] = addCategoryToClinics;
    data['AddCategoryToRest'] = addCategoryToRest;
    data['AddCategoryToSalon'] = addCategoryToSalon;
    data['InvisibleCategory'] = invisibleCategory;
    data['StopedCategory'] = stopedCategory;
    data['ClinicCategory'] = clinicCategory;
    data['CategoryImage'] = categoryImage;
    return data;
  }
}