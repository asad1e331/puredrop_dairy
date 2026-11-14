import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/delivery_providers.dart';
import '../widgets/delivery_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveriesAsync = ref.watch(weeklyDeliveriesProvider);

    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < 360;

    final horizontalPadding = isCompact ? 16.0 : 24.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text(
          'PureDrop Dairy',
          style: TextStyle(
            color: Color(0xFF1677D2),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
            tooltip: 'Notifications',
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // Customer information
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1677D2), Color(0xFF0D47A1)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome back!',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'PureDrop Customer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isCompact ? 20 : 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Row(
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Subscription: Active',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  Text(
                    "This Week's Deliveries",
                    style: TextStyle(
                      fontSize: isCompact ? 18 : 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF172B4D),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Track your daily milk deliveries',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                  ),

                  const SizedBox(height: 18),

                  // Riverpod loading, error, data states
                  Expanded(
                    child: deliveriesAsync.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),

                      error: (error, stackTrace) => Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 40,
                            ),
                            const SizedBox(height: 12),
                            const Text('Unable to load deliveries'),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                ref.invalidate(weeklyDeliveriesProvider);
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),

                      data: (deliveries) {
                        if (deliveries.isEmpty) {
                          return const Center(
                            child: Text('No deliveries available'),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.only(bottom: 24),
                          itemCount: deliveries.length,
                          itemBuilder: (context, index) {
                            final delivery = deliveries[index];

                            return DeliveryCard(delivery: delivery);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
