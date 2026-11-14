enum DeliveryStatus { delivered, pending }

class Delivery {
  final String id;
  final DateTime date;
  final DeliveryStatus status;
  final double quantity;

  const Delivery({
    required this.id,
    required this.date,
    required this.status,
    required this.quantity,
  });
}
