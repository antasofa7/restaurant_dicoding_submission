import 'package:resto_app/data/models/category_model.dart';
import 'package:resto_app/data/models/customer_review_model.dart';
import 'package:resto_app/data/models/menus_model.dart';

class RestaurantDetail {
  RestaurantDetail({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  final bool error;
  final String message;
  final RestaurantDetailModel restaurant;

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) =>
      RestaurantDetail(
          error: json["error"],
          message: json["message"],
          restaurant: RestaurantDetailModel.fromJson(json["restaurant"]));

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "restaurant": restaurant.toJson(),
      };
}

class RestaurantDetailModel {
  RestaurantDetailModel({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.rating,
    required this.categories,
    required this.menus,
    required this.customerReviews,
  });

  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final double rating;
  final List<CategoryModel> categories;
  final MenusModel menus;
  List<CustomerReviewModel> customerReviews;

  factory RestaurantDetailModel.fromJson(Map<String, dynamic> json) =>
      RestaurantDetailModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        city: json["city"],
        address: json["address"],
        pictureId: json["pictureId"],
        rating: json["rating"].toDouble(),
        categories: List<CategoryModel>.from(
            json["categories"].map((x) => CategoryModel.fromJson(x))),
        menus: MenusModel.fromJson(json["menus"]),
        customerReviews: List<CustomerReviewModel>.from(json["customerReviews"]
            .map((x) => CustomerReviewModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "city": city,
        "address": address,
        "pictureId": pictureId,
        "rating": rating,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "menus": menus.toJson(),
        "customerReviews":
            List<dynamic>.from(customerReviews.map((x) => x.toJson())),
      };
}
