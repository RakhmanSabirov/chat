import '../../../core/params/params.dart';

class RegisterParams extends Params {
  final String name;
  final String email;
  final String password;

  RegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  toData() {
    return {'name': name, 'email': email, 'password': password};
  }
}
