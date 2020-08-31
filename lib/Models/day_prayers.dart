import 'package:inno_namaz/Models/prayer.dart';

class DayPrayers {
  int date;
  String month;
  List<Prayer> prayers = new List();
  DayPrayers({this.month , this.date, this.prayers});

  factory DayPrayers.fromJson(Map<String , dynamic> json) {
    return DayPrayers(
      month: json['Month'],
      date: int.tryParse(json['Date']),
      prayers: [Prayer("fajr", json['StartFajr'] , json['Jama\'atFajr']) , Prayer("zuhr", json['StartZuhr'] , json['Jama\'atZuhr']) , Prayer("asr", json['StartAsr'] , json['Jama\'atAsr']) , Prayer("maghrib", json['Strt&JmtMaghrib'] , json['Strt&JmtMaghrib']) , Prayer("isha", json['StartIsha'] , json['Jama\'atIsha'])],
    );
  }
}
