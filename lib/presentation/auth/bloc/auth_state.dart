part of 'auth_bloc.dart';

sealed class AuthState {}

class AuthIsNotSign extends AuthState {}

class AuthIsSign extends AuthState {}
