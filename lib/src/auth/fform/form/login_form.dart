import 'package:fform/fform.dart';

import '../fields/fields.dart';

class LoginForm extends FForm {
  EmailField email;
  PasswordField password;

  LoginForm({required this.email, required this.password});

  factory LoginForm.parse({String email = '', String password = ''}) {
    return LoginForm(
      email: EmailField(value: email),
      password: PasswordField(value: password),
    );
  }

  change({String? email, String? password}) {
    this.email.value = email ?? '';
    this.password.value = password ?? '';
  }

  @override
  List<FFormField> get fields => [email, password];
}
