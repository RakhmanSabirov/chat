import 'package:fform/fform.dart';

import '../../../../core/check/check.dart';

enum EmailError {
  empty,
  not;

  @override
  String toString() {
    switch (this) {
      case empty:
        return "Email пустой";
      case not:
        return "Неверный формат майла";
      default:
        return "Неверный формат майла";
    }
  }
}

class EmailField extends FFormField<String, EmailError> {
  bool isRequired;

  EmailField({required String value, this.isRequired = true}) : super(value);

  @override
  EmailError? validator(value) {
    if (isRequired) {
      if (value.isEmpty) return EmailError.empty;
      if (!Check.isEmail(value)) return EmailError.not;
    }
    return null;
  }
}
