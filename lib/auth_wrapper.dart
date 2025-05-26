import 'package:chatt_app/src/auth/screen/login_screen.dart';
import 'package:chatt_app/src/users_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          // Пользователь авторизован
          return UsersScreen();
        } else {
          // Пользователь не вошёл
          return LoginScreen();
        }
      },
    );
  }
}
