import 'package:fform/fform.dart';

import '../../../../core/check/check.dart';

enum NameError {
  empty,
  not;

  @override
  String toString() {
    switch (this) {
      case empty:
        return "Имя пустое";
      case not:
        return "Неверный формат имени";
      default:
        return "Неверный формат имени";
    }
  }
}

class NameField extends FFormField<String, NameError> {
  bool isRequired;

  NameField({required String value, this.isRequired = true}) : super(value);

  @override
  NameError? validator(value) {
    if (isRequired) {
      if (value.isEmpty) return NameError.empty;
      if (!Check.isEmail(value)) return NameError.not;
    }
    return null;
  }
}
