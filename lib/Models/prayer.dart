
class Prayer{
  String _paryer , _start , _jamaat;
  bool _notification;

  Prayer(this._paryer , this._start , [this._jamaat , this._notification]);

  String get prayer => _paryer;
  String get start => _start;
  String get jamaat => _jamaat;
  bool get notification => _notification;

  void setPrayer(String paryer) {
    this._paryer = paryer;
  }

  void setPrayerStart(String start) {
    this._start = start;
  }

  void setPrayerJamaat(String jamaat) {
    this._jamaat = jamaat;
  }

  void setNotification(bool notification) {
    this._notification = notification;
  }
}