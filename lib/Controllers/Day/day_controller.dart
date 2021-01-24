import 'package:gsheets/gsheets.dart';
import 'package:inno_namaz/resources/callender_orerations.dart';
import 'package:inno_namaz/Models/day_prayers.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

//  google auth credentials
const _credentials = r'''
{
  "type": "service_account",
  "project_id": "innonamaz",
  "private_key_id": "3d334c06bfc4f15ef71640c99799739b83e8c476",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCKel0Jk1gYod+u\nKAQpT4kb2fLmJY3vk0ridpMs4nI0ZBILPMxLtA8sRHfE+p4bsaDkiD0RQJlIYQQW\nAPtnoUtFs4mD0A/eowjor0bV3qC8yWKP8fS4QNTEWk8bcvA+VRbMA4n49s33ZzUE\njNcdtKea7/pxPM1dlewM22DEJ94pjBe64p63HuCr8Gm1s7F8u8awnMZ6idoj07q9\nQD2lPN7BI0FCRyFrO7csmwVOIKL3x8RXam3o6e8fzIrccbcN5ORFXrSbZ3Sie+E+\nDlP0LDRxvjv8cRC0DaE2owi3G76Qw6h//Tzc8K7FrCtWPKDR0+XZGB51QKokQ7Jf\nE5xiMlldAgMBAAECggEAAnVFmC6WDmnhL0A6mAPMv+0l01FbVviwXZtpOroSTj0b\nLOPkDyafwP4TejBQr4Epr/oodgPwNJ60PzJpRApS7GZ8IcDcZ0FRnn/DVsyK4eRZ\nQYuJTTP+vYrfg0c5CII401+aCrdRf1DFBNL92+MhuS2wA7k76VYInfnO7+xylHOH\netS/pxlsLd0VuNdY4Pn9vyR5uaU1ViHTC3PLj3pO3LUg3LgLhemrCongumAjJ/4A\nWUIYolIDeMr7bSYagrzIXJH1ImMiM90ILMTkQJ1M2yEIhL7wFtUPTcu+P3s+ROAw\ng+tblQm+TmIoGK6zMdtIAdweKmdTlldT9s4XKXz46QKBgQDClWAEZWW78pH3vmem\n8M5sUk7oXQoGR8Ng2q3nn7PQKUD0aJS3Eg+qLPZVAKRwALNDOx0JoRQEkCwBdkSe\nEFHpdki184EibfIjoOExQNPivRk+s2y0ZoieGkwb1MqDScUIbe2JzilVV+zVhdfz\nS8Y5taXTnPxsoiGtJz2UVz7tqwKBgQC2L5Ugu/6MA8N4JNVrJ2O7PM57y99o6QMJ\nECih4Z8id+eHkODeG5ZZPVm8t4JRKGlfF1z3VXu9DUDWPmA50GXYn1YreL+bobVN\nuNDHtJ35S3tBjTUtHUtTwb0rQe8kEl+VoWt/6tZ1IMWvRB1oAoBHZP76CthEegJp\nY2U4/Pv9FwKBgQCcYvGIlvXs2Ef4lU85HNDKvlws5Jnp8kNU1GxwfCpIYt+Rj3v2\nps1wODLCnoGKgwWQQzJTSuKLyFOV2TfM0dEDkc1ebxaaVUMG34Ydz7x7vv9LJWl4\nk++5IemJdLxOSDvTSoZe+xK9RK1T7v5gy8XFG/jq2oEFzkjCoYcccgJhgQKBgDTM\na2qWMPoA6Tg7bIJmYvfTcn/cIL31sYSB41Su34CMwVO/f/u+gP8R0ZzojeLZVFhT\nnASuCHNMkPrGDvsSU0HJQ57LmrQO1E1W/2KxDIs//dOMidmuQLNgVWNg814/2OWz\nZ0UmGMrPGZtmoSMQfn6yXVa3p9+IgIRsYtx2LM03AoGAQUqp3iEUPwLPA96+5zX+\n67YvIVct6obq5g0WOnHT85p5FAtRzTeUVIlH7wyaDpP4m49LlQ9qLgvtNpaL0s09\nCDqJ9p5rFOWgsJ/LkkCPyuoaSMWsb2KB3R+VYC4DPmgmurtF6zMedQmtxU30bTIi\n/aQIygCAGe7J1GvwzCYRqLs=\n-----END PRIVATE KEY-----\n",
  "client_email": "innonamaz@innonamaz.iam.gserviceaccount.com",
  "client_id": "108646907338076666252",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/innonamaz%40innonamaz.iam.gserviceaccount.com"
}
''';

// your spreadsheet id
const _spreadsheetId = '1bwKxG1xygQ4dkW2iUzG8xpf0QDvR14dYZkl-zba8r0o';

/// DayController is a class which does work of gat prayers time from Google Sheets
class DayController extends ControllerMVC{
  final GSheets _gsheets = GSheets(_credentials);
  Spreadsheet _spreadsheet;
  Worksheet _productSheet;

  Future<void> init() async {
    _spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
    _productSheet = await _spreadsheet.worksheetById(0);
  }

  /*
  * gte all data from google sheet
  * put the data into the model and return a list of data
  */
  Future<List<DayPrayers>> getAll() async {
    await init();
    final products = await _productSheet.values.map.allRows();
    return products.map((json) => DayPrayers.fromJson(json)).toList();
  }

  /*
  * Choose the right day
  * Compare device date with all dates in the database
  * "NOW" Operation {
                     * return => day from database if the really date equal to the date of any day from the database
                   }
  * "NEXT" Operation{
                     * return =>  if found the Day who next to index['toDay'] in database
                   }
  * "BACK" Operation{
                     * return =>  if found the Day before to index['toDay'] in database

                   }
  */
  DayPrayers toDay(Operations operation , List<DayPrayers> days , [int toDay]) {

    switch(operation){
      case Operations.NOW : {
        for(int x = 0 ; x < days.length ; x++){
          if (days[x].date == DateTime.now().day) {
            return days[x];
          }
        }
      }
      break;
      case Operations.BACK : {
        if (days.contains(days[days.indexWhere((day) => day.date == toDay) - 1])) {
          return days[days.indexWhere((day) => day.date == toDay) - 1];
        }
        return days[days.indexWhere((day) => day.date == toDay)];
      }
      break;
      case Operations.NEXT : {
        if (days.contains(days[days.indexWhere((day) => day.date == toDay) + 1])) {
          return days[days.indexWhere((day) => day.date == toDay) + 1];
        }
        return days[days.indexWhere((day) => day.date == toDay)];
      }
    }


    return DayPrayers(month: DateTime.now().month.toString() , date: DateTime.now().day , prayers: []);
  }

  DateTime formatToDateTime(String time){
    String formattedString = DateFormat('yyyy-MM-dd').format(DateTime.now()) + ' ' + time;
    return DateTime.parse(formattedString);
  }

  String formatToStringTime(DateTime time){
    String str_time  = DateFormat.Hm().format(time);
    return str_time;
  }


}
