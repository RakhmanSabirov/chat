part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ChatStarted extends ChatEvent {
  final String chatId;

  const ChatStarted(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class MessageSent extends ChatEvent {
  final String chatId;
  final String text;
  final String name;

  const MessageSent({
    required this.chatId,
    required this.text,
    required this.name,
  });

  @override
  List<Object?> get props => [chatId, text];
}

class ChatMessagesUpdated extends ChatEvent {
  final List<MessageModel> messages;
  final String chatId;

  const ChatMessagesUpdated(this.messages, this.chatId);

  @override
  List<Object?> get props => [messages, chatId];
}
