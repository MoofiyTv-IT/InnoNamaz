import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:inno_namaz/Models/day_prayers.dart';
import 'package:inno_namaz/resources/strings.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'dart:io' show Platform;
import 'package:rxdart/subjects.dart';
import 'package:characters/characters.dart';


/*
This is a class for managing notifications. 
All settings have been adjusted appropriately, 
in addition to the addition of the athan in the resources in the Android project file.
The daily notifications were set 5 times according to the times of the five daily prayers(showDailyAtTime function).
*/


class NotificationPlugin extends ControllerMVC{
  //
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final BehaviorSubject<ReceivedNotification>
      didReceivedLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  var initializationSettings;

  NotificationPlugin._() {
    init();
  }

  init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    initializePlatformSpecifics();
  }

  initializePlatformSpecifics() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_notf_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        ReceivedNotification receivedNotification = ReceivedNotification(
            id: id, title: title, body: body, payload: payload);
        didReceivedLocalNotificationSubject.add(receivedNotification);
      },
    );

    initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
  }

  _requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: false,
          badge: true,
          sound: true,
        );
  }

  setListenerForLowerVersions(Function onNotificationInLowerVersions) {
    didReceivedLocalNotificationSubject.listen((receivedNotification) {
      onNotificationInLowerVersions(receivedNotification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      onNotificationClick(payload);
    });
  }

  Future<void> showDailyAtTime(DayPrayers dayPrayers) async {
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID 4',
      'CHANNEL_NAME 4',
      "CHANNEL_DESCRIPTION 4",
      importance: Importance.Max,
      priority: Priority.High,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(normal_athan_notification_sound),
    );
    var iosChannelSpecifics = IOSNotificationDetails(
      sound: "$normal_athan_notification_sound.aiff",
    );
    var platformChannelSpecifics = NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);

    if(dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == fajer)].notification)
      await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == fajer)].prayer,
        time_for_prayer + " " + dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == fajer)].prayer,
        Time(int.parse(Characters(dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == fajer)].start).elementAt(0) + Characters(dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == fajer)].start).elementAt(1)) , int.parse(Characters(dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == fajer)].start).elementAt(3) + Characters(dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == fajer)].start).elementAt(4))),
        platformChannelSpecifics,
        payload: 'Test Payload',
      );

    if(dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == zuhr)].notification)
      await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == zuhr)].prayer,
        time_for_prayer + " " + dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == zuhr)].prayer,
        Time(int.parse(Characters(dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == zuhr)].start).elementAt(0) + Characters(dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == zuhr)].start).elementAt(1)) , int.parse(Characters(dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == zuhr)].start).elementAt(3) + Characters(dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == zuhr)].start).elementAt(4))),
        platformChannelSpecifics,
        payload: 'Test Payload',
      );

    if(dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == asr)].notification)
      await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == asr)].prayer,
        time_for_prayer + " " + dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == asr)].prayer,
        Time(int.parse(Characters(dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == asr)].start).elementAt(0) + Characters(dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == asr)].start).elementAt(1)) , int.parse(Characters(dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == asr)].start).elementAt(3) + Characters(dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == asr)].start).elementAt(4))),
        platformChannelSpecifics,
        payload: 'Test Payload',
      );

    if(dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == maghrib)].notification)
      await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == maghrib)].prayer,
        time_for_prayer + " " + dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == maghrib)].prayer,
        Time(int.parse(Characters(dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == maghrib)].start).elementAt(0) + Characters(dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == maghrib)].start).elementAt(1)) , int.parse(Characters(dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == maghrib)].start).elementAt(3) + Characters(dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == maghrib)].start).elementAt(4))),
        platformChannelSpecifics,
        payload: 'Test Payload',
      );

    if(dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == isha)].notification)
      await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == isha)].prayer,
        time_for_prayer + " " + dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == isha)].prayer,
        Time(int.parse(Characters(dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == isha)].start).elementAt(0) + Characters(dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == isha)].start).elementAt(1)) , int.parse(Characters(dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == isha)].start).elementAt(3) + Characters(dayPrayers.prayers[dayPrayers.prayers.indexWhere((prayer) => prayer.prayer == isha)].start).elementAt(4))),
        platformChannelSpecifics,
        payload: 'Test Payload',
      );

  }

  Future<int> getPendingNotificationCount() async {
    List<PendingNotificationRequest> p =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return p.length;
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

NotificationPlugin notificationPlugin = NotificationPlugin._();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

