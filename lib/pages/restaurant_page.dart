import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/data/models/restaurant_list_model.dart';
import 'package:resto_app/pages/search_page.dart';
import 'package:resto_app/providers/restaurant_provider.dart';
import 'package:resto_app/utils/result_state.dart';
import 'package:resto_app/widgets/top_rated_restaurant.dart';
import 'package:resto_app/widgets/restaurant_tile.dart';
import 'package:resto_app/widgets/skeleton_loading.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({super.key});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  Widget loadingHorizontal() {
    return SliverToBoxAdapter(
        child: Container(
      margin: const EdgeInsets.only(top: 16.0, bottom: 24.0),
      height: 220.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: SkeletonLoading(
              width: MediaQuery.of(context).size.width - 48.0,
              height: 220.0,
              margin: const EdgeInsets.only(bottom: 16.0),
              radius: 16.0,
            ),
          );
        },
        itemCount: 2,
      ),
    ));
  }

  Widget loadingVertical() {
    return SliverToBoxAdapter(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: const [
                SkeletonLoading(
                  width: double.infinity,
                  height: 180.0,
                  margin: EdgeInsets.only(bottom: 16.0),
                  radius: 16.0,
                ),
                SkeletonLoading(
                  width: double.infinity,
                  height: 180.0,
                  margin: EdgeInsets.only(bottom: 16.0),
                  radius: 16.0,
                ),
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    void showError(String message) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ));
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Consumer<RestaurantProvider>(
        builder: (context, value, _) {
          Widget sliverListHorizontal = const SliverToBoxAdapter();
          Widget sliverListVertical = const SliverToBoxAdapter();

          if (value.state == ResultState.loading) {
            sliverListHorizontal = loadingHorizontal();
            sliverListVertical = loadingVertical();
          } else {
            if (value.state == ResultState.hasData) {
              final RestaurantList list = value.restaurantList!;
              var popularList = value.restaurantList!.restaurants
                  .where((element) => element.rating > 4.5)
                  .toList();
              sliverListHorizontal = SliverToBoxAdapter(
                  child: Container(
                margin: const EdgeInsets.only(top: 16.0, bottom: 32.0),
                height: 220.0,
                child: ListView.builder(
                  key: const ValueKey('listTopRated'),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return TopRatedRestaurant(
                      context,
                      restaurant: popularList[index],
                      index: index,
                      itemCount: popularList.length,
                    );
                  },
                  itemCount: popularList.length,
                ),
              ));
              sliverListVertical = SliverPadding(
                  padding: const EdgeInsets.only(top: 12.0),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return RestaurantTile(context,
                          restaurant: list.restaurants[index]);
                    },
                    childCount: list.count,
                  )));
            } else if (value.state == ResultState.noData) {
              showError('Failed to load restaurant list!');
              sliverListHorizontal = loadingHorizontal();
              sliverListVertical = loadingVertical();
            } else if (value.state == ResultState.error) {
              showError('Failed to load restaurant list!');
              sliverListHorizontal = loadingHorizontal();
              sliverListVertical = loadingVertical();
            } else {
              sliverListVertical =
                  const SliverToBoxAdapter(child: Center(child: Text('')));
            }
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
                IconButton(
                  padding: const EdgeInsets.all(16.0),
                  icon: Icon(
                    Icons.notifications,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {},
                  color: Colors.white,
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Text(
                        'Where would \nyou want to eat?',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, SearchPage.routeName);
                          },
                          child: Hero(
                              tag: 'searchField',
                              transitionOnUserGestures: true,
                              child: Material(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  child: Container(
                                    padding: const EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiaryContainer,
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          width: 2,
                                        )),
                                    child: Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.search,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        const SizedBox(
                                          width: 8.0,
                                        ),
                                        Text('Search your favorite restaurant',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .tertiary)),
                                      ],
                                    ),
                                  )))),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Top Rated Restaurant',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            sliverListHorizontal,
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Recommendation Restaurant',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            sliverListVertical
          ]);
        },
      ),
    );
  }
}
