import 'dart:convert';

import 'package:hive/hive.dart';

import '../../domain/entities/delivery.dart';

class HiveDeliveryCache {
  static const String deliveriesKey = 'weekly_deliveries';

  final Box<String> _box;

  HiveDeliveryCache(this._box);

  List<Delivery> getDeliveries() {
    final storedData = _box.get(deliveriesKey);

    if (storedData == null) {
      return [];
    }

    final decoded = jsonDecode(storedData) as List<dynamic>;

    return decoded.map((item) {
      final map = Map<String, dynamic>.from(item as Map);

      return Delivery(
        id: map['id'] as String,
        date: DateTime.parse(map['date'] as String),
        status: DeliveryStatus.values.byName(map['status'] as String),
        quantity: (map['quantity'] as num).toDouble(),
      );
    }).toList();
  }

  Future<void> saveDeliveries(List<Delivery> deliveries) async {
    final data = deliveries.map((delivery) {
      return {
        'id': delivery.id,
        'date': delivery.date.toIso8601String(),
        'status': delivery.status.name,
        'quantity': delivery.quantity,
      };
    }).toList();

    await _box.put(deliveriesKey, jsonEncode(data));
  }

  Stream<List<Delivery>> watchDeliveries() async* {
    yield getDeliveries();

    await for (final _ in _box.watch(key: deliveriesKey)) {
      yield getDeliveries();
    }
  }

  bool get hasCachedData => _box.containsKey(deliveriesKey);
}
