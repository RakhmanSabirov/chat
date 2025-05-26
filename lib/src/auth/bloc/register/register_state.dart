part of 'register_cubit.dart';

sealed class RegistrationState {}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {
  final String email;

  RegistrationSuccess({required this.email});
}

class RegistrationFailure extends RegistrationState {
  final String message;

  RegistrationFailure(this.message);
}
