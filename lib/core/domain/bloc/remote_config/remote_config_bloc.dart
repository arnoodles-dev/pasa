import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_service_core/features/remote_config/i_remote_config_repository.dart';
import 'package:pasa/app/generated/assets.gen.dart';
import 'package:pasa/app/helpers/app_localization.dart';
import 'package:pasa/app/helpers/extensions/cubit_ext.dart';
import 'package:pasa/app/helpers/extensions/string_ext.dart';
import 'package:pasa/core/data/dto/remote_app_config.dart';
import 'package:pasa/core/domain/interface/i_device_repository.dart';

@lazySingleton
class RemoteConfigBloc extends Cubit<Map<String, dynamic>> {
  RemoteConfigBloc(
    this._remoteConfigRepository,
    this._deviceRepository,
  ) : super(<String, dynamic>{});

  final IRemoteConfigRepository _remoteConfigRepository;
  final IDeviceRepository _deviceRepository;

  Future<void> initialize() async {
    await fetchRemoteConfig();
    await _remoteConfigRepository
        .initializeRemoteConfig((_) => fetchRemoteConfig());
    await updateLocalization();
  }

  // Fetch Remote Config values
  Future<void> fetchRemoteConfig() async {
    try {
      final Map<String, String> config =
          await _remoteConfigRepository.fetchRemoteConfig();
      safeEmit(config);
    } catch (e) {
      final String localLocalization =
          await rootBundle.loadString(Assets.i18n.enUS);

      safeEmit(
        RemoteAppConfig.fallback()
            .copyWith(en: jsonDecode(localLocalization) as Map<String, dynamic>)
            .toJson(),
      );
    }
  }

  Map<String, dynamic> getLocale(String locale) =>
      jsonDecode(state[locale] as String) as Map<String, dynamic>;

  bool get isMaintenance {
    try {
      final String configValue = state['isMaintenance'] as String;
      return configValue.toBoolean;
    } catch (_) {
      return false;
    }
  }

  bool get isForceUpdate {
    try {
      final String configValue = state['minSupportedVersion'] as String;
      return _isForceUpdate(configValue);
    } catch (_) {
      return false;
    }
  }

  String? get storeLink {
    try {
      if (Platform.isAndroid) {
        return state['android_storelink'] as String;
      } else if (Platform.isIOS) {
        return state['ios_storelink'] as String;
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  bool _isForceUpdate(String minSupportedVersion) {
    final int minimumVersion =
        int.tryParse(minSupportedVersion.replaceAll('.', '')) ?? 1;
    final int appVersion =
        int.tryParse(_deviceRepository.getAppVersion().replaceAll('.', '')) ??
            1;

    return appVersion < minimumVersion;
  }

  Future<void> updateLocalization() async {
    try {
      final String jsonString = await rootBundle.loadString(Assets.i18n.enUS);
      final Map<String, dynamic> localLocalization =
          jsonDecode(jsonString) as Map<String, dynamic>;
      final String? remoteStrings =
          state[AppLocalization.locale?.languageCode] as String?;
      if (remoteStrings != null) {
        final Map<String, dynamic> remoteLocalization =
            jsonDecode(remoteStrings) as Map<String, dynamic>;
        AppLocalization().content =
            mergeMaps(localLocalization, remoteLocalization);
      } else {
        AppLocalization().content = localLocalization;
      }
    } catch (e) {
      // Do nothing, a fallback file is already generated on app startup
    }
  }
}
