# Technical Decision Log

## Why Riverpod?

I chose Riverpod because the dashboard needs to update whenever the Hive cache
changes. A StreamProvider gives the dashboard the saved delivery list, and a
separate notifier handles refresh loading and errors. Provider overrides let me
test the dashboard with sample streams.

Provider with ChangeNotifier could also work, but I would need to manage the
stream subscription and notify the UI myself. BLoC gives explicit events and
states, which would be useful for a more complex workflow. For this dashboard,
Riverpod keeps the repository and cache updates easy to connect. The trade-off
is learning how provider lifecycles and async states work.