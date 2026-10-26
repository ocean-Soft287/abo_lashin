class ImageModel {
  final String imagePath;
  final String id;

  ImageModel({required this.imagePath, required this.id});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(imagePath: json['ImagePath'], id: json['ID']);
  }

  Map<String, dynamic> toJson() {
    return {'ImagePath': imagePath, 'ID': id};
  }
}
