import '../entities/delivery.dart';

abstract class DeliveryRepository {
  Future<List<Delivery>> getWeeklyDeliveries();

  Stream<List<Delivery>> watchWeeklyDeliveries();

  Future<void> refreshDeliveries();
}
