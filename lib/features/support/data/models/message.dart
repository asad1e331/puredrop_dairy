class Message {
  final String id;
  final String senderId;
  final String text;
  final DateTime sentAt;

  const Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.sentAt,
  });

  factory Message.fromJson(Map<String, Object?> json) {
    final id = json['id'];
    final senderId = json['senderId'];
    final text = json['text'];
    final rawSentAt = json['sentAt'];
    final sentAt = rawSentAt is String ? DateTime.tryParse(rawSentAt) : null;

    if (id is! String ||
        id.trim().isEmpty ||
        senderId is! String ||
        senderId.trim().isEmpty ||
        text is! String ||
        text.trim().isEmpty ||
        sentAt == null) {
      throw const FormatException('Invalid message record.');
    }

    return Message(id: id, senderId: senderId, text: text, sentAt: sentAt);
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'text': text,
      'sentAt': sentAt.toIso8601String(),
    };
  }
}
