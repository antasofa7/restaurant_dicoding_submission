import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/common/navigation.dart';
import 'package:resto_app/data/api/api_service.dart';
import 'package:resto_app/data/models/restaurant_list_model.dart';
import 'package:resto_app/pages/detail_page.dart';
import 'package:resto_app/providers/database_provider.dart';
import 'package:resto_app/common/theme.dart';
import 'package:http/http.dart' as http;

class RestaurantTile extends StatefulWidget {
  final RestaurantListModel restaurant;
  const RestaurantTile(BuildContext context,
      {super.key, required this.restaurant});

  @override
  State<RestaurantTile> createState() => _RestaurantTileState();
}

class _RestaurantTileState extends State<RestaurantTile>
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
                child: Hero(
                    tag: widget.restaurant.pictureId,
                    transitionOnUserGestures: true,
                    child: Material(
                      color: Theme.of(context).colorScheme.background,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: FadeInImage.assetNetwork(
                                image: imageUrl,
                                placeholder: 'assets/default_image.jpg',
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Center(
                                    child: Text(
                                      'Error image!',
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  );
                                },
                                width: double.infinity,
                                height: 180.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 180.0,
                              padding: const EdgeInsets.only(
                                  top: 8.0,
                                  right: 16.0,
                                  bottom: 16.0,
                                  left: 16.0),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7)
                                      ]),
                                  borderRadius: BorderRadius.circular(16.0)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  ScaleTransition(
                                    scale: Tween(begin: 0.7, end: 1.0).animate(
                                        CurvedAnimation(
                                            parent: _controller,
                                            curve: Curves.bounceInOut)),
                                    child: isFav
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.favorite,
                                              size: 28,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            onPressed: () {
                                              setState(() {
                                                isFav = !isFav;
                                                _controller.reverse().then(
                                                    (value) =>
                                                        _controller.forward());
                                              });
                                              provider.removeFavorite(
                                                  widget.restaurant.id);
                                            },
                                          )
                                        : IconButton(
                                            icon: Icon(
                                              Icons.favorite_border,
                                              size: 28,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            onPressed: () {
                                              setState(() {
                                                isFav = !isFav;
                                                _controller.reverse().then(
                                                    (value) =>
                                                        _controller.forward());
                                              });
                                              provider.addFavorite(
                                                  widget.restaurant);
                                            },
                                          ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.restaurant.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .copyWith(color: whiteColor),
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                color: whiteColor,
                                              ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              Text(
                                                widget.restaurant.city,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1!
                                                    .copyWith(
                                                        color: whiteColor),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          const SizedBox(
                                            width: 8.0,
                                          ),
                                          Text(
                                            widget.restaurant.rating.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )));
          });
    });
  }
}
