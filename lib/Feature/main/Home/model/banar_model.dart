class BannerModel {
  final String imagePath;
  final String id;
  final int showGroup;
  final int itemsCount;


  BannerModel({
    required this.imagePath,
    required this.id,
    required this.showGroup,
    required this.itemsCount
  });


  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      imagePath: json['ImagePath'] as String,
      id: json['ID'] as String,
      showGroup: json['ShowGroup'],
      itemsCount: json['ItemsCount'],
    );
  }



}
