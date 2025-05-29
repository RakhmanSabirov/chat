part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthLogin extends AuthEvent {}

class AuthLogout extends AuthEvent {}
