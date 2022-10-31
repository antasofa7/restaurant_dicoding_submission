import 'package:flutter/material.dart';
import 'package:resto_app/data/api/api_service.dart';
import 'package:resto_app/data/models/search_restaurant_model.dart';

enum SearchResultState { loading, noData, hasData, error }

class SearchRestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  SearchRestaurantProvider({
    required this.apiService,
  }) {
    searchRestaurant(query);
  }

  SearchRestaurant? _searchResult;
  SearchResultState? _state;
  String _message = '';
  String _query = '';

  SearchRestaurant? get searchResult => _searchResult;
  SearchResultState? get state => _state;
  String get message => _message;
  String get query => _query;

  Future<dynamic> searchRestaurant(String query) async {
    try {
      if (query.isNotEmpty) {
        _state = SearchResultState.loading;
        final restaurant = await apiService.searchRestaurant(query);
        notifyListeners();
        _query = query;
        if (restaurant.restaurants.isEmpty) {
          _state = SearchResultState.noData;
          return _message = 'No Match Found!';
        } else {
          _state = SearchResultState.hasData;
          notifyListeners();
          return _searchResult = restaurant;
        }
      }
    } catch (e) {
      _state = SearchResultState.error;
      notifyListeners();
      return _message = 'Error: $e';
    }
  }
}
