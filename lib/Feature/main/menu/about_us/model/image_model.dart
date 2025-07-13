class ImageModel {
  final String imagePath;
  final String id;

  // Constructor
  ImageModel({required this.imagePath, required this.id});

  // Factory method to create an instance from a JSON object
  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      imagePath: json['ImagePath'],
      id: json['ID'],
    );
  }

  // Method to convert the instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'ImagePath': imagePath,
      'ID': id,
    };
  }
}
