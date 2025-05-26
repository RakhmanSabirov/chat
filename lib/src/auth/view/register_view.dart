import 'package:chatt_app/src/auth/bloc/register/register_cubit.dart';
import 'package:chatt_app/src/auth/fform/fields/fields.dart';
import 'package:chatt_app/src/auth/fform/form/register_form.dart';
import 'package:chatt_app/src/auth/params/register_params.dart';
import 'package:chatt_app/src/auth/widgets/long_button.dart';
import 'package:chatt_app/src/users_screen.dart';
import 'package:fform/fform.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/login/login_cubit.dart';
import '../bloc/sign_in/sign_in_cubit.dart';
import '../widgets/card_widget.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({
    super.key,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  })  : _emailController = emailController,
        _passwordController = passwordController;

  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late TextEditingController _nameController;
  final RegisterForm _form = RegisterForm.parse();

  @override
  initState() {
    _nameController = TextEditingController();
    super.initState();
  }

  // Вход
  Future<void> Function() _registerUser(BuildContext context) => () async {
    _form.change(
      email: widget._emailController.text,
      password: widget._passwordController.text,
      name: _nameController.text,
    );
    if (_form.isInvalid) return;
    await context.read<RegistrationCubit>().register(
      RegisterParams(
        email: widget._emailController.text,
        password: widget._passwordController.text,
        name: _nameController.text,
      ),
    );
  };

  // Переход на регистрацию
  void Function() _toLoginState(BuildContext context) =>
          () => context.read<SignInCubit>().to(SignLoginState());

  void _listener(BuildContext context, RegistrationState state) {
    switch (state) {
      case RegistrationSuccess():
        {
          // Здесь можно перейти на следующий экран
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => UsersScreen()));
          break;
        }
      case RegistrationFailure(message: String message):
        {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
          break;
        }
      default:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      padding: const EdgeInsets.all(20),
      children: [
        const Text("Логин"),
        const SizedBox(height: 20),
        BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return FFormBuilder<RegisterForm>(
              form: _form,
              builder: (context, RegisterForm form,_) {
                EmailField email = _form.email;
                PasswordField password = _form.password;
                NameField name = _form.name;
                return Column(
                  children: [
                    TextField(
                      controller: widget._emailController,
                      decoration: InputDecoration(
                        errorText: email.exception.toString(),
                        hintText: "Email",
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        errorText: name.exception.toString(),
                        hintText: "Имя",
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: widget._passwordController,
                      decoration: InputDecoration(
                        hintText: "Пароль",
                        errorText: password.exception.toString(),
                      ),
                      obscureText: true,
                    ),
                  ],
                );
              },
            );
          },
        ),
        const SizedBox(height: 20),
        BlocConsumer<RegistrationCubit, RegistrationState>(
          listener: _listener,
          builder: (context, state) {
            return LongButton(
              onTap: _registerUser(context),
              text: "Зарегестрироваться",
              isLoading: state is RegistrationLoading,
            );
          },
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.center,
          child: Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: "Нет аккаунта? "),
                TextSpan(
                  text: "Зарегистрироваться",
                  style: const TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = _toLoginState(context),
                ),
              ],
            ),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
