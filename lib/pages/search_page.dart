import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/data/models/restaurant_list_model.dart';
import 'package:resto_app/data/models/search_restaurant_model.dart';
import 'package:resto_app/providers/restaurant_provider.dart';
import 'package:resto_app/providers/search_restaurant_provider.dart';
import 'package:resto_app/widgets/restaurant_tile.dart';
import 'package:resto_app/widgets/skeleton_loading.dart';

class SearchPage extends StatefulWidget {
  static const String routeName = '/search';

  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String filter = '';
  SearchRestaurant? _searchRestaurantList;

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

  Widget _searchResult() {
    void showError(String message) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ));
      });
    }

    return Consumer<SearchRestaurantProvider>(builder: (context, value, _) {
      Widget sliverList = const SliverToBoxAdapter();
      if (value.state == SearchResultState.loading) {
        sliverList = SliverToBoxAdapter(
            child: Padding(
          padding: const EdgeInsets.only(top: 48.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.search,
                  size: 48.0,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Text(
                  'Finding restaurant...',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: Theme.of(context).colorScheme.tertiary),
                )
              ],
            ),
          ),
        ));
      } else {
        if (value.state == SearchResultState.hasData) {
          _searchRestaurantList = value.searchResult!;
          sliverList = SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              return RestaurantTile(context,
                  restaurant: _searchRestaurantList!.restaurants[index]);
            },
            childCount: _searchRestaurantList?.founded,
          ));
        } else if (value.state == SearchResultState.noData) {
          sliverList = const SliverToBoxAdapter(child: Center(child: Text('')));
          showError('Failed to load data search!');
        } else if (value.state == SearchResultState.error) {
          sliverList = const SliverToBoxAdapter(child: Center(child: Text('')));
          showError('Failed to load data search!');
        } else {
          sliverList = const SliverToBoxAdapter(child: Center(child: Text('')));
        }
      }
      return sliverList;
    });
  }

  Widget _recommendationRestaurant() {
    return Consumer<RestaurantProvider>(
      builder: (context, value, _) {
        Widget sliverList = const SliverToBoxAdapter();
        if (value.state == ResultState.loading) {
          sliverList = SliverToBoxAdapter(
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
        } else {
          if (value.state == ResultState.hasData) {
            RestaurantList restaurantList = value.restaurantList!;
            sliverList = SliverList(
                delegate: SliverChildBuilderDelegate(
              (context, index) {
                return RestaurantTile(context,
                    restaurant: restaurantList.restaurants[index]);
              },
              childCount: restaurantList.count,
            ));
          } else if (value.state == ResultState.noData) {
            sliverList =
                SliverToBoxAdapter(child: Center(child: Text(value.message)));
          } else if (value.state == ResultState.error) {
            sliverList =
                SliverToBoxAdapter(child: Center(child: Text(value.message)));
          } else {
            sliverList =
                const SliverToBoxAdapter(child: Center(child: Text('')));
          }
        }
        return sliverList;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: CustomScrollView(slivers: [
          SliverAppBar(
              backgroundColor: Theme.of(context).colorScheme.background,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              floating: true,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              toolbarHeight: 80,
              title: Hero(
                  tag: 'searchField',
                  transitionOnUserGestures: true,
                  child: Material(
                    color: Theme.of(context).colorScheme.background,
                    child: Container(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: TextFormField(
                        autofocus: true,
                        style: Theme.of(context).textTheme.subtitle1,
                        controller: _searchController,
                        onFieldSubmitted: (value) {
                          filter = value;
                          Provider.of<SearchRestaurantProvider>(context,
                                  listen: false)
                              .searchRestaurant(value);
                        },
                        decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            fillColor:
                                Theme.of(context).colorScheme.tertiaryContainer,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(16.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(16.0)),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _searchController.text = '';
                                  });
                                },
                                icon: Icon(
                                  _searchController.text == ''
                                      ? CupertinoIcons.search
                                      : Icons.close,
                                )),
                            hintText: 'Search restaurant',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiary)),
                      ),
                    ),
                  ))),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      filter == ""
                          ? Text(
                              'Recommendation',
                              style: Theme.of(context).textTheme.headline6,
                            )
                          : Text(
                              'Search result for: ${_searchController.text}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          filter == "" ? _recommendationRestaurant() : _searchResult()
        ]));
  }
}
