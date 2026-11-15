import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../domain/entities/delivery.dart';
import '../../domain/repositories/delivery_repository.dart';
import '../datasources/hive_delivery_cache.dart';
import '../datasources/mock_delivery_service.dart';
import '../repositories/cached_delivery_repository.dart';

final mockDeliveryServiceProvider = Provider<MockDeliveryService>((ref) {
  return MockDeliveryService();
});

final hiveDeliveryCacheProvider = Provider<HiveDeliveryCache>((ref) {
  return HiveDeliveryCache(Hive.box<String>('delivery_cache'));
});

final deliveryRepositoryProvider = Provider<DeliveryRepository>((ref) {
  return CachedDeliveryRepository(
    ref.watch(hiveDeliveryCacheProvider),
    ref.watch(mockDeliveryServiceProvider),
  );
});

final weeklyDeliveriesProvider = StreamProvider<List<Delivery>>((ref) {
  return ref.watch(deliveryRepositoryProvider).watchWeeklyDeliveries();
});
