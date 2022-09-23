import 'package:flutter/material.dart';
import 'package:resto_app/data/model/restaurant.dart';

class DetailPage extends StatefulWidget {
  static const routeName = '/detail';

  final RestaurantModel restaurant;
  const DetailPage({
    super.key,
    required this.restaurant,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  late final AnimationController _favController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 200), value: 1.0);
  late final AnimationController _bottomSheetController;

  bool _isFav = false;
  bool _expandedText = false;

  @override
  void initState() {
    _bottomSheetController = BottomSheet.createAnimationController(this);
    _bottomSheetController.duration = const Duration(milliseconds: 300);
    _bottomSheetController.drive(CurveTween(curve: Curves.easeIn));
    super.initState();
  }

  @override
  void dispose() {
    _favController.dispose();
    _bottomSheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              toolbarHeight: 55.0,
              leadingWidth: 55,
              leading: Container(
                margin: const EdgeInsets.only(top: 16.0, left: 16.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0)),
                child: IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(top: 16.0, right: 16.0),
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                      color: _isFav
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: IconButton(
                    icon: ScaleTransition(
                        scale: Tween(begin: 0.7, end: 1.0).animate(
                            CurvedAnimation(
                                parent: _favController,
                                curve: Curves.bounceInOut)),
                        child: Icon(
                          Icons.favorite_outline,
                          color: _isFav
                              ? Colors.white
                              : Theme.of(context).colorScheme.primary,
                        )),
                    onPressed: () {
                      setState(() {
                        _isFav = !_isFav;
                        _favController
                            .reverse()
                            .then((value) => _favController.forward());
                      });
                    },
                  ),
                ),
              ],
              collapsedHeight: 300.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: widget.restaurant.pictureId,
                  transitionOnUserGestures: true,
                  child: Material(
                    color: Theme.of(context).colorScheme.background,
                    child: FadeInImage.assetNetwork(
                      image: widget.restaurant.pictureId,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.restaurant.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(
                                      color: Colors.black,
                                    ),
                                overflow: TextOverflow.fade,
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined,
                                          size: 20.0, color: Colors.grey),
                                      const SizedBox(
                                        width: 4.0,
                                      ),
                                      Text(
                                        widget.restaurant.city,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2.0),
                            child: Row(children: [
                              Icon(Icons.star_border_rounded,
                                  size: 20.0,
                                  color: Theme.of(context).colorScheme.primary),
                              const SizedBox(
                                width: 4.0,
                              ),
                              Text(
                                widget.restaurant.rating.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                              ),
                            ]),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    Text(
                      'Menus',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontSize: 16.0, color: Colors.black),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            _bottomSheetMenu(widget.restaurant.menus.drinks);
                          },
                          child: Card(
                              margin: const EdgeInsets.all(8.0),
                              shadowColor:
                                  Theme.of(context).colorScheme.primary,
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
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 48.0,
                                    ),
                                    Text(
                                      'Drinks',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    )
                                  ],
                                ),
                              )),
                        ),
                        InkWell(
                          onTap: () {
                            _bottomSheetMenu(widget.restaurant.menus.foods);
                          },
                          child: Card(
                              margin: const EdgeInsets.all(8.0),
                              shadowColor:
                                  Theme.of(context).colorScheme.primary,
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
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 48.0,
                                    ),
                                    Text(
                                      'Foods',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    )
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    Text(
                      'Description',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontSize: 16.0, color: Colors.black),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    AnimatedSize(
                      curve: Curves.easeIn,
                      duration: const Duration(microseconds: 800),
                      child: ConstrainedBox(
                        constraints: _expandedText
                            ? const BoxConstraints()
                            : const BoxConstraints(maxHeight: 100),
                        child: Stack(
                          children: [
                            Text(
                              widget.restaurant.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      color: Colors.grey,
                                      letterSpacing: 0.2,
                                      height: 1.3),
                              overflow: TextOverflow.fade,
                            ),
                            _expandedText
                                ? const SizedBox()
                                : Container(
                                    width: double.infinity,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            const Color.fromARGB(
                                                0, 255, 255, 255),
                                            const Color.fromARGB(
                                                0, 255, 255, 255),
                                            Theme.of(context)
                                                .colorScheme
                                                .background
                                          ]),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _expandedText = !_expandedText;
                          });
                        },
                        icon: Icon(_expandedText
                            ? Icons.expand_less
                            : Icons.expand_more),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Future _bottomSheetMenu(menus) {
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
                  menus == widget.restaurant.menus.foods ? 'Foods' : 'Drinks',
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
                        leading: const Icon(
                          Icons.fastfood,
                          color: Colors.grey,
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
