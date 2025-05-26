import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../repositories/auth_repository.dart';
import '../../params/register_params.dart';

part 'register_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final AuthRepository _authRepository;

  RegistrationCubit(this._authRepository) : super(RegistrationInitial());

  Future<void> register(RegisterParams params) async {
    emit(RegistrationLoading());

    try {
      await _authRepository.registerWithEmail(params);
      emit(RegistrationSuccess(email: params.email));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          emit(RegistrationFailure("Этот email уже зарегистрирован"));
          break;
        case 'invalid-email':
          emit(RegistrationFailure("Некорректный email"));
          break;
        case 'weak-password':
          emit(RegistrationFailure("Пароль слишком простой"));
          break;
        default:
          emit(RegistrationFailure("Ошибка: ${e.message}"));
      }
    } catch (e) {
      emit(RegistrationFailure("Неизвестная ошибка: ${e.toString()}"));
    }
  }
}
