import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/connectivity_provider.dart';
import '../../data/providers/delivery_providers.dart';
import '../../data/providers/delivery_refresh_provider.dart';
import '../widgets/delivery_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveriesState = ref.watch(weeklyDeliveriesProvider);
    final connectivity = ref.watch(connectivityProvider);
    final refreshState = ref.watch(deliveryRefreshProvider);

    final deliveries = deliveriesState.value ?? [];
    final isOffline = connectivity.value == false;
    final isRefreshing = refreshState.isLoading;
    final canRefresh = connectivity.value == true && !isRefreshing;
    final isCompact = MediaQuery.sizeOf(context).width < 360;

    void refresh() {
      ref.read(deliveryRefreshProvider.notifier).refresh();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PureDrop Dairy',
          style: TextStyle(
            color: Color(0xFF1677D2),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: canRefresh ? refresh : null,
            tooltip: 'Refresh deliveries',
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(
                isCompact ? 16 : 24,
                16,
                isCompact ? 16 : 24,
                24,
              ),
              itemCount: 1 + deliveries.length,
              itemBuilder: (context, index) {
                if (index > 0) {
                  final delivery = deliveries[index - 1];
                  return DeliveryCard(
                    key: ValueKey(delivery.id),
                    delivery: delivery,
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (isOffline)
                      Card(
                        color: const Color(0xFFFFF3D6),
                        child: ListTile(
                          leading: const Icon(
                            Icons.wifi_off_rounded,
                            color: Color(0xFF92400E),
                          ),
                          title: const Text("You're Offline"),
                          subtitle: Text(
                            deliveries.isEmpty
                                ? 'Connect to load deliveries.'
                                : 'Showing saved deliveries.',
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    const _SubscriptionHeader(),
                    const SizedBox(height: 24),
                    Text(
                      "This Week's Deliveries",
                      style: TextStyle(
                        fontSize: isCompact ? 18 : 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (isRefreshing && deliveries.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: LinearProgressIndicator(),
                      ),
                    if (refreshState.hasError ||
                        deliveriesState.hasError ||
                        connectivity.hasError)
                      Card(
                        child: ListTile(
                          title: Text(
                            deliveriesState.hasError
                                ? 'Unable to read saved deliveries.'
                                : connectivity.hasError
                                ? 'Unable to check the network connection.'
                                : 'Unable to refresh deliveries.',
                          ),
                          trailing: refreshState.hasError
                              ? TextButton(
                                  onPressed: canRefresh ? refresh : null,
                                  child: const Text('Retry'),
                                )
                              : null,
                        ),
                      ),
                    if (deliveries.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child:
                            deliveriesState.isLoading ||
                                isRefreshing ||
                                connectivity.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : !deliveriesState.hasError &&
                                  !refreshState.hasError &&
                                  !connectivity.hasError
                            ? Column(
                                children: [
                                  Text(
                                    isOffline
                                        ? 'No cached deliveries available'
                                        : 'No deliveries available',
                                    textAlign: TextAlign.center,
                                  ),
                                  TextButton(
                                    onPressed: canRefresh ? refresh : null,
                                    child: const Text('Retry'),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SubscriptionHeader extends StatelessWidget {
  const _SubscriptionHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1677D2), Color(0xFF0D47A1)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome back!', style: TextStyle(color: Colors.white70)),
          SizedBox(height: 8),
          Text(
            'PureDrop Customer',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text('Subscription: Active', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}