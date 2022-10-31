import 'package:flutter/material.dart';
import 'package:resto_app/data/db/database_helper.dart';
import 'package:resto_app/data/models/restaurant_list_model.dart';
import 'package:resto_app/utils/result_state.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _getFavoriteList();
  }

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<RestaurantListModel> _favoriteList = [];
  List<RestaurantListModel> get favoriteList => _favoriteList;

  void _getFavoriteList() async {
    _favoriteList = await databaseHelper.getFavoriteList();
    if (_favoriteList.isNotEmpty) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.noData;
      _message = 'Empty Data';
    }
    notifyListeners();
  }

  void addFavorite(RestaurantListModel resto) async {
    try {
      await databaseHelper.addFavorite(resto);
      _getFavoriteList();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isFavorite(String id) async {
    final favoriteRestaurant = await databaseHelper.getFavoriteById(id);
    return favoriteRestaurant.isNotEmpty;
  }

  Future removeFavorite(String id) async {
    try {
      await databaseHelper.removeFavorite(id);
      _getFavoriteList();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}
