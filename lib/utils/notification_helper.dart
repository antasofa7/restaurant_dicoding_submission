import 'dart:convert';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:resto_app/common/navigation.dart';
import 'package:resto_app/data/models/restaurant_list_model.dart';
import 'package:rxdart/subjects.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;
  Random random = Random();

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = const DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true);

    var initializationSettings = InitializationSettings(
        android: initializationSettingAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) async {
        final payload = details.payload;
        if (payload != null) {
          print('notificaton payload: $payload');
        }

        selectNotificationSubject.add(payload ?? 'empty payload');
      },
    );
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      RestaurantList restaurantList) async {
    int randomIndex = random.nextInt(restaurantList.count - 1) + 1;
    var channelId = '1';
    var channelName = 'channel_01';
    var channerDescription = 'restaurant channel';

    var androidPlatformChannelSpesifics = AndroidNotificationDetails(
        channelId, channelName,
        channelDescription: channerDescription,
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: const DefaultStyleInformation(true, true));

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpesifics);

    var titleNotification = '<b>Recommendation Restaurant For You!</b>';
    var titleRestaurant = restaurantList.restaurants[randomIndex].name;
    var payload = {'id': restaurantList.restaurants[randomIndex].id};

    await flutterLocalNotificationsPlugin.show(
        0, titleNotification, titleRestaurant, platformChannelSpecifics,
        payload: jsonEncode(payload));
  }

  void configurationSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen((String payload) async {
      var data = jsonDecode(payload);
      Navigation.intentWithData(route, data['id']);
    });
  }
}
