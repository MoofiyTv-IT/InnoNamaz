import 'package:gsheets/gsheets.dart';
import 'package:inno_namaz/Controllers/Reminder/reminder_controller.dart';
import 'package:inno_namaz/resources/callender_orerations.dart';
import 'package:inno_namaz/Models/day_prayers.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

//  google auth credentials
const _credentials = r'''
{
  "type": "service_account",
  "project_id": "learnflutter-286314",
  "private_key_id": "77a75e2c0b78bb311e83981d0e671d1d599123f1",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDAKMwq1Yim5tXA\nZRP+81n2AWCH44bxKgAm1UCG1LbJ02B9Q253w9sQUBF4KyekYp/z/GvC8mOb57dV\nhTGPUYJ2E54/hu0c5BPKu9SmcdAhOcOSlRFpSERqcAc8HrGp6NfmOGhw4T9GKH26\ncJY+SqTIlpx8eiae1IZlcKUAvlSCJXV8HJ4MC6XaTzFioXp1Bbfr9LGLnP/0483m\nTsAMiKyGKfj9XuCRgjZ2jBUy21eY8Tw8kMaSILn1tkz+OItpcg1LkevUkgICT/wI\nnQQ7ZvhI0GpmT9uuMZ/hGx22hts6qvciD+fQ7Dc1og4hVYcdAkfz0c3xYukvM22a\nx/xavRv3AgMBAAECggEAFVLRqTUt51t5P9LXn7SQeJCZjirM+CkRgD2s3elv6UCY\nFf5sHUUyI4LHFX8wdHjvSAtsR+NO82eIvCg+IinI4OJ3bpRB7rFOkvI5/Ehn8K/w\nyGzbVEQNN4R8AQtk6rZocucyi8grFdV7cjt5KKtu0sWH0vZZH8n0qgAQh18XkKN2\n+a6yci8ODnO7loWxI08nCTAMiEhaXBG1UL82+nfLBw3sONb4nEnuFaOTZOxNjLa6\nE+/sFtlqOusdZ31fuXdlitEJbaLgHpaXFAfoA+0y9/rOETlH5RFAW/RG6ZqIfkIs\n3a3P8mchuXgryMgEcUuV+Zd2pQEyNlydZYhZaPpG2QKBgQD3wzbYmYZLgLquYf9+\nrEf54UyCL13s2HQDYz0cdhPuGgQifuL/BhvMtindNVqmKArqWvQWTvHay1+ZgDTR\nKWY72fD39sK8zetYd6peYFqQkJPXeobnajSKm7bnxv+6R1W0OKCSOgjcQgmGPPlN\nVQcr1ogJJnwag3uO2rImL6sLKQKBgQDGjFOupCeIlhkl53jB5Vl1ugIdtoGMAxJo\nF169NSsRbpiVbuaPSbshBgp/FDNSc0QaWIV487LohGN3wJZwLNJ1KBvCuDjG0P7U\n3G/oy+MHqsw6WqN6eaFDe50rtsSaoWWFGFWHChS4aCr+YW/Opzmrlnza1GBU2vbV\n9mRWSeryHwKBgHY/Fvf9HZj/URlU8AlW0+swWcFwNdWJ4KSVQl9JA24JwJtuD4xD\nMBVdg1Ft21udlMgQrJnRB6Cym2e5Rnvk1EQQWe8eOAbACGhqhEcSmWaRed3HPodH\nqtfURVENKpOO5BplRE1FoWDtq3oDs7/yqr+DXd1wHp7QzbF6MrgC3BExAoGBAMYH\ntHddtyiePNr3chRCguXO7slf/Pn/Hl6/4HhrDVfHrVxuTnvgGEqp0dJJ/Z5g5S45\n2HZ46prLYMJSTjn4GrlLldSzFb4HOgRpER1qLji5fBU/zgocQmIiavLsyk9IZw9G\n5BdaUKxVCXzLBk9hrz2bTVCdvq8j7koeBJmkBDgVAoGBAKG3IiOPrx42jqbauoDN\ngAzxT2Qg3ZpFf6wjvm5cnF4K9k7Q+vZDTLowcCBEDo8k4Yo4MRsHsZanJxqXlunQ\nsyXzg8QxMBn7jPLSJiRbKJ9ULibfScOvLSOnrgN6YpgjapV+ZhDIEUXk+p3ZxhMB\nQY39Zd87NJxeJjmqzKO0TPlh\n-----END PRIVATE KEY-----\n",
  "client_email": "innonamaz@learnflutter-286314.iam.gserviceaccount.com",
  "client_id": "114068503169209063504",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/innonamaz%40learnflutter-286314.iam.gserviceaccount.com"
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
          if (days[x].date == ReminderController().currentTime.day) {
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


    return DayPrayers(month: ReminderController().currentTime.month.toString() , date: ReminderController().currentTime.day , prayers: []);
  }


}
