class NewsMarqueeModel {
  final int newsLineID;
  final String newsText;
  final DateTime startAt;
  final DateTime endAt;
  final int showPeriod;

  NewsMarqueeModel({
    required this.newsLineID,
    required this.newsText,
    required this.startAt,
    required this.endAt,
    required this.showPeriod,
  });

  factory NewsMarqueeModel.fromJson(Map<String, dynamic> json) {
    return NewsMarqueeModel(
      newsLineID: json['NewsLineID'],
      newsText: json['NewsText'],
      startAt: DateTime.parse(json['StartAt']),
      endAt: DateTime.parse(json['EndAt']),
      showPeriod: json['ShowPeriod'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'NewsLineID': newsLineID,
      'NewsText': newsText,
      'StartAt': startAt.toIso8601String(),
      'EndAt': endAt.toIso8601String(),
      'ShowPeriod': showPeriod,
    };
  }
}
