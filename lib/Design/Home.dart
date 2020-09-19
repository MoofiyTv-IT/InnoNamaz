


/*
*The code contains the design of the main interface in addition to the notification manager in the application,
   *Interface design: All sources, including text, colors, links and paths are found in (Resource Folder) that you can see.
      (intiState) function contains variable definitions and resources for managing notifications in the application, in addition to calling functions to fetch data from Google Sheet.
   *Notification management functions: the last two functions in the file :
      display function and function to check the prayer time to send the logo by calling the display function
*/

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

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DayPrayers _dayPrayers;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    //call get prayers data function
    DayController().getAll().then((result) {
      setState(() {
        _dayPrayers = DayController().toDay(Operations.NOW, result);

        _reminderNotify(_dayPrayers.prayers);
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
                        'Fajer\n$prayer',
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
                        '1:30',
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
        onPressed: () {},
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
                  icon: Image.asset(githube_image,width: 24,height: 24,),
                  onPressed: () {},
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
                '${_dayPrayers.prayers[position].prayer}',
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
              '${_dayPrayers.prayers[position].start}',
              style: TextStyle(
                color: Colors.white,
                fontFamily: number_font,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Text(
              '${_dayPrayers.prayers[position].jamaat}',
              style: TextStyle(
                color: Colors.white,
                fontFamily: number_font,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Switch(
              value: _dayPrayers.prayers[position].notification,
              onChanged: (value) {
                setState(() {
                  _dayPrayers.prayers[position].setNotification(value);
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

    if (prayer.notification) {
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
  _reminderNotify(List<Prayer> prayers) async {
    DateTime current = DateTime.now();
    Stream<DateTime> timer = Stream.periodic(Duration(seconds: 1), (i) {
      current = current.add(Duration(seconds: 1));
      return current;
    });
    timer.listen((time) {
      prayers.forEach((prayer) {
        if (prayer.start == '${time.hour}:${time.minute}:${time.second}') {
          showNotification(prayer);
        }
      });
    });
  }
}
