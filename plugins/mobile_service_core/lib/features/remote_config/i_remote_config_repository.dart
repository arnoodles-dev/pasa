import 'dart:async';

abstract class IRemoteConfigRepository {
  Future<StreamSubscription<dynamic>> initializeRemoteConfig(
    void Function(dynamic)? onData,
  );
  Future<Map<String, String>> fetchRemoteConfig();
}
