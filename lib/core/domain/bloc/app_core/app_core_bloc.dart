import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_service_core/features/analytics/i_analytics_repository.dart';
import 'package:pasa/app/constants/enum.dart';
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
    final bool isOnboardingDone =
        await _localStorageRepository.getIsOnboardingDone() ?? false;
    safeEmit(state.copyWith(isOnboardingDone: isOnboardingDone));
  }

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
