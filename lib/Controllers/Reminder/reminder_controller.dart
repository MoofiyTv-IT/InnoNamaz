import 'dart:async';

/*
device time listener, the update is every 1 second .  
*/

class ReminderController{


  DateTime currentTime = DateTime.now();
  Stream<DateTime> getTime() async* {
    DateTime currentTime = DateTime.now();
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield currentTime;
    }
  }

}


