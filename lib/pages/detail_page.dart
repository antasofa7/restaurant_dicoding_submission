import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/common/navigation.dart';
import 'package:resto_app/data/api/api_service.dart';
import 'package:resto_app/data/models/customer_review_model.dart';
import 'package:resto_app/data/models/menus_model.dart';
import 'package:resto_app/data/models/restaurant_detail_model.dart';
import 'package:resto_app/data/models/restaurant_list_model.dart';
import 'package:resto_app/providers/database_provider.dart';
import 'package:resto_app/providers/restaurant_detail_provider.dart';
import 'package:resto_app/common/theme.dart';
import 'package:resto_app/utils/result_state.dart';
import 'package:resto_app/widgets/no_data_widget.dart';
import 'package:resto_app/widgets/skeleton_loading.dart';
import 'package:resto_app/widgets/star_rating.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  static const routeName = '/detail';
  final String id;

  const DetailPage({super.key, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  late final AnimationController _favController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 200), value: 1.0);
  late final AnimationController _bottomSheetController;
  late final TabController _tabController;
  final TextEditingController _reviewController = TextEditingController();
  ScrollController? scrollController = ScrollController();

  bool _expandedTextField = false;

  @override
  void initState() {
    _bottomSheetController = BottomSheet.createAnimationController(this);
    _bottomSheetController.duration = const Duration(milliseconds: 300);
    _bottomSheetController.drive(CurveTween(curve: Curves.easeIn));
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _favController.dispose();
    _bottomSheetController.dispose();
    _tabController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  Widget menus(RestaurantDetailModel restaurantDetail) {
    return SizedBox(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Menus',
          style: Theme.of(context).textTheme.headline6!.copyWith(
              fontSize: 16.0,
              color: Theme.of(context).colorScheme.onBackground),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                _bottomSheetMenu(restaurantDetail.menus.drinks, 'Drinks');
              },
              child: Card(
                  margin: const EdgeInsets.all(8.0),
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  shadowColor: Theme.of(context).colorScheme.secondary,
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.local_cafe,
                          color: Theme.of(context).colorScheme.primary,
                          size: 48.0,
                        ),
                        Text(
                          'Drinks',
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      ],
                    ),
                  )),
            ),
            InkWell(
              onTap: () {
                _bottomSheetMenu(restaurantDetail.menus.foods, 'Foods');
              },
              child: Card(
                  margin: const EdgeInsets.all(8.0),
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  shadowColor: Theme.of(context).colorScheme.secondary,
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.lunch_dining,
                          color: Theme.of(context).colorScheme.primary,
                          size: 48.0,
                        ),
                        Text(
                          'Foods',
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ],
    ));
  }

  Widget reviews() {
    return Consumer<RestaurantDetailProvider>(builder: (context, value, _) {
      Widget child = const SizedBox();
      if (value.submitState == SubmitState.loading) {
        child = Expanded(
            child: ListView.builder(
          controller: scrollController,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const SkeletonLoading(
                  height: 40.0,
                  width: 40.0,
                  radius: 20.0,
                  margin: EdgeInsets.all(0)),
              title: const SkeletonLoading(
                  height: 12.0,
                  width: double.infinity,
                  radius: 4.0,
                  margin: EdgeInsets.all(0)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SkeletonLoading(
                      height: 6.0,
                      width: double.infinity,
                      radius: 4.0,
                      margin: EdgeInsets.only(bottom: 4.0)),
                  SkeletonLoading(
                      height: 6.0,
                      width: double.infinity,
                      radius: 4.0,
                      margin: EdgeInsets.all(0)),
                ],
              ),
              isThreeLine: true,
              horizontalTitleGap: 16.0,
            );
          },
          itemCount: 6,
        ));
      } else {
        if (value.submitState == SubmitState.noData) {
          child = const Center(child: Text('Failed to load data review!'));
        } else {
          final reviews = value.customerReviews;
          child = Expanded(
            child: ListView.builder(
              controller: scrollController,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(
                    Icons.account_circle,
                    color: Theme.of(context).colorScheme.tertiary,
                    size: 40.0,
                  ),
                  title: Text(reviews[index].name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reviews[index].date!,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(reviews[index].review)
                    ],
                  ),
                  isThreeLine: true,
                  horizontalTitleGap: 16.0,
                );
              },
              itemCount: reviews.length,
            ),
          );
        }
      }
      return SizedBox(
        child: Stack(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Reviews',
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontSize: 16.0,
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              const SizedBox(
                height: 12.0,
              ),
              child
            ]),
            Align(
              alignment: Alignment.centerRight,
              child: AnimatedContainer(
                margin:
                    EdgeInsets.only(right: _expandedTextField ? 75.0 : 30.0),
                width: _expandedTextField
                    ? MediaQuery.of(context).size.width - 100
                    : 0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOutSine,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(child: Container()),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: TextFormField(
                          autofocus: false,
                          style: Theme.of(context).textTheme.subtitle1,
                          controller: _reviewController,
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              fillColor: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: _expandedTextField
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondary
                                          : Colors.transparent,
                                      width: 0),
                                  borderRadius: BorderRadius.circular(16.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 2.0),
                                  borderRadius: BorderRadius.circular(16.0)),
                              suffixIcon: IconButton(
                                  onPressed: () async {
                                    CustomerReviewModel dataReview =
                                        CustomerReviewModel(
                                            id: value
                                                .restaurantDetail.restaurant.id,
                                            name: 'Krista',
                                            review: _reviewController.text);

                                    var errorMessage = await Provider.of<
                                                RestaurantDetailProvider>(
                                            context,
                                            listen: false)
                                        .addReview(dataReview);
                                    if (errorMessage == null) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((timeStamp) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text('Review not sent!'),
                                          backgroundColor: Colors.red,
                                        ));
                                      });
                                    } else {
                                      _reviewController.clear();
                                      Future.delayed(
                                          const Duration(milliseconds: 50),
                                          () => scrollController?.animateTo(
                                              scrollController!
                                                  .position.maxScrollExtent,
                                              duration: const Duration(
                                                  microseconds: 400),
                                              curve: Curves.fastOutSlowIn));
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.send,
                                  )),
                              hintText: 'Type review...',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary)),
                        ),
                      ),
                    ]),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _expandedTextField = !_expandedTextField;
                  });
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    fixedSize: const Size(64.0, 64.0),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0))),
                child: AnimatedRotation(
                  curve: Curves.easeInOut,
                  turns: _expandedTextField ? 0.375 : 0,
                  duration: const Duration(microseconds: 500),
                  child: const Icon(
                    Icons.add,
                    size: 32.0,
                    color: whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget description(RestaurantDetailModel restaurantDetail) {
    return SizedBox(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.headline6!.copyWith(
              fontSize: 16.0,
              color: Theme.of(context).colorScheme.onBackground),
        ),
        const SizedBox(
          height: 12.0,
        ),
        Text(
          restaurantDetail.description,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: Theme.of(context).colorScheme.tertiary,
              letterSpacing: 0.2,
              height: 1.3),
        ),
      ]),
    );
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
        body: ChangeNotifierProvider<RestaurantDetailProvider>(
          create: (_) => RestaurantDetailProvider(
              apiService: ApiService(client: http.Client()), id: widget.id),
          child:
              Consumer<RestaurantDetailProvider>(builder: (context, state, _) {
            if (state.state == ResultState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.state == ResultState.hasData) {
              final RestaurantDetailModel restaurantDetail =
                  state.restaurantDetail.restaurant;
              String imageUrl = ApiService(client: http.Client())
                  .imageMediumUrl(restaurantDetail.pictureId);
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    toolbarHeight: 55.0,
                    leading: Container(
                      width: 40.0,
                      height: 40.0,
                      margin: const EdgeInsets.only(top: 16.0, left: 16.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(8.0)),
                      child: IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        onPressed: () {
                          Navigation.back();
                        },
                      ),
                    ),
                    actions: [
                      Consumer<DatabaseProvider>(
                          builder: (context, provider, _) {
                        return FutureBuilder<bool>(
                            future: provider.isFavorite(restaurantDetail.id),
                            builder: (context, AsyncSnapshot snapshot) {
                              var isFav = snapshot.data ?? false;
                              RestaurantListModel restaurant =
                                  RestaurantListModel(
                                      id: restaurantDetail.id,
                                      name: restaurantDetail.name,
                                      description: restaurantDetail.description,
                                      pictureId: restaurantDetail.pictureId,
                                      city: restaurantDetail.city,
                                      rating: restaurantDetail.rating);
                              return Container(
                                margin: const EdgeInsets.only(
                                    top: 16.0, right: 16.0),
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: ScaleTransition(
                                  scale: Tween(begin: 0.7, end: 1.0).animate(
                                      CurvedAnimation(
                                          parent: _favController,
                                          curve: Curves.bounceInOut)),
                                  child: isFav
                                      ? IconButton(
                                          icon: const Icon(
                                            Icons.favorite,
                                            color: Colors.white,
                                          ),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          onPressed: () {
                                            setState(() {
                                              isFav = !isFav;
                                              _favController.reverse().then(
                                                  (value) =>
                                                      _favController.forward());
                                            });
                                            provider.removeFavorite(widget.id);
                                          },
                                        )
                                      : IconButton(
                                          icon: const Icon(
                                            Icons.favorite_border,
                                            color: Colors.white,
                                          ),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          onPressed: () {
                                            setState(() {
                                              isFav = !isFav;
                                              _favController.reverse().then(
                                                  (value) =>
                                                      _favController.forward());
                                            });
                                            provider.addFavorite(restaurant);
                                          },
                                        ),
                                ),
                              );
                            });
                      })
                    ],
                    collapsedHeight: 300.0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Hero(
                        tag: restaurantDetail.pictureId,
                        transitionOnUserGestures: true,
                        child: Material(
                          color: Theme.of(context).colorScheme.background,
                          child: FadeInImage.assetNetwork(
                            image: imageUrl,
                            placeholder: 'assets/default_image.jpg',
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Text(
                                  'Error image!',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              );
                            },
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurantDetail.name,
                            style:
                                Theme.of(context).textTheme.headline5!.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                            overflow: TextOverflow.fade,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          SizedBox(
                            height: 40.0,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children:
                                  restaurantDetail.categories.map((category) {
                                return Card(
                                    margin: const EdgeInsets.all(4.0),
                                    elevation: 0,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    clipBehavior: Clip.none,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 12.0),
                                        child: Text(
                                          category.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        )));
                              }).toList(),
                            ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Row(children: [
                            StarRating(
                                size: 16.0,
                                starCount: 5,
                                rating: restaurantDetail.rating,
                                color: Theme.of(context).colorScheme.primary),
                            const SizedBox(
                              width: 4.0,
                            ),
                            Text(
                              restaurantDetail.rating.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontWeight: semiBold),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              '(${restaurantDetail.customerReviews.length} reviews)',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary),
                            ),
                          ]),
                          const SizedBox(
                            height: 12.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.location_on_outlined,
                                  size: 20.0,
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
                              const SizedBox(
                                width: 4.0,
                              ),
                              Text(
                                '${restaurantDetail.address}, ${restaurantDetail.city}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary),
                                overflow: TextOverflow.fade,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                      child: TabBar(
                          controller: _tabController,
                          labelColor:
                              Theme.of(context).colorScheme.onBackground,
                          unselectedLabelColor:
                              Theme.of(context).colorScheme.tertiary,
                          labelStyle: Theme.of(context).textTheme.bodyText1,
                          tabs: const [
                        Tab(
                          text: 'Menus',
                        ),
                        Tab(
                          text: 'Reviews',
                        ),
                        Tab(
                          text: 'Description',
                        )
                      ])),
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverFillRemaining(
                        hasScrollBody: false,
                        child: SizedBox(
                          height: 500.0,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              menus(restaurantDetail),
                              reviews(),
                              description(restaurantDetail)
                            ],
                          ),
                        )),
                  ),
                ],
              );
            } else if (state.state == ResultState.noData) {
              return const SliverToBoxAdapter(
                child: NoDataWidget(),
              );
            } else if (state.state == ResultState.error) {
              showError('Failed to load restaurant detail!');
            }
            return const Center(child: Text(''));
          }),
        ));
  }

  Future _bottomSheetMenu(List<DrinkAndFood> menus, String title) {
    return showModalBottomSheet(
        transitionAnimationController: _bottomSheetController,
        context: context,
        builder: (builder) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Divider(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(
                          Icons.fastfood,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        title: Text(menus[index].name.toString()),
                        contentPadding: const EdgeInsets.all(4.0),
                      );
                    },
                    itemCount: menus.length,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
