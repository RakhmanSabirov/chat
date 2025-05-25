import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../repositories/auth_repository.dart';
import '../../params/login_params.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(LoginInitial());

  Future<void> login(LoginParams params) async {
    if (state is LoginLoading) return;

    emit(LoginLoading());

    try {
      await _authRepository.signInWithEmail(params);
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        emit(LoginError("Неправильный логин или пароль"));
      } else if (e.code == 'user-disabled') {
        emit(LoginError("Учетная запись отключена"));
      } else {
        emit(LoginError("Ошибка аутентификации: ${e.message}"));
      }
    } catch (e) {
      emit(LoginError("Неизвестная ошибка: ${e.toString()}"));
    }
  }
}
