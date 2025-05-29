import 'package:chatt_app/core/dependencies/dependencies.dart';
import 'package:chatt_app/repositories/auth_repository.dart';
import 'package:chatt_app/src/auth/bloc/login/login_cubit.dart';
import 'package:chatt_app/src/auth/bloc/register/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/images/app_images.dart';
import '../bloc/sign_in/sign_in_cubit.dart';
import '../view/login_view.dart';
import '../view/register_view.dart';

class SingInScreen extends StatefulWidget {
  const SingInScreen({super.key});

  @override
  State<SingInScreen> createState() => _SingInScreenState();
}

class _SingInScreenState extends State<SingInScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignInCubit>(create: (context) => SignInCubit()),
        BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(getIt<AuthRepository>()),
        ),
        BlocProvider<RegistrationCubit>(
          create: (context) => RegistrationCubit(getIt<AuthRepository>()),
        ),
      ],
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.backImage), // или NetworkImage
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: BlocBuilder<SignInCubit, SignInState>(
                  builder: (context, state) {
                    return switch (state) {
                      SignLoginState() => LoginView(
                        emailController: _emailController,
                        passwordController: _passwordController,
                      ),
                      SingRegisterState() => RegisterView(
                        emailController: _emailController,
                        passwordController: _passwordController,
                      ),
                    };
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
