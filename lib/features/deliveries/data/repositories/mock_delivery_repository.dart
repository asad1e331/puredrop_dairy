import '../../domain/entities/delivery.dart';
import '../../domain/repositories/delivery_repository.dart';
import '../datasources/mock_delivery_service.dart';

class MockDeliveryRepository implements DeliveryRepository {
  final MockDeliveryService _service;

  MockDeliveryRepository(this._service);

  @override
  Future<List<Delivery>> getWeeklyDeliveries() {
    return _service.fetchWeeklyDeliveries();
  }
}
