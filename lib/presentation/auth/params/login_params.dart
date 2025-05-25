import '../../../core/params/params.dart';

class LoginParams extends Params {
  final String email;
  final String password;

  LoginParams({
    required this.email,
    required this.password,
  });

  @override
  toData() {
    return {
      'email': email,
      'password': password,
    };
  }
}
