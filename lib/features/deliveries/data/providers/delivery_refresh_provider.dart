import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/connectivity_provider.dart';
import 'delivery_providers.dart';

final deliveryRefreshProvider =
    NotifierProvider<DeliveryRefreshNotifier, AsyncValue<void>>(
      DeliveryRefreshNotifier.new,
    );

class DeliveryRefreshNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() {
    ref.listen<AsyncValue<bool>>(connectivityProvider, (previous, next) {
      if (next.value == true && previous?.value != true) {
        unawaited(
          Future<void>.microtask(() async {
            if (ref.mounted) {
              await refresh();
            }
          }),
        );
      }
    }, fireImmediately: true);

    return const AsyncData<void>(null);
  }

  Future<void> refresh() async {
    if (state.isLoading || ref.read(connectivityProvider).value != true) {
      return;
    }

    state = const AsyncLoading<void>();

    try {
      await ref.read(deliveryRepositoryProvider).refreshDeliveries();

      if (ref.mounted) {
        state = const AsyncData<void>(null);
      }
    } catch (error, stackTrace) {
      if (ref.mounted) {
        state = AsyncError<void>(error, stackTrace);
      }
    }
  }
}
