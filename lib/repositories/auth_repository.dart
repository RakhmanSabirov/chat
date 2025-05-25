import 'package:chatt_app/presentation/auth/params/login_params.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<User?> signInWithEmail(LoginParams params) async {
    final result = await _firebaseAuth.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
    return result.user;
  }

  Future<User?> registerWithEmail(String email, String password, String name) async {
    final result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await result.user?.updateDisplayName(name);
    await _firebaseAuth.currentUser?.reload();
    return _firebaseAuth.currentUser;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  User? get currentUser => _firebaseAuth.currentUser;
}
