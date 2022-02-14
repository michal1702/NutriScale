class ChartRecord {
  DateTime? _dateTime;
  double amount;

  DateTime? get dateTime => _dateTime;

  ChartRecord(this._dateTime, this.amount);
}
