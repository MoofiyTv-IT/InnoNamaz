import 'package:inno_namaz/Models/prayer.dart';
import 'package:inno_namaz/resources/strings.dart';

class DayPrayers {
  int date;
  String month;
  List<Prayer> prayers = new List();
  DayPrayers({this.month , this.date, this.prayers});

  factory DayPrayers.fromJson(Map<String , dynamic> json) {
    return DayPrayers(
      month: json['Month'],
      date: int.tryParse(json['Date']),
      prayers: [Prayer(fajer, json['StartFajr'] , json['Jama\'atFajr'] , false) , Prayer(zuhr, json['StartZuhr'] , json['Jama\'atZuhr'] , false) , Prayer(asr, json['StartAsr'] , json['Jama\'atAsr'] , false) , Prayer(maghrib, json['Strt&JmtMaghrib'] , json['Strt&JmtMaghrib'] , false ) , Prayer(isha, json['StartIsha'] , json['Jama\'atIsha'] , false)],
    );
  }
}
