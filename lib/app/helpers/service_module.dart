import 'package:chopper/chopper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_service_core/features/analytics/i_analytics_repository.dart';
import 'package:mobile_service_core/features/crashlytics/i_crashlytics_repository.dart';
import 'package:mobile_service_core/features/remote_config/i_remote_config_repository.dart';
import 'package:mobile_service_core/mobile_service_core.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pasa/app/config/app_config.dart';
import 'package:pasa/app/helpers/injection.dart';
import 'package:pasa/features/home/data/service/post_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
abstract class ServiceModule {
  //Local Storage Service
  @lazySingleton
  FlutterSecureStorage get flutterSecureStorage => const FlutterSecureStorage();

  @lazySingleton
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  //Device Service
  @lazySingleton
  @preResolve
  Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();

  @lazySingleton
  DeviceInfoPlugin get deviceInfo => DeviceInfoPlugin();

  //Backend Service
  @lazySingleton
  SupabaseClient get supabase => Supabase.instance.client;

  @lazySingleton
  IAnalyticsRepository get analytics =>
      getIt<IMobileServiceRepository>().analyticsRepository;

  @lazySingleton
  IRemoteConfigRepository get remoteConfig =>
      getIt<IMobileServiceRepository>().remoteConfigRepository;

  @lazySingleton
  ICrashlyticsRepository get crashlytics =>
      getIt<IMobileServiceRepository>().crashlyticsRepository;

  @lazySingleton
  GoogleSignIn get googleSignIn => GoogleSignIn(
        clientId: AppConfig.iosAuthClientId,
        serverClientId: AppConfig.webAuthClientId,
      );

  @lazySingleton
  PostService get postService =>
      getIt<ChopperClient>().getService<PostService>();
}
