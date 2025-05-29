import 'package:chatt_app/repositories/auth_repository.dart';
import 'package:chatt_app/src/auth/screen/sing_in_screen.dart';
import 'package:chatt_app/src/chat/screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/dependencies/dependencies.dart';
import '../repositories/chat_repository.dart';
import 'chat/bloc/chat_bloc.dart';

class UsersScreen extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser;
  final AuthRepository _authService = AuthRepository();

  UsersScreen({super.key});

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Подтверждение'),
          content: const Text('Вы уверены, что хотите выйти?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Закрыть диалог
              },
            ),
            TextButton(
              child: const Text('Выйти'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Закрыть диалог
                _signOut(context); // Выйти
              },
            ),
          ],
        );
      },
    );
  }

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
      backgroundColor: const Color(0xFFF6F6F6), // Светлый фон
      appBar: AppBar(
        title: const Text('Пользователи'),
        elevation: 1,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти',
            onPressed: () => _showLogoutConfirmation(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users =
              snapshot.data!.docs
                  .where((doc) => doc['uid'] != currentUser?.uid)
                  .toList();

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            itemCount: users.length,
            itemBuilder: (_, index) {
              final user = users[index].data() as Map<String, dynamic>;
              final otherUserId = user['uid'];
              final currentUserId = currentUser!.uid;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  onTap: () async {
                    final chatRepository = getIt<ChatRepository>();
                    final chatId = await chatRepository.createOrGetChatId(
                      currentUserId,
                      otherUserId,
                    );

                    final currentUserDoc =
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(currentUserId)
                            .get();

                    final currentUsername =
                        currentUserDoc['name'] ?? 'Без имени';

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (_) => BlocProvider(
                              create:
                                  (_) => ChatBloc(
                                    chatRepository: chatRepository,
                                    currentUserId: currentUserId,
                                    currentUsername: currentUsername,
                                  ),
                              child: ChatScreen(
                                chatId: chatId,
                                currentUserId: currentUserId,
                                currentUsername: currentUsername,
                                otherUserName: user['name'],
                              ),
                            ),
                      ),
                    );
                  },
                  leading:
                      user['photoUrl'] != null && user['photoUrl'] != ''
                          ? CircleAvatar(
                            radius: 26,
                            backgroundImage: NetworkImage(user['photoUrl']),
                          )
                          : const CircleAvatar(
                            radius: 26,
                            child: Icon(Icons.person),
                          ),
                  title: Text(
                    user['name'] ?? 'Без имени',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      const Icon(Icons.email, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          user['email'] ?? '',
                          style: const TextStyle(fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.chat, color: Colors.deepPurple),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
