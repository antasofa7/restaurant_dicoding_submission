class MenusModel {
  MenusModel({
    required this.foods,
    required this.drinks,
  });

  final List<DrinkAndFood> foods;
  final List<DrinkAndFood> drinks;

  factory MenusModel.fromJson(Map<String, dynamic> json) => MenusModel(
        foods: List<DrinkAndFood>.from(
            json["foods"].map((x) => DrinkAndFood.fromJson(x))),
        drinks: List<DrinkAndFood>.from(
            json["drinks"].map((x) => DrinkAndFood.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
        "drinks": List<dynamic>.from(drinks.map((x) => x.toJson())),
      };
}

class DrinkAndFood {
  DrinkAndFood({
    required this.name,
  });

  final String name;

  factory DrinkAndFood.fromJson(Map<String, dynamic> json) => DrinkAndFood(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
