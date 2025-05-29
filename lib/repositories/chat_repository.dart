import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../src/chat/models/message_model.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ChatRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  /// Получение текущего UID
  String get currentUserId => _auth.currentUser!.uid;

  /// Создать или получить chatId между двумя пользователями
  Future<String> createOrGetChatId(String userId1, String userId2) async {
    final users = [userId1, userId2]..sort();
    final query =
        await _firestore
            .collection('chats')
            .where('users', isEqualTo: users)
            .limit(1)
            .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first.id;
    }

    final newChat = await _firestore.collection('chats').add({
      'users': users,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return newChat.id;
  }

  /// Отправить сообщение
  Future<void> sendMessage({
    required String chatId,
    required String text,
  }) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
          'text': text,
          'senderId': currentUserId,
          'timestamp': FieldValue.serverTimestamp(),
        });
  }

  /// Подписка на сообщения
  Stream<List<MessageModel>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => MessageModel.fromDoc(doc)).toList(),
        );
  }
}
