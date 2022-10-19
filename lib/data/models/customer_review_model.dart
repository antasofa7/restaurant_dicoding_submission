class CustomerReviewModel {
  CustomerReviewModel({
    this.id,
    required this.name,
    required this.review,
    this.date,
  });

  final String? id;
  final String name;
  final String review;
  final String? date;

  factory CustomerReviewModel.fromJson(Map<String, dynamic> json) =>
      CustomerReviewModel(
        id: json["id"],
        name: json["name"],
        review: json["review"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "review": review,
        "date": date,
      };
}
