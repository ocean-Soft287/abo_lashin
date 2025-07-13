class SubCategoryModel {
  final int parentCategoryId;
  final String? parentCategoryCode;
  final String? parentCategoryArName;
  final String? parentCategoryEnName;
  final int categoryId;
  final String? categoryCode;
  final String categoryArName;
  final String categoryEnName;
  final String? notes;
  final bool addCategoryToClinics;
  final bool addCategoryToRest;
  final bool addCategoryToSalon;
  final bool invisibleCategory;
  final bool stoppedCategory;
  final bool clinicCategory;
  final String? categoryImage;

  SubCategoryModel({
    required this.parentCategoryId,
    this.parentCategoryCode,
    this.parentCategoryArName,
    this.parentCategoryEnName,
    required this.categoryId,
    this.categoryCode,
    required this.categoryArName,
    required this.categoryEnName,
    this.notes,
    required this.addCategoryToClinics,
    required this.addCategoryToRest,
    required this.addCategoryToSalon,
    required this.invisibleCategory,
    required this.stoppedCategory,
    required this.clinicCategory,
    this.categoryImage,
  });

  // دالة لتحويل JSON إلى نموذج
  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      parentCategoryId: json['ParentCategoryId'] as int,
      parentCategoryCode: json['ParentCategoryCode'] as String?,
      parentCategoryArName: json['ParentCategoryArName'] as String?,
      parentCategoryEnName: json['ParentCategoryEnName'] as String?,
      categoryId: json['CategoryId'] as int,
      categoryCode: json['CategoryCode'] as String?,
      categoryArName: json['CategoryArName'] as String,
      categoryEnName: json['CategoryEnName'] as String,
      notes: json['Notes'] as String?,
      addCategoryToClinics: json['AddCategoryToClinics'] as bool,
      addCategoryToRest: json['AddCategoryToRest'] as bool,
      addCategoryToSalon: json['AddCategoryToSalon'] as bool,
      invisibleCategory: json['InvisibleCategory'] as bool,
      stoppedCategory: json['StopedCategory'] as bool,
      clinicCategory: json['ClinicCategory'] as bool,
      categoryImage: json['CategoryImage'] as String?,
    );
  }

  // دالة لتحويل النموذج إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'ParentCategoryId': parentCategoryId,
      'ParentCategoryCode': parentCategoryCode,
      'ParentCategoryArName': parentCategoryArName,
      'ParentCategoryEnName': parentCategoryEnName,
      'CategoryId': categoryId,
      'CategoryCode': categoryCode,
      'CategoryArName': categoryArName,
      'CategoryEnName': categoryEnName,
      'Notes': notes,
      'AddCategoryToClinics': addCategoryToClinics,
      'AddCategoryToRest': addCategoryToRest,
      'AddCategoryToSalon': addCategoryToSalon,
      'InvisibleCategory': invisibleCategory,
      'StopedCategory': stoppedCategory,
      'ClinicCategory': clinicCategory,
      'CategoryImage': categoryImage,
    };
  }
}
