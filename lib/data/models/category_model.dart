class CategoryModel {
  CategoryModel({
    required this.name,
  });

  final String name;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

