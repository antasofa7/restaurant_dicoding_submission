import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/data/api/api_service.dart';
import 'package:resto_app/pages/restaurant_page.dart';
import 'package:resto_app/providers/restaurant_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

Widget createRestaurantPage() => ChangeNotifierProvider<RestaurantProvider>(
      create: (context) =>
          RestaurantProvider(apiService: ApiService(client: http.Client())),
      child: const MaterialApp(
        home: Scaffold(body: RestaurantPage()),
      ),
    );

void main() {
  testWidgets(
    'Testing show ListView',
    (WidgetTester tester) async {
      await tester.pumpWidget(createRestaurantPage());
      expect(find.byType(ListView), findsWidgets);
    },
  );
}
