import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/common/navigation.dart';
import 'package:resto_app/data/api/api_service.dart';
import 'package:resto_app/data/models/restaurant_list_model.dart';
import 'package:resto_app/pages/detail_page.dart';
import 'package:resto_app/providers/database_provider.dart';
import 'package:resto_app/common/theme.dart';
import 'package:resto_app/widgets/star_rating.dart';
import 'package:http/http.dart' as http;

class TopRatedRestaurant extends StatefulWidget {
  final RestaurantListModel restaurant;
  final int index;
  final int itemCount;

  const TopRatedRestaurant(BuildContext context,
      {super.key,
      required this.restaurant,
      required this.index,
      required this.itemCount});

  @override
  State<TopRatedRestaurant> createState() => _TopRatedRestaurantState();
}

class _TopRatedRestaurantState extends State<TopRatedRestaurant>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 200), value: 1.0);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = ApiService(client: http.Client())
        .imageMediumUrl(widget.restaurant.pictureId);
    return Consumer<DatabaseProvider>(builder: (context, provider, _) {
      return FutureBuilder<bool>(
          future: provider.isFavorite(widget.restaurant.id),
          builder: (context, AsyncSnapshot snapshot) {
            var isFav = snapshot.data ?? false;
            return GestureDetector(
              onTap: () {
                Navigation.intentWithData(
                    DetailPage.routeName, widget.restaurant.id);
              },
              child: Container(
                margin: EdgeInsets.only(
                    left: 16.0,
                    right: widget.index == widget.itemCount - 1 ? 16.0 : 0),
                height: 220.0,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(16.0)),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0)),
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
                        width: MediaQuery.of(context).size.width - 48.0,
                        height: 160.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 48.0,
                      height: 160.0,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.5)
                              ]),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0, vertical: 2.0),
                                margin: const EdgeInsets.only(right: 4.0),
                                decoration: ShapeDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0))),
                                child: Text(
                                  widget.restaurant.rating.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                              StarRating(
                                  size: 20.0,
                                  starCount: 5,
                                  rating: widget.restaurant.rating,
                                  color: Theme.of(context).colorScheme.primary),
                              const SizedBox(
                                width: 8.0,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.restaurant.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(fontWeight: bold),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Theme.of(context).colorScheme.tertiary,
                                  size: 16.0,
                                ),
                                const SizedBox(
                                  width: 4.0,
                                ),
                                Text(
                                  widget.restaurant.city,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(fontWeight: medium),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 16.0,
                      bottom: 40,
                      child: Container(
                          key: const Key('favoriteButton'),
                          width: 48.0,
                          height: 48.0,
                          decoration: ShapeDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: const CircleBorder()),
                          padding: const EdgeInsets.all(0),
                          child: ScaleTransition(
                            scale: Tween(begin: 0.7, end: 1.0).animate(
                                CurvedAnimation(
                                    parent: _controller,
                                    curve: Curves.bounceInOut)),
                            child: isFav
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                    ),
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    onPressed: () {
                                      setState(() {
                                        isFav = !isFav;
                                        _controller.reverse().then(
                                            (value) => _controller.forward());
                                      });
                                      provider
                                          .removeFavorite(widget.restaurant.id);
                                    },
                                  )
                                : IconButton(
                                    icon: const Icon(
                                      Icons.favorite_border,
                                      color: Colors.white,
                                    ),
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    onPressed: () {
                                      setState(() {
                                        isFav = !isFav;
                                        _controller.reverse().then(
                                            (value) => _controller.forward());
                                      });
                                      provider.addFavorite(widget.restaurant);
                                    },
                                  ),
                          )),
                    )
                  ],
                ),
              ),
            );
          });
    });
  }
}
