import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:mobile_service_core/features/remote_config/i_remote_config_repository.dart';

class GMSRemoteConfigRepository implements IRemoteConfigRepository {
  GMSRemoteConfigRepository() : _remoteConfig = FirebaseRemoteConfig.instance;

  final FirebaseRemoteConfig _remoteConfig;

  @override
  Future<void> initializeRemoteConfig(
    void Function(RemoteConfigUpdate)? onData,
  ) async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 10),
      ),
    );
    _remoteConfig.onConfigUpdated.listen(onData);
  }

  @override
  Future<Map<String, String>> fetchRemoteConfig() async {
    await _remoteConfig.fetchAndActivate();

    return _remoteConfig.getAll().map(
          (String key, RemoteConfigValue value) =>
              MapEntry<String, String>(key, value.asString()),
        );
  }
}
