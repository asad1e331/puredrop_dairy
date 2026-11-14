import '../entities/delivery.dart';

abstract class DeliveryRepository {
  Future<List<Delivery>> getWeeklyDeliveries();
}
