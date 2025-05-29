import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../../repositories/chat_repository.dart';
import '../../../service/notification_service.dart';
import '../models/message_model.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  final String currentUserId;
  final String currentUsername;

  StreamSubscription<List<MessageModel>>? _chatSubscription;

  ChatBloc({
    required ChatRepository chatRepository,
    required this.currentUserId,
    required this.currentUsername,
  }) : _chatRepository = chatRepository,
       super(ChatInitial()) {
    on<ChatStarted>(_onChatStarted);
    on<MessageSent>(_onMessageSent);
    on<ChatMessagesUpdated>(_onMessagesUpdated);
  }

  void _onChatStarted(ChatStarted event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    await _chatSubscription?.cancel();
    final chatId = event.chatId;

    _chatSubscription = _chatRepository.getMessages(chatId).listen((messages) {
      add(ChatMessagesUpdated(messages, chatId));
    });
  }

  void _onMessageSent(MessageSent event, Emitter<ChatState> emit) async {
    // Отправка сообщения
    await _chatRepository.sendMessage(chatId: event.chatId, text: event.text);

    // Получение UID получателя
    final otherUserId = _getOtherUserId(event.chatId);

    // Получение FCM токена пользователя
    final userDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(otherUserId)
            .get();
    final token = userDoc.data()?['fcmToken'];

    // Отправка уведомления
    if (token != null) {
      await NotificationService.sendPushNotification(
        token: token,
        title: currentUsername,
        body: event.text,
      );
    }
  }

  void _onMessagesUpdated(ChatMessagesUpdated event, Emitter<ChatState> emit) {
    emit(ChatLoaded(chatId: event.chatId, messages: event.messages));
  }

  String _getOtherUserId(String chatId) {
    final ids = chatId.split('_');
    return ids.first == currentUserId ? ids.last : ids.first;
  }

  @override
  Future<void> close() {
    _chatSubscription?.cancel();
    return super.close();
  }
}
