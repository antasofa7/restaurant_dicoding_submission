import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resto_app/data/model/restaurant.dart';
import 'package:resto_app/widgets/restaurant_tile.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({super.key});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  final TextEditingController _searchController = TextEditingController();
  String filter = '';

  @override
  void initState() {
    _searchController.addListener(() {
      setState(() {
        filter = _searchController.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: FutureBuilder(
        future: DefaultAssetBundle.of(context)
            .loadString('assets/local_restaurant.json'),
        builder: (context, snapshot) {
          Widget sliver;
          if (snapshot.hasData) {
            final Restaurant restaurant = restaurantFromJson(snapshot.data!);
            final filterList = restaurant.restaurants
                .where((resto) =>
                    resto.name.toLowerCase().contains(filter.toLowerCase()))
                .toList();
            sliver = filterList.isNotEmpty
                ? SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return filter == ""
                          ? RestaurantTile(context,
                              restaurant: restaurant.restaurants[index])
                          : RestaurantTile(context,
                              restaurant: filterList[index]);
                    },
                        childCount: filter == ""
                            ? restaurant.restaurants.length
                            : filterList.length),
                  )
                : SliverToBoxAdapter(
                    child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('no matches found.'.toUpperCase(),
                            style: Theme.of(context).textTheme.headline6),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          'Please try another keyword!',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Colors.grey),
                        )
                      ],
                    ),
                  ));
          } else if (snapshot.hasError) {
            sliver =
                const SliverToBoxAdapter(child: Text('Data failed to load'));
          } else {
            sliver =
                const SliverToBoxAdapter(child: CircularProgressIndicator());
          }
          return CustomScrollView(slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).colorScheme.background,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 24.0,
                      backgroundImage: AssetImage('assets/profile.jpg'),
                    ),
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome,',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Text(
                        'Krista',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(
                    Icons.notifications,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: TextFormField(
                        autofocus: false,
                        style: Theme.of(context).textTheme.subtitle1,
                        controller: _searchController,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(32.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(32.0)),
                            prefixIcon: Icon(
                              CupertinoIcons.search,
                              color: Theme.of(context).primaryColor,
                            ),
                            hintText: 'Search your favorite restaurant',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: Colors.grey)),
                      ),
                    ),
                    Column(
                      children: [
                        filter == ""
                            ? Text(
                                'Recommendation restaurant for you',
                                style: Theme.of(context).textTheme.headline5,
                              )
                            : Text(
                                'Search result:',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: Colors.grey),
                              ),
                        const SizedBox(
                          height: 16.0,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            sliver
          ]);
        },
      ),
    );
  }
}
