import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/auth_service.dart';
import 'users_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isLogin = true;

  void _handleAuth() async {
    if (!_formKey.currentState!.validate()) return;

    User? user;
    try {
      if (_isLogin) {
        user = await _authService.loginWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      } else {
        user = await _authService.registerWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _nameController.text.trim(),
        );
        // 🔥 Ждем пока Firebase обновит текущего пользователя
        await FirebaseAuth.instance.currentUser?.reload();
        user = FirebaseAuth.instance.currentUser;
      }

      if (user != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => UsersScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${e.toString()}')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Вход' : 'Регистрация')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (!_isLogin)
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Имя'),
                  validator: (val) => val == null || val.isEmpty ? 'Введите имя' : null,
                ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (val) => val != null && val.contains('@') ? null : 'Некорректный email',
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Пароль'),
                validator: (val) => val != null && val.length >= 6
                    ? null
                    : 'Минимум 6 символов',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleAuth,
                child: Text(_isLogin ? 'Войти' : 'Зарегистрироваться'),
              ),
              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(_isLogin ? 'Нет аккаунта? Регистрация' : 'Уже есть аккаунт? Войти'),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  final user = await _authService.signInWithGoogle();
                  if (user != null && context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => UsersScreen()),
                    );
                  }
                },
                child: Image.asset(
                  'assets/google_icon.png',
                  width: 40,
                  height: 40,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
