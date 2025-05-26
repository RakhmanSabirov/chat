import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatt_app/repositories/auth_repository.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setup() {
  // Сначала регистрируем FirebaseAuth
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Затем регистрируем AuthRepository с внедрением зависимости
  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepository(firebaseAuth: getIt<FirebaseAuth>()),
  );
}
