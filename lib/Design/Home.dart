/*
*The code contains the design of the main interface in addition to the notification manager in the application,
   *Interface design: All sources, including text, colors, links and paths are found in (Resource Folder) that you can see.
      (intiState) function contains variable definitions and resources for managing notifications in the application, in addition to calling functions to fetch data from Google Sheet.
   *Notification management functions: the last two functions in the file :
      display function and function to check the prayer time to send the logo by calling the display function
*/

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:inno_namaz/Controllers/Athan/athan_controller.dart';
import 'package:inno_namaz/Controllers/Day/day_controller.dart';
import 'package:inno_namaz/Models/day_prayers.dart';
import 'package:inno_namaz/Models/prayer.dart';
import 'package:inno_namaz/resources/callender_orerations.dart';
import 'package:inno_namaz/resources/colors.dart';
import 'package:inno_namaz/resources/fonts.dart';
import 'package:inno_namaz/resources/images.dart';
import 'package:inno_namaz/resources/strings.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/prayer.dart';
import 'AlertDailogs.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DayPrayers _dayPrayers;
  Prayer _nextPrayer = Prayer("", "00:00:00");
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  DateTime now = DateTime.now();
  
  // ignore: non_constant_identifier_names
  var _prayers_notifications_status = {fajer : false , zuhr : false , asr : false , maghrib : false  , isha : false } ;

  @override
  // ignore: must_call_super
  void initState() {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    _getPrayerNotoficationStatus();

    //call get prayers data function
    DayController().getAll().then((result) {
      setState(() {
        _dayPrayers = DayController().toDay(Operations.NOW, result);
        _chooseNextPrayer(_dayPrayers.prayers);
        _reminderNotify(_dayPrayers.prayers, _nextPrayer);

      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*
                prayer Name and time widget
                */
              Container(
                color: black,
                margin:
                    EdgeInsets.only(top: 24, right: 16, left: 16, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        '${_nextPrayer.prayer}\n$prayer',
                        style: TextStyle(
                          color: green,
                          fontFamily: letter_font,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                          fontSize: 50,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        DayController().formatToStringTime(DayController().formatToDateTime(_nextPrayer.start)),
                        style: TextStyle(
                          color: darkYellow,
                          fontFamily: number_font,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /*
               *Calendar widgets
               */
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        color: darkYellow,
                      ),
                      splashColor: yellow54,
                      onPressed: () {
                        DayController().getAll().then((result) {
                          setState(() {
                            _dayPrayers = DayController().toDay(
                                Operations.BACK, result, _dayPrayers.date);
                          });
                        });
                      },
                    ),
                    Text(
                      (_dayPrayers != null)
                          ? '${_dayPrayers.date} ${_dayPrayers.month}'
                          : "",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: number_font,
                        fontSize: 24,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_right,
                        color: darkYellow,
                      ),
                      splashColor: yellow54,
                      onPressed: () {
                        DayController().getAll().then((result) {
                          setState(() {
                            _dayPrayers = DayController().toDay(
                                Operations.NEXT, result, _dayPrayers.date);
                          });
                        });
                      },
                    ),
                  ],
                ),
              ),

              // daily prayers
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 8),
                      width: 400,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(mosque_image),
                          Icon(
                            Icons.watch_later,
                            color: green,
                          ),
                          Icon(
                            Icons.people,
                            color: blue,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.notifications_active,
                              color: darkYellow,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                        height: 230, width: 400, child: _preyersList(context)),
                  ],
                ),
              ),

              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Divider(
                      color: yellow,
                    ),
                    _athenDropDownButton(context),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: yellow,
        splashColor: Colors.black54,
        onPressed: () => productionDailog(context),
        child: Icon(
          Icons.info_outline,
          color: black,
        ),
      ),
      bottomNavigationBar: _buttomNavigationBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  BottomAppBar _buttomNavigationBar(BuildContext context) {
    return BottomAppBar(
      color: darkBlue,
      shape: CircularNotchedRectangle(),
      elevation: 4,
      notchMargin: 6,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                app_name,
                style: TextStyle(
                  color: black,
                  fontFamily: letter_font,
                  fontSize: 24,
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(MdiIcons.github),
                  onPressed: () => joinUsDailog(context),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  /*
  * list of prayers
  * you can show the prayers of the same day you have in you device
  */
  Widget _preyersList(BuildContext context) {
    return ListView.builder(
      itemCount: (_dayPrayers != null && _dayPrayers.prayers.isNotEmpty == true)
          ? _dayPrayers.prayers.length
          : 0,
      itemBuilder: (BuildContext context, int position) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 60,
              child: Text(
                _dayPrayers.prayers[position].prayer,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: letter_font,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              DayController().formatToStringTime(DayController().formatToDateTime(_dayPrayers.prayers[position].start)),
              style: TextStyle(
                color: Colors.white,
                fontFamily: number_font,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Text(
              DayController().formatToStringTime(DayController().formatToDateTime(_dayPrayers.prayers[position].jamaat)),
              style: TextStyle(
                color: Colors.white,
                fontFamily: number_font,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Switch(
              value:(_prayers_notifications_status[_dayPrayers.prayers[position].prayer] != null)? _prayers_notifications_status[_dayPrayers.prayers[position].prayer] : _prayers_notifications_status[_dayPrayers.prayers[position].prayer] = false,
              onChanged: (value) {
                setState((){
                  _changePrayerNotoficationStatus(_dayPrayers.prayers[position].prayer, value);
                });
              },
              activeColor: yellow,
            ),
          ],
        );
      },
    );
  }

  Widget _athenDropDownButton(BuildContext context) {
    String alSheek = al_sheek_maroof;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.headset_mic,
                color: darkYellow,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  reminder_athan_title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: darkBlue,
                    fontFamily: letter_font,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonHideUnderline(
              child: Container(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1.0,
                        style: BorderStyle.solid,
                        color: Colors.deepPurpleAccent),
                  ),
                ),
                child: DropdownButton(
                  style: TextStyle(fontSize: 14, fontFamily: letter_font),
                  dropdownColor: darkBlue,
                  value: alSheek,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                  iconSize: 24,
                  elevation: 16,
                  onChanged: (String athan) {
                    setState(() {
                      alSheek = athan;
                    });
                  },
                  items: athanMap.keys
                      .toList()
                      .map<DropdownMenuItem<String>>((String athan) {
                    return DropdownMenuItem(
                      value: athan,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          athan,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: letter_font,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(
                  Icons.play_circle_filled,
                  color: blue,
                ),
                onPressed: () => AthanController().playAthan(),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.pause_circle_filled,
                color: blue,
              ),
              onPressed: () => AthanController().stopeAthan(),
            ),
          ],
        ),
      ],
    );
  }

  //notification Display function

  Future<void> showNotification(Prayer prayer) async {
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID 4',
      'CHANNEL_NAME 4',
      "CHANNEL_DESCRIPTION 4",
      importance: Importance.Max,
      priority: Priority.High,
      playSound: true,
      sound:
          RawResourceAndroidNotificationSound(normal_athan_notification_sound),
    );
    var iosChannelSpecifics = IOSNotificationDetails(
      sound: "$normal_athan_notification_sound.aiff",
    );
    var platformChannelSpecifics =
        NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);

    if (_prayers_notifications_status[prayer.prayer]) {
      await flutterLocalNotificationsPlugin.show(
        0,
        prayer.prayer,
        time_for_prayer + " " + prayer.prayer,
        platformChannelSpecifics,
        payload: time_for_prayer,
      );
    }
  }

  /*
  The function of checking the prayer time by listening on the device’s time ,
  and checking if one of the five daily prayers has arrived with the display function calling in case the condition is met.
  */
  

  _reminderNotify(List<Prayer> prayers, Prayer nextPrayer) async {
    Stream<DateTime> timer = Stream.periodic(Duration(seconds: 1), (i) {
      now = now.add(Duration(seconds: 1));
      return now;
    });
     timer.listen((time) {
      prayers.forEach((prayer) {
        if (prayer.start == DateFormat.Hms().format(time)) {
          showNotification(prayer).then((_){
            setState(() {
                  _nextPrayer = (prayers.indexOf(prayer) != prayers.length -1 ) ? prayers[prayers.indexOf(prayer) + 1] : prayers.first;
                });
          });
        }
      });
    });
  }

  /*
  The function of choosing the next prayer by listening on the device’s time ,
  and checking if one of the five daily prayers is the next .
  */
  _chooseNextPrayer(List<Prayer> prayers) async{
    StreamSubscription<DateTime> _chooseNextPrayerSubscription;
    Stream<DateTime> timer = Stream.periodic(Duration(seconds: 1), (i) {
      now = now.add(Duration(seconds: 1));
      return now;
    });
      _chooseNextPrayerSubscription = timer.listen((time) {
      for (int x = 0; x < prayers.length; x++) {
        switch (x) {
          case 0:
            {
              if ((time.isBefore(DayController().formatToDateTime(prayers[x].start))) &&(time.isAfter(DayController().formatToDateTime(prayers.last.start)))){
                setState(() {
                  _nextPrayer = prayers[x];
                _chooseNextPrayerSubscription.cancel();
                });
              }
                
            }
            break;
          default:
            {
              if ((time.isBefore(DayController().formatToDateTime(prayers[x].start))) && (time.isAfter(DayController().formatToDateTime(prayers[x - 1].start)))){
                setState(() {
                  _nextPrayer = prayers[x];
                _chooseNextPrayerSubscription.cancel();
                });
              }
            }
        }
      }
    });
  }

  //change an value into the
  void _changePrayerNotoficationStatus(String key , bool keyValue)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, keyValue);
    setState(() {
      _prayers_notifications_status[key]= keyValue;
    });
  }

  //get data from the device datafile and push it into the map
  void _getPrayerNotoficationStatus() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _prayers_notifications_status.keys.forEach((key) {
      _prayers_notifications_status[key] = prefs.getBool(key) ?? false;
    });
  }
}
