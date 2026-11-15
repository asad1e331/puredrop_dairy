import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = StreamProvider.autoDispose<bool>((ref) async* {
  final connectivity = Connectivity();

  final initialStatus = await connectivity.checkConnectivity();

  yield _hasNetwork(initialStatus);

  yield* connectivity.onConnectivityChanged.map(_hasNetwork).distinct();
});

bool _hasNetwork(List<ConnectivityResult> results) {
  return results.any((result) => result != ConnectivityResult.none);
}
