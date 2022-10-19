import 'package:resto_app/data/models/restaurant_list_model.dart';

class SearchRestaurant {
  SearchRestaurant({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  final bool error;
  final int founded;
  final List<RestaurantListModel> restaurants;

  factory SearchRestaurant.fromJson(Map<String, dynamic> json) =>
      SearchRestaurant(
        error: json["error"],
        founded: json["founded"],
        restaurants: List<RestaurantListModel>.from(
            json["restaurants"].map((x) => RestaurantListModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "founded": founded,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}
