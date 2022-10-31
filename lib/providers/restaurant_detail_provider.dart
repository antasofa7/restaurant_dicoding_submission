import 'package:flutter/material.dart';
import 'package:resto_app/data/api/api_service.dart';
import 'package:resto_app/data/models/customer_review_model.dart';
import 'package:resto_app/data/models/restaurant_detail_model.dart';
import 'package:resto_app/utils/result_state.dart';

enum SubmitState { loading, succcess, noData }

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;

  RestaurantDetailProvider({
    required this.apiService,
    required this.id,
  }) {
    fetchRestaurantDetail(id);
  }

  late RestaurantDetail _restaurantDetail;
  late List<CustomerReviewModel> _customerReviews =
      restaurantDetail.restaurant.customerReviews;
  late ResultState _state;
  SubmitState? _submitState;
  String _message = '';

  RestaurantDetail get restaurantDetail => _restaurantDetail;
  List<CustomerReviewModel> get customerReviews => _customerReviews;
  ResultState get state => _state;
  SubmitState? get submitState => _submitState;
  String get message => _message;

  Future<dynamic> fetchRestaurantDetail(id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.getRestaurantDetail(id);
      if (restaurant.error == true) {
        _state = ResultState.noData;
        return _message = 'Empty data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantDetail = restaurant;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error: $e';
    }
  }

  Future<dynamic> addReview(CustomerReviewModel dataReview) async {
    try {
      _submitState = SubmitState.loading;
      notifyListeners();
      final reviews = await apiService.addReview(dataReview);
      if (reviews.error == true) {
        _submitState = SubmitState.noData;
        return _message = 'Empty data';
      } else {
        _submitState = SubmitState.succcess;
        notifyListeners();
        return _customerReviews = reviews.customerReviews;
      }
    } catch (e) {
      return e.toString();
    }
  }
}
