import 'package:fform/fform.dart';

class ParserUtils {
  static String? getException(FForm form, FFormField? field) {
    if (field == null) return null;
    if (field.exception == null) return null;
    if (form.hasCheck) return field.exception.toString();
    return null;
  }
}
