import 'package:bloc/bloc.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignLoginState());

  void to(SignInState state) {
    emit(state);
  }
}
