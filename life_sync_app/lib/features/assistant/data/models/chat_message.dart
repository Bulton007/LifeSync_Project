enum MessageSender { user, assistant, system }

final class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.sender,
    required this.timestamp,
    this.isError = false,
  });

  final String text;
  final MessageSender sender;
  final DateTime timestamp;
  final bool isError;
}
