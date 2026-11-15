import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:puredrop_dairy/features/deliveries/data/datasources/hive_delivery_cache.dart';
import 'package:puredrop_dairy/features/deliveries/domain/entities/delivery.dart';

void main() {
  test('Saved deliveries survive closing and reopening the Hive box', () async {
    final directory = await Directory.systemTemp.createTemp('puredrop_hive_');

    addTearDown(() async {
      await Hive.close();
      await directory.delete(recursive: true);
    });

    Hive.init(directory.path);

    const boxName = 'delivery_cache_test';
    final delivery = Delivery(
      id: 'delivery_1',
      date: DateTime(2026, 11, 15),
      status: DeliveryStatus.delivered,
      quantity: 1.5,
    );

    final box = await Hive.openBox<String>(boxName);
    final cache = HiveDeliveryCache(box);

    await cache.saveDeliveries([delivery]);
    await box.close();

    final reopenedBox = await Hive.openBox<String>(boxName);
    final savedDeliveries = HiveDeliveryCache(reopenedBox).getDeliveries();

    expect(savedDeliveries, hasLength(1));

    final savedDelivery = savedDeliveries.single;
    expect(savedDelivery.id, delivery.id);
    expect(savedDelivery.date, delivery.date);
    expect(savedDelivery.status, delivery.status);
    expect(savedDelivery.quantity, delivery.quantity);
  });
}
