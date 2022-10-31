import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/providers/preferences_provider.dart';
import 'package:resto_app/providers/scheduling_provider.dart';
import 'package:resto_app/common/theme.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = '/settings';
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Hero(
            tag: 'settings',
            transitionOnUserGestures: true,
            child: Material(
              color: Colors.transparent,
              child: Text(
                'Settings',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: whiteColor, fontWeight: semiBold),
              ),
            )),
        elevation: 0,
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Consumer<PreferencesProvider>(builder: (context, provider, _) {
            bool isDark = provider.isDarkTheme;
            return ListView(children: [
              ListTile(
                  title: Text('Theme Setting',
                      style: Theme.of(context).textTheme.subtitle1),
                  subtitle: Text(isDark ? 'Dark theme' : 'Light theme',
                      style: Theme.of(context).textTheme.caption),
                  trailing: GestureDetector(
                    onTap: () {
                      setState(() {
                        isDark = !isDark;
                      });
                      provider.enableDarkTheme(isDark);
                    },
                    child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                        alignment: isDark
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        width: 58.0,
                        height: 32.0,
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer),
                        child: CircleAvatar(
                          backgroundColor: isDark
                              ? Theme.of(context).colorScheme.background
                              : Theme.of(context).colorScheme.primary,
                          child: Icon(
                            isDark ? Icons.dark_mode : Icons.light_mode,
                            color: whiteColor,
                            size: 16.0,
                          ),
                        )),
                  )),
              Consumer<SchedulingProvider>(builder: (context, scheduled, _) {
                bool enableNotification = provider.enableNotification;
                return ListTile(
                  title: Text('Restaurant Notification',
                      style: Theme.of(context).textTheme.subtitle1),
                  subtitle: Text(
                      enableNotification
                          ? 'Enable notification'
                          : 'Disable notification',
                      style: Theme.of(context).textTheme.caption),
                  trailing: GestureDetector(
                    onTap: () {
                      setState(() {
                        enableNotification = !enableNotification;
                      });
                      scheduled.scheduledRestaurant(enableNotification);
                      provider.setEnableNotification(enableNotification);
                    },
                    child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                        alignment: enableNotification
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        width: 58.0,
                        height: 32.0,
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer),
                        child: CircleAvatar(
                          backgroundColor: enableNotification
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).disabledColor,
                          child: Icon(
                            enableNotification
                                ? Icons.notifications_active
                                : Icons.notifications_off,
                            color: whiteColor,
                            size: 16.0,
                          ),
                        )),
                  ),
                );
              }),
            ]);
          })),
    );
  }
}
