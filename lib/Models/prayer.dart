
class Prayer{
  String _paryer , _start , _jamaat;

  Prayer(this._paryer , this._start , [this._jamaat ]);

  String get prayer => _paryer;
  String get start => _start;
  String get jamaat => _jamaat;

  void setPrayer(String paryer) {
    this._paryer = paryer;
  }

  void setPrayerStart(String start) {
    this._start = start;
  }

  void setPrayerJamaat(String jamaat) {
    this._jamaat = jamaat;
  }
}