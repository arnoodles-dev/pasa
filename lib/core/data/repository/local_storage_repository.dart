import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:pasa/app/helpers/injection.dart';
import 'package:pasa/core/domain/interface/i_local_storage_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class _Keys {
  static const String accessToken = 'access_token';
  static const String idToken = 'id_token';
  static const String isOnboardingDone = 'is_onboarding_done';
}

@LazySingleton(as: ILocalStorageRepository)
class LocalStorageRepository implements ILocalStorageRepository {
  const LocalStorageRepository(
    this._securedStorage,
    this._unsecuredStorage,
  );

  final FlutterSecureStorage _securedStorage;
  final SharedPreferences _unsecuredStorage;

  Logger get logger => getIt<Logger>();

  /// Secured Storage services
  @override
  Future<String?> getAccessToken() =>
      _securedStorage.read(key: _Keys.accessToken);
  @override
  Future<void> setAccessToken(String? value) async {
    try {
      await _securedStorage.write(key: _Keys.accessToken, value: value);
    } catch (error) {
      logger.e(error.toString());
      throw Exception(error);
    }
  }

  @override
  Future<String?> getIdToken() => _securedStorage.read(key: _Keys.idToken);
  @override
  Future<void> setIdToken(String? value) async {
    try {
      await _securedStorage.write(key: _Keys.idToken, value: value);
    } catch (error) {
      logger.e(error.toString());
      throw Exception(error);
    }
  }

  /// Unsecured storage services
  @override
  Future<bool?> getIsOnboardingDone() async =>
      _unsecuredStorage.getBool(_Keys.isOnboardingDone);

  @override
  Future<void> setIsOnboardingDone() async {
    try {
      await _unsecuredStorage.setBool(_Keys.isOnboardingDone, true);
    } catch (error) {
      logger.e(error.toString());
      throw Exception(error);
    }
  }
}
