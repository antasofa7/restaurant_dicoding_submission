import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/pages/detail_page.dart';
import 'package:resto_app/pages/favorite_page.dart';
import 'package:resto_app/pages/profile_page.dart';
import 'package:resto_app/pages/restaurant_page.dart';
import 'package:resto_app/providers/connectivity_provider.dart';
import 'package:resto_app/common/theme.dart';
import 'package:resto_app/utils/background_service.dart';
import 'package:resto_app/utils/notification_helper.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final List<Widget> _listWidget = [
  const RestaurantPage(),
  const FavoritePage(),
  const ProfilePage()
];

class _HomePageState extends State<HomePage> {
  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  int bottomNavIndex = 0;

  @override
  void initState() {
    port.listen((_) async => await _service.someTask());
    _notificationHelper
        .configurationSelectNotificationSubject(DetailPage.routeName);
    super.initState();
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = Provider.of<ConnectivityProvider>(context).isOnline;
    var bottomNavBarItems = [
      _bottomNavBarItem(context, Icons.restaurant_menu, 'Restaurant', 0),
      _bottomNavBarItem(context, Icons.favorite, 'Favorite', 1),
      _bottomNavBarItem(context, Icons.person, 'Profile', 2),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: isOnline
          ? _listWidget[bottomNavIndex]
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/no-connection-amico.png',
                      width: MediaQuery.of(context).size.width / 1.4),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Text(
                    'Please check your internet connection!',
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ],
              )),
            ),
      bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Theme.of(context).colorScheme.tertiaryContainer),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
            elevation: 0,
            currentIndex: bottomNavIndex,
            items: bottomNavBarItems,
            showSelectedLabels: false,
            enableFeedback: true,
            onTap: (selected) {
              setState(() {
                bottomNavIndex = selected;
              });
            },
          )),
    );
  }

  BottomNavigationBarItem _bottomNavBarItem(
      BuildContext context, icon, String label, int index) {
    return BottomNavigationBarItem(
      label: '',
      icon: Icon(
        icon,
        color: Theme.of(context).colorScheme.tertiary,
      ),
      activeIcon: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          width: (MediaQuery.of(context).size.width / 3) + 8,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(30.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: whiteColor,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: whiteColor, fontSize: 12.0, fontWeight: semiBold),
                ),
              )
            ],
          )),
    );
  }
}
