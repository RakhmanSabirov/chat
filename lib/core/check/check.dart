class Check {
  static bool isPhone(String data) {
    RegExp phoneRegExp = RegExp(r'^\+\d\s\(\d{3}\)\s\d{3}-\d{2}-\d{2}$');

    return phoneRegExp.hasMatch(data);
  }

  static bool isEmail(String data) {
    final RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

    return regex.hasMatch(data);
  }
}
