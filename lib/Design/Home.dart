import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
                margin:
                    EdgeInsets.only(top: 24, right: 16, left: 16, bottom: 16),
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
                          Image.asset('images/mosque.png'),
                          Icon(
                            Icons.watch_later,
                            color: colors.green,
                          ),
                          Icon(
                            Icons.people,
                            color: colors.blue,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.notifications_active,
                              color: colors.darkYellow,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: colors.yellow,
        onPressed: (){},
        child: Icon(
          Icons.image,
          color: colors.black,
        ),
      ),
      bottomNavigationBar: _buttomNavigationBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  BottomAppBar _buttomNavigationBar(BuildContext context) {
    return BottomAppBar(
      color: colors.darkBlue,
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
                'InnoNamaz',
                style: TextStyle(
                  color: colors.black,
                  fontFamily: 'ABeeZee',
                  fontSize: 24,
                ),
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
              width: 70,
              child: Text(
                '${_dayPrayers.prayers[position].prayer}',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'ABeeZee',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
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
    String alSheek = "Al Sheek Maroof"; // fortesting

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
                color: colors.darkYellow,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  'Azan to use in reminder',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.darkBlue,
                    fontFamily: 'ABeeZee',
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
                  style: TextStyle(fontSize: 14, fontFamily: 'ABeeZee'),
                  dropdownColor: colors.darkBlue,
                  value: alSheek,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                  iconSize: 24,
                  elevation: 16,
                  onChanged: (String athan) {
                    setState(() {
                      alSheek = athan;
                    });
                  },
                  items: ["Al Sheek Maroof"]
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
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(
                  Icons.play_circle_filled,
                  color: colors.blue,
                ),
                onPressed: () => AthanController().playAthan("normal"),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.pause_circle_filled,
                color: colors.blue,
              ),
              onPressed: () => AthanController().stopeAthan(),
            ),
          ],
        ),
      ],
    );
  }
}
