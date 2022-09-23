import 'package:flutter/material.dart';
import 'package:resto_app/pages/favorite_page.dart';
import 'package:resto_app/pages/profile_page.dart';
import 'package:resto_app/pages/restaurant_page.dart';
import 'package:resto_app/theme.dart';

class HomePage extends StatefulWidget {
  static const String routename = '/home';
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
  int bottomNavIndex = 0;
  @override
  Widget build(BuildContext context) {
    var bottomNavBarItems = [
      _bottomNavBarItem(context, Icons.restaurant_menu, 'Restaurant', 0),
      _bottomNavBarItem(context, Icons.favorite, 'Favorite', 1),
      _bottomNavBarItem(context, Icons.person, 'Profile', 2),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: _listWidget[bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        elevation: 0,
        backgroundColor: Colors.white,
        currentIndex: bottomNavIndex,
        items: bottomNavBarItems,
        showSelectedLabels: false,
        enableFeedback: true,
        onTap: (selected) {
          setState(() {
            bottomNavIndex = selected;
          });
        },
      ),
    );
  }

  BottomNavigationBarItem _bottomNavBarItem(
      BuildContext context, icon, String label, int index) {
    return BottomNavigationBarItem(
      backgroundColor: Colors.white,
      label: '',
      icon: Icon(
        icon,
        color: Colors.grey,
      ),
      activeIcon: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          width: (MediaQuery.of(context).size.width / 3) + 8,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(30.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12.0,
                      fontWeight: semiBold),
                ),
              )
            ],
          )),
    );
  }
}
