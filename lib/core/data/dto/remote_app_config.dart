import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_app_config.freezed.dart';
part 'remote_app_config.g.dart';

@freezed
class RemoteAppConfig with _$RemoteAppConfig {
  const factory RemoteAppConfig({
    required bool isMaintenance,
    required String minSupportedVersion,
    required Map<String, dynamic> en,
  }) = _RemoteAppConfig;

  const RemoteAppConfig._();

  // TODO: setup fallback values
  factory RemoteAppConfig.fallback() => const _RemoteAppConfig(
        isMaintenance: false,
        minSupportedVersion: '1.0.0',
        en: <String, dynamic>{},
      );

  factory RemoteAppConfig.fromJson(Map<String, dynamic> json) =>
      _$RemoteAppConfigFromJson(json);
}
