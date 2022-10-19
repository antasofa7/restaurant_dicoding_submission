import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:resto_app/data/models/customer_review_model.dart';
import 'package:resto_app/data/models/restaurant_detail_model.dart';
import 'package:resto_app/data/models/restaurant_list_model.dart';
import 'package:resto_app/data/models/review_model.dart';
import 'package:resto_app/data/models/search_restaurant_model.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<RestaurantList> getRestaurantList() async {
    final response = await http.get(Uri.parse("$_baseUrl/list"));

    if (response.statusCode == 200) {
      return RestaurantList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load restaurant list!');
    }
  }

  Future<RestaurantDetail> getRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse("$_baseUrl/detail/$id"));

    if (response.statusCode == 200) {
      return RestaurantDetail.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<SearchRestaurant> searchRestaurant(String query) async {
    final response = await http.get(Uri.parse("$_baseUrl/search?q=$query"));
    if (response.statusCode == 200) {
      return SearchRestaurant.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load search result');
    }
  }

  String imageMediumUrl(String pictureId) {
    return '$_baseUrl/images/medium/$pictureId';
  }

  Future<Review> addReview(CustomerReviewModel dataReview) async {
    final response = await http.post(Uri.parse("$_baseUrl/review"), body: {
      "id": dataReview.id,
      "name": dataReview.name,
      "review": dataReview.review
    });

    if (response.statusCode == 201) {
      return Review.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add review');
    }
  }
}
