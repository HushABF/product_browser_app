import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String productId;
  final String senderUsername;
  final String senderId;
  final String text;
  final DateTime createdAt;

  const MessageEntity({
    required this.id,
    required this.productId,
    required this.senderUsername,
    required this.text,
    required this.createdAt,
    required this.senderId,
  });

  @override
  List<Object?> get props => [
    id,
    productId,
    senderUsername,
    senderId,
    text,
    createdAt,
  ];
}
