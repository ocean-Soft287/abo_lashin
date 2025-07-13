class GovernorateModel {
  final int governorateID;
  final String governorateName;
  final String governorateEName;

  GovernorateModel({
    required this.governorateID,
    required this.governorateName,
    required this.governorateEName,
  });


  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    return GovernorateModel(
      governorateID: json['GovernorateID'],
      governorateName: json['GovernorateName'],
      governorateEName: json['GovernorateEName'],
    );
  }

  // Method to convert a Governorate to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'GovernorateID': governorateID,
      'GovernorateName': governorateName,
      'GovernorateEName': governorateEName,
    };
  }
}
