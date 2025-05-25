part of 'login_cubit.dart';

sealed class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginRedirectVerifyState extends LoginState {
  final String email;

  LoginRedirectVerifyState({required this.email});
}

class LoginError extends LoginState {
  final String? message;

  LoginError(this.message);
}


