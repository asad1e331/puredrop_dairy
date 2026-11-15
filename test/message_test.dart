import 'package:flutter_test/flutter_test.dart';
import 'package:puredrop_dairy/features/support/data/models/message.dart';

void main() {
  final record = <String, Object>{
    'id': 'message_1',
    'senderId': 'customer_1',
    'text': 'My delivery is missing.',
    'sentAt': '2026-11-15T08:30:00.000Z',
  };

  test('Parses and serializes a valid support message', () {
    final message = Message.fromJson(record);

    expect(message.id, 'message_1');
    expect(message.senderId, 'customer_1');
    expect(message.text, 'My delivery is missing.');
    expect(message.sentAt, DateTime.utc(2026, 11, 15, 8, 30));
    expect(message.toJson(), record);
  });

  test('Rejects a message without a sender', () {
    final incomplete = {...record}..remove('senderId');

    expect(() => Message.fromJson(incomplete), throwsFormatException);
  });

  test('Rejects blank text and an invalid timestamp', () {
    expect(
      () => Message.fromJson({...record, 'text': '   '}),
      throwsFormatException,
    );
    expect(
      () => Message.fromJson({...record, 'sentAt': 'invalid timestamp'}),
      throwsFormatException,
    );
  });
}
