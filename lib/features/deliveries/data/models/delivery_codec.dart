import '../../domain/entities/delivery.dart';

class DeliveryCodec {
  static Delivery decode(Object? value) {
    if (value is! Map<String, dynamic>) {
      throw const FormatException('Expected a delivery record.');
    }

    final id = value['id'];
    final rawDate = value['date'];
    final rawStatus = value['status'];
    final quantity = value['quantity'];

    final date = rawDate is String ? DateTime.tryParse(rawDate) : null;
    final status = switch (rawStatus) {
      'delivered' => DeliveryStatus.delivered,
      'pending' => DeliveryStatus.pending,
      _ => null,
    };

    if (id is! String ||
        id.trim().isEmpty ||
        date == null ||
        status == null ||
        quantity is! num ||
        !quantity.isFinite ||
        quantity < 0) {
      throw const FormatException('Invalid delivery record.');
    }

    return Delivery(
      id: id,
      date: date,
      status: status,
      quantity: quantity.toDouble(),
    );
  }

  static Map<String, Object> encode(Delivery delivery) {
    return {
      'id': delivery.id,
      'date': delivery.date.toIso8601String(),
      'status': delivery.status.name,
      'quantity': delivery.quantity,
    };
  }
}
