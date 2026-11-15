import 'dart:async';

import '../../domain/entities/delivery.dart';
import '../../domain/repositories/delivery_repository.dart';
import '../datasources/hive_delivery_cache.dart';
import '../datasources/mock_delivery_service.dart';

class CachedDeliveryRepository implements DeliveryRepository {
  final HiveDeliveryCache _cache;
  final MockDeliveryService _mockService;

  Future<void>? _refreshInProgress;

  CachedDeliveryRepository(this._cache, this._mockService);

  @override
  Future<List<Delivery>> getWeeklyDeliveries() async {
    final cached = _cache.getDeliveries();

    if (_cache.hasCachedData) {
      return cached;
    }

    await refreshDeliveries();
    return _cache.getDeliveries();
  }

  @override
  Stream<List<Delivery>> watchWeeklyDeliveries() {
    return _cache.watchDeliveries();
  }

  @override
  Future<void> refreshDeliveries() {
    final ongoing = _refreshInProgress;

    if (ongoing != null) {
      return ongoing;
    }

    final refresh = _performRefresh();
    _refreshInProgress = refresh;

    return refresh.whenComplete(() {
      _refreshInProgress = null;
    });
  }

  Future<void> _performRefresh() async {
    try {
      final freshDeliveries = await _mockService
          .fetchWeeklyDeliveries()
          .timeout(const Duration(seconds: 10));

      await _cache.saveDeliveries(freshDeliveries);
    } on TimeoutException {
      throw Exception(
        'Delivery refresh timed out. Cached data is still available.',
      );
    } catch (error) {
      throw Exception(
        'Unable to refresh deliveries. Cached data was preserved: $error',
      );
    }
  }
}
