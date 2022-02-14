class UserCredentials {
  String _login;
  String _password;
  String _email;

  String get login => _login;

  String get password => _password;

  String get email => _email;

  UserCredentials(this._login, this._password, this._email);

  Map toJson() => {
        'email': this._email,
        'login': this._login,
        'password': this._password,
      };
}
