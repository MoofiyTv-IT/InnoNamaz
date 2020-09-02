import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inno_namaz/Controllers/Athen/athan_controller.dart';
import 'package:inno_namaz/Controllers/Day/callender_orerations.dart';
import 'package:inno_namaz/Controllers/Day/day_controller.dart';
import 'package:inno_namaz/Models/day_prayers.dart';

import 'Utils/colors.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  DayPrayers _dayPrayers;
  //colors
  AppColors colors = new AppColors();

  //testing variables
  bool onC = false;

  @override
  void initState() {
    DayController().getAll().then((result) {
      setState(() {
        _dayPrayers = DayController().toDay(Operations.NOW, result);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.black,
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*
                prayer Name and time widget
                */
              Container(
                color: colors.black,
                margin: EdgeInsets.symmetric(vertical: 40, horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        'Fajer\nPrayer',
                        style: TextStyle(
                          color: colors.green,
                          fontFamily: 'ABeeZee',
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
                          color: colors.darkYellow,
                          fontFamily: 'Raleway',
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
               *Callender widgets
               */
              Container(
                color: colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        color: colors.darkYellow,
                      ),
                      onPressed: () {
                        DayController().getAll().then((result) {
                          setState(() {
                            _dayPrayers = DayController()
                                .toDay(Operations.BACK, result, _dayPrayers.date);
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
                        fontFamily: 'Raleway',
                        fontSize: 24,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_right,
                        color: colors.darkYellow,
                      ),
                      onPressed: () {
                        DayController().getAll().then((result) {
                          setState(() {
                            _dayPrayers = DayController()
                                .toDay(Operations.NEXT, result, _dayPrayers.date);
                          });
                        });
                      },
                    ),
                  ],
                ),
              ),

              // daily prayers
              Container(
                color: colors.black,
                margin: EdgeInsets.symmetric(
                  vertical: 40,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 400,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset('images/mosque.png'),
                          Icon(
                            Icons.watch_later_outlined,
                            color: colors.green,
                          ),
                          Icon(
                            Icons.people,
                            color: colors.blue,
                          ),
                          Icon(
                            Icons.notifications_active,
                            color: colors.darkYellow,
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
                      color: colors.yellow,
                    ),
                    _athenDropDownButton(context),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _buttomNavigationBar(context),
    );
  }

  Widget _buttomNavigationBar(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            color: colors.darkBlue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'InnoNamaz',
                  style: TextStyle(
                    color: colors.black,
                    fontFamily: 'Raleway',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Image.asset('images/youtube.png'),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Image.asset('images/githube.png'),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Image.asset('images/setting.png'),
                      onPressed: () {},
                    )
                  ],
                )
              ],
            ),
          ),
          FlatButton(
            padding: EdgeInsets.only(bottom: 20.0),
            onPressed: () {},
            child: CircleAvatar(
              radius: 30,
              backgroundColor: colors.black,
              child: CircleAvatar(
                radius: 25,
                backgroundColor: colors.yellow,
                child: Icon(
                  Icons.image_outlined,
                  color: colors.black,
                ),
              ),
            ),
          )
        ],
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              '${_dayPrayers.prayers[position].prayer}',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'ABeeZee',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              '${_dayPrayers.prayers[position].start}',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Raleway',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              '${_dayPrayers.prayers[position].jamaat}',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Raleway',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Switch(
              value: onC,
              onChanged: (value) {
                setState(() {
                  onC = value;
                });
              },
              activeColor: colors.yellow,
            ),
          ],
        );
      },
    );
  }

  Widget _athenDropDownButton(BuildContext context) {

    String alSheek = "Al Sheek Maroof";// fortesting


    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.headset_mic,
              color: colors.darkYellow,
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Athen To USe In Reminder',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors.darkBlue,
                  fontFamily: 'ABeeZee',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
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
                  value: alSheek,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                  iconSize: 24,
                  elevation: 16,
                  onChanged: (String athan) {
                    setState(() {
                      alSheek = athan;
                    });
                  },
                  items: ["Al Sheek Maroof" ]
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
                            fontFamily: 'ABeeZee',
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            IconButton(icon : Icon(Icons.play_circle_filled , color: colors.blue,) , onPressed: () => AthanController().playAthan("normal"),),
            IconButton(icon : Icon(Icons.pause_circle_filled , color: colors.blue,) , onPressed: ()=> AthanController().stopeAthan(), ),
          ],
        ),
      ],
    );
  }
}
