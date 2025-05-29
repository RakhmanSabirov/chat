import 'package:chatt_app/src/auth/params/login_params.dart';
import 'package:chatt_app/src/auth/params/register_params.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final _firestore = FirebaseFirestore.instance;
  final _googleSignIn = GoogleSignIn();

  AuthRepository({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> saveUserToken(String uid) async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'fcmToken': token,
      });
    }
  }

  Future<User?> signInWithEmail(LoginParams params) async {
    final result = await _firebaseAuth.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
    return result.user;
  }

  Future<User?> registerWithEmail(RegisterParams params) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );

      final user = credential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': params.name,
          'email': params.email,
          'photoUrl': '',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } catch (e) {
      rethrow;
    }
  }

  // Future<User?> signInWithGoogle() async {
  //   final googleUser = await _googleSignIn.signIn();
  //   if (googleUser == null) return null;
  //
  //   final googleAuth = await googleUser.authentication;
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );
  //
  //   final userCredential = await _firebaseAuth.signInWithCredential(credential);
  //   final user = userCredential.user;
  //   if (user != null) {
  //     await _saveUserIfNew(user);
  //   }
  //   return user;
  // }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  User? get currentUser => _firebaseAuth.currentUser;
}
