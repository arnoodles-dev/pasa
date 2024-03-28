import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_app_config.freezed.dart';
part 'remote_app_config.g.dart';

@freezed
class RemoteAppConfig with _$RemoteAppConfig {
  const factory RemoteAppConfig({
    @JsonKey(name: 'is_maintenance') required bool isMaintenance,
    @JsonKey(name: 'min_supported_version') required String minSupportedVersion,
    @JsonKey(name: 'android_store_link') required String androidStoreLink,
    @JsonKey(name: 'ios_store_link') required String iosStoreLink,
    required Map<String, dynamic> en,
  }) = _RemoteAppConfig;

  const RemoteAppConfig._();

  // TODO: setup fallback values
  factory RemoteAppConfig.fallback() => const _RemoteAppConfig(
        isMaintenance: false,
        minSupportedVersion: '1.0.0',
        androidStoreLink: 'https://play.google.com/',
        iosStoreLink: 'https://www.apple.com/app-store/',
        en: <String, dynamic>{},
      );

  factory RemoteAppConfig.fromJson(Map<String, dynamic> json) =>
      _$RemoteAppConfigFromJson(json);
}
