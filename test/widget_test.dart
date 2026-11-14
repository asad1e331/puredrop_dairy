
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:puredrop_dairy/features/deliveries/presentation/widgets/delivery_card.dart';
import 'package:puredrop_dairy/features/deliveries/data/providers/delivery_providers.dart';
import 'package:puredrop_dairy/features/deliveries/domain/entities/delivery.dart';
import 'package:puredrop_dairy/features/deliveries/presentation/screens/dashboard_screen.dart';

void main() {
  testWidgets('Dashboard displays weekly deliveries', (
    WidgetTester tester,
  ) async {
    final mockDeliveries = List<Delivery>.generate(
      7,
      (index) => Delivery(
        id: 'test_$index',
        date: DateTime(2026, 11, 14 - index),
        status: DeliveryStatus.delivered,
        quantity: 2.0,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          weeklyDeliveriesProvider.overrideWith(
            (ref) async => mockDeliveries,
          ),
        ],
        child: const MaterialApp(
          home: DashboardScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(
      find.text("This Week's Deliveries"),
      findsOneWidget,
    );

    expect(
      find.byType(ListView),
      findsOneWidget,
    );

    expect(
      find.byType(DeliveryCard),
      findsWidgets,
    );
  });
}
