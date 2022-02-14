class Nutrient {
  final String _name;
  final String _unit;
  String amount;

  String get name => _name;

  String get unit => _unit;

  Nutrient(this._name, this._unit, this.amount);

  factory Nutrient.fromMap(Map<dynamic, dynamic> details) {
    return Nutrient(details['name'], details['unit'], details['amount']);
  }

  Map toJson() =>
      {'name': this._name, 'amount': this.amount, 'unit': this._unit};
}
