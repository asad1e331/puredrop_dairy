import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/delivery.dart';
import '../../domain/repositories/delivery_repository.dart';
import '../datasources/mock_delivery_service.dart';
import '../repositories/mock_delivery_repository.dart';

final mockDeliveryServiceProvider = Provider<MockDeliveryService>((ref) {
  return MockDeliveryService();
});

final deliveryRepositoryProvider = Provider<DeliveryRepository>((ref) {
  final service = ref.watch(mockDeliveryServiceProvider);

  return MockDeliveryRepository(service);
});

final weeklyDeliveriesProvider = FutureProvider<List<Delivery>>((ref) {
  final repository = ref.watch(deliveryRepositoryProvider);

  return repository.getWeeklyDeliveries();
});
