import 'dart:convert';

import 'package:hive/hive.dart';

import '../../domain/entities/delivery.dart';
import '../models/delivery_codec.dart';

class HiveDeliveryCache {
  static const String deliveriesKey = 'weekly_deliveries';

  final Box<String> _box;

  HiveDeliveryCache(this._box);

  List<Delivery> getDeliveries() {
    final storedData = _box.get(deliveriesKey);

    if (storedData == null) {
      return [];
    }

    final Object? decoded;
    try {
      decoded = jsonDecode(storedData);
    } on FormatException {
      return [];
    }

    if (decoded is! List) {
      return [];
    }

    final deliveries = <Delivery>[];
    for (final record in decoded) {
      try {
        deliveries.add(DeliveryCodec.decode(record));
      } on FormatException {
        continue;
      }
    }
    return deliveries;
  }

  Future<void> saveDeliveries(List<Delivery> deliveries) async {
    final data = deliveries.map(DeliveryCodec.encode).toList();
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
