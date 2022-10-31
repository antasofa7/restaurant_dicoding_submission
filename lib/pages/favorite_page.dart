import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/providers/database_provider.dart';
import 'package:resto_app/common/theme.dart';
import 'package:resto_app/widgets/restaurant_tile.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text(
            'Your Favorite Restaurant',
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: whiteColor, fontWeight: semiBold),
          ),
          elevation: 0,
        ),
        body: Consumer<DatabaseProvider>(
          builder: (context, provider, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return RestaurantTile(context,
                      restaurant: provider.favoriteList[index]);
                },
                itemCount: provider.favoriteList.length,
              ),
            );
          },
        ));
  }
}
