import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resto_app/data/api/api_service.dart';
import 'package:resto_app/data/models/restaurant_detail_model.dart';

import 'restaurant_api_service_test.mocks.dart';

var response = {
  "error": false,
  "message": "success",
  "restaurant": {
    "id": "rqdv5juczeskfw1e867",
    "name": "Melting Pot",
    "description":
        "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. ...",
    "city": "Medan",
    "address": "Jln. Pandeglang no 19",
    "pictureId": "14",
    "categories": [
      {"name": "Italia"},
      {"name": "Modern"}
    ],
    "menus": {
      "foods": [
        {"name": "Paket rosemary"},
        {"name": "Toastie salmon"}
      ],
      "drinks": [
        {"name": "Es krim"},
        {"name": "Sirup"}
      ]
    },
    "rating": 4.2,
    "customerReviews": [
      {
        "name": "Ahmad",
        "review": "Tidak rekomendasi untuk pelajar!",
        "date": "13 November 2019"
      }
    ]
  }
};

@GenerateMocks([http.Client])
void main() {
  group(
    'Fetch restaurant detail',
    () {
      final MockClient client = MockClient();
      final ApiService api = ApiService(client: http.Client());
      test(
        'return a restaurant detail if the http call completes successfully',
        () async {
          when(client.get(Uri.parse(
                  'restaurant-api.dicoding.dev/detail/rqdv5juczeskfw1e867')))
              .thenAnswer((_) async => http.Response(response.toString(), 200));

          expect(await api.getRestaurantDetail('rqdv5juczeskfw1e867'),
              isA<RestaurantDetail>());
        },
      );

      test(
        'throws an exception if the http call completes with an error',
        () {
          when(client.get(Uri.parse(
                  'restaurant-api.dicoding.dev/detail/rqdv5juczeskfw1e867')))
              .thenAnswer((_) async =>
                  http.Response('Failed to load restaurant detail!', 404));

          expect(
              api.getRestaurantDetail('rqdv5juczeskfw1e86'), throwsException);
        },
      );
    },
  );
}
