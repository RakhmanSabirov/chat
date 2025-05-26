import 'package:fform/fform.dart';

import '../fields/fields.dart';

class RegisterForm extends FForm {
  NameField name;
  EmailField email;
  PasswordField password;

  RegisterForm({
    required this.name,
    required this.email,
    required this.password,
  });

  factory RegisterForm.parse({
    String? email,
    String? name,
    String? password,
  }) {
    return RegisterForm(
      name: NameField(value: name ?? ''),
      email: EmailField(value: email ?? ''),
      password: PasswordField(value: password ?? ''),
    );
  }

  change({
    String? name,
    String? email,
    String? phone,
    String? password,
    String? passwordConfirmation,
  }) {
    this.name.value = name ?? '';
    this.email.value = email ?? '';
    this.password.value = password ?? '';
  }

  @override
  bool get allFieldUpdateCheck => false;

  @override
  List<FFormField> get fields => [
    name,
    email,
    password,
  ];
}
