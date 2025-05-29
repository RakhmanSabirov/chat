import 'package:chatt_app/core/parser.dart';
import 'package:chatt_app/src/auth/widgets/long_button.dart';
import 'package:chatt_app/src/users_screen.dart';
import 'package:fform/fform.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login/login_cubit.dart';
import '../bloc/sign_in/sign_in_cubit.dart';
import '../fform/form/login_form.dart';
import '../params/login_params.dart';
import '../widgets/card_widget.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    super.key,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) : _emailController = emailController,
       _passwordController = passwordController;

  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginForm _form = LoginForm.parse();

  Future<void> Function() _loginUser(BuildContext context) => () async {
    _form.change(
      email: widget._emailController.text,
      password: widget._passwordController.text,
    );
    if (_form.isInvalid) return;
    await context.read<LoginCubit>().login(
      LoginParams(
        email: widget._emailController.text,
        password: widget._passwordController.text,
      ),
    );
  };

  void Function() _toRegister(BuildContext context) =>
      () => context.read<SignInCubit>().to(SingRegisterState());

  void _listener(BuildContext context, LoginState state) {
    switch (state) {
      case LoginSuccess():
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => UsersScreen()));
        break;
      case LoginError(message: String message):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        break;
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
        const Text(
          "Логин",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 20),
        BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return FFormBuilder<LoginForm>(
              form: _form,
              builder: (context, LoginForm form) {
                return Column(
                  children: [
                    TextField(
                      controller: widget._emailController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorText: ParserUtils.getException(form, form.email),
                        hintText: "Email",
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: widget._passwordController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "Пароль",
                        errorText: ParserUtils.getException(
                          form,
                          form.password,
                        ),
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
        BlocConsumer<LoginCubit, LoginState>(
          listener: _listener,
          builder: (context, state) {
            return LongButton(
              onTap: _loginUser(context),
              text: "Войти в аккаунт",
              isLoading: state is LoginLoading,
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
                  recognizer:
                      TapGestureRecognizer()..onTap = _toRegister(context),
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
