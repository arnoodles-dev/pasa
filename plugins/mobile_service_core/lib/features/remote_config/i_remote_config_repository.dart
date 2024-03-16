abstract class IRemoteConfigRepository {
  Future<void> initializeRemoteConfig(
    void Function(dynamic)? onData,
  );
  Future<Map<String, String>> fetchRemoteConfig();
}
