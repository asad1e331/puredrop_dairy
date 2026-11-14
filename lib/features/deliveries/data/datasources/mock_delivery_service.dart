import '../../domain/entities/delivery.dart';

class MockDeliveryService {
  Future<List<Delivery>> fetchWeeklyDeliveries() async {
    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);

    final deliveries = List<Delivery>.generate(7, (index) {
      final deliveryDate = startOfToday.subtract(Duration(days: index));

      return Delivery(
        id: 'delivery_${index + 1}',
        date: deliveryDate,
        status: index < 5 ? DeliveryStatus.delivered : DeliveryStatus.pending,
        quantity: index.isEven ? 2.0 : 1.5,
      );
    });

    return deliveries;
  }
}
