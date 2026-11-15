import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:puredrop_dairy/core/providers/connectivity_provider.dart';
import 'package:puredrop_dairy/features/deliveries/data/providers/delivery_providers.dart';
import 'package:puredrop_dairy/features/deliveries/domain/entities/delivery.dart';
import 'package:puredrop_dairy/features/deliveries/presentation/screens/dashboard_screen.dart';

void main() {
  testWidgets('Offline dashboard shows new cache values from the stream', (
    tester,
  ) async {
    final updates = StreamController<List<Delivery>>();
    addTearDown(() => updates.close());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          connectivityProvider.overrideWith((ref) => Stream.value(false)),
          weeklyDeliveriesProvider.overrideWith((ref) => updates.stream),
        ],
        child: const MaterialApp(home: DashboardScreen()),
      ),
    );

    updates.add([]);
    await tester.pumpAndSettle();

    expect(find.text("You're Offline"), findsOneWidget);
    expect(find.text('No cached deliveries available'), findsOneWidget);
    final refreshButton = find.byWidgetPredicate(
      (widget) =>
          widget is IconButton && widget.tooltip == 'Refresh deliveries',
    );

    expect(refreshButton, findsOneWidget);
    expect(tester.widget<IconButton>(refreshButton).onPressed, isNull);

    updates.add([
      Delivery(
        id: 'delivery_1',
        date: DateTime(2026, 11, 15),
        status: DeliveryStatus.delivered,
        quantity: 1.5,
      ),
    ]);
    await tester.pumpAndSettle();

    expect(find.text('15/11/2026'), findsOneWidget);
    expect(find.text('Delivered'), findsOneWidget);
    expect(find.text('No cached deliveries available'), findsNothing);
  });
}
