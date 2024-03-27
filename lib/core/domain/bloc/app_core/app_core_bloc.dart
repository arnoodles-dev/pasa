import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_service_core/features/analytics/i_analytics_repository.dart';
import 'package:pasa/app/constants/enum.dart';
import 'package:pasa/app/generated/assets.gen.dart';
import 'package:pasa/app/helpers/extensions/cubit_ext.dart';
import 'package:pasa/core/domain/interface/i_local_storage_repository.dart';

part 'app_core_bloc.freezed.dart';
part 'app_core_state.dart';

@lazySingleton
class AppCoreBloc extends Cubit<AppCoreState> {
  AppCoreBloc(this._analyticsRepository, this._localStorageRepository)
      : super(AppCoreState.initial());

  final IAnalyticsRepository _analyticsRepository;
  final ILocalStorageRepository _localStorageRepository;

  Future<void> initialize() async {
    await _analyticsRepository.logOnOpenApp();
    await _preloadSVG(_getSvgAssets());
    final bool isOnboardingDone =
        await _localStorageRepository.getIsOnboardingDone() ?? false;
    safeEmit(state.copyWith(isOnboardingDone: isOnboardingDone));
  }

  List<String> _getSvgAssets() {
    final List<String> svgPaths = <String>[];

    return svgPaths
      ..addAll(
        _filterSvgAssets(Assets.images.values), // get svgs in images folder
      )
      ..addAll(
        _filterSvgAssets(Assets.icons.values), // get svgs in icons folder
      );
  }

  Future<void> _preloadSVG(List<String> assetPaths) async {
    for (final String path in assetPaths) {
      final SvgAssetLoader loader = SvgAssetLoader(path);
      await svg.cache.putIfAbsent(
        loader.cacheKey(null),
        () => loader.loadBytes(null),
      );
    }
  }

  List<String> _filterSvgAssets(List<dynamic> assetPaths) => assetPaths
      .whereType<String>()
      .toList()
      .where((String path) => path.contains('.svg'))
      .toList();

  void setScrollControllers(
    Map<AppScrollController, ScrollController> scrollControllers,
  ) =>
      safeEmit(state.copyWith(scrollControllers: scrollControllers));

  Future<void> setOnboardingDone() async {
    await _localStorageRepository.setIsOnboardingDone();
    safeEmit(state.copyWith(isOnboardingDone: true));
  }

  bool get isOnboardingDone => state.isOnboardingDone;
}
