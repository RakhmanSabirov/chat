import 'package:chatt_app/src/auth/screen/sing_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/auth_service.dart';
import 'auth/screen/login_screen.dart';

class UsersScreen extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser;
  final AuthService _authService = AuthService();

  UsersScreen({super.key});

  void _signOut(BuildContext context) async {
    await _authService.signOut();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SingInScreen()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Пользователи'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти',
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final users = snapshot.data!.docs
              .where((doc) => doc['uid'] != currentUser?.uid)
              .toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (_, index) {
              final user = users[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: user['photoUrl'] != null && user['photoUrl'] != ''
                    ? CircleAvatar(backgroundImage: NetworkImage(user['photoUrl']))
                    : const CircleAvatar(child: Icon(Icons.person)),
                title: Text(user['name'] ?? 'Без имени'),
                subtitle: Text(user['email'] ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}
