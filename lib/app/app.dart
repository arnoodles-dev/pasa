import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pasa/app/constants/constant.dart';
import 'package:pasa/app/generated/l10n.dart';
import 'package:pasa/app/helpers/extensions/build_context_ext.dart';
import 'package:pasa/app/helpers/injection.dart';
import 'package:pasa/app/routes/app_router.dart';
import 'package:pasa/app/themes/app_theme.dart';
import 'package:pasa/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:pasa/core/domain/bloc/app_life_cycle/app_life_cycle_bloc.dart';
import 'package:pasa/core/domain/bloc/hidable/hidable_bloc.dart';
import 'package:pasa/core/domain/bloc/theme/theme_bloc.dart';
import 'package:pasa/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class App extends StatelessWidget {
  App({super.key});

  final AppRouter _appRouter = getIt<AppRouter>(param1: getIt<AuthBloc>());

  final List<BlocProvider<dynamic>> _providers = <BlocProvider<dynamic>>[
    BlocProvider<AuthBloc>(
      create: (BuildContext context) => getIt<AuthBloc>(),
    ),
    BlocProvider<ThemeBloc>(
      create: (BuildContext context) => getIt<ThemeBloc>(),
    ),
    BlocProvider<HidableBloc>(
      create: (BuildContext context) => getIt<HidableBloc>(),
    ),
    BlocProvider<AppCoreBloc>(
      create: (BuildContext context) => getIt<AppCoreBloc>(),
    ),
    BlocProvider<AppLifeCycleBloc>(
      create: (BuildContext context) => getIt<AppLifeCycleBloc>(),
    ),
  ];

  final List<Breakpoint> _breakpoints = <Breakpoint>[
    const Breakpoint(
      start: 0,
      end: Constant.mobileBreakpoint,
      name: MOBILE,
    ),
    const Breakpoint(
      start: Constant.mobileBreakpoint + 1,
      end: Constant.tabletBreakpoint,
      name: TABLET,
    ),
    const Breakpoint(
      start: Constant.tabletBreakpoint + 1,
      end: double.infinity,
      name: DESKTOP,
    ),
  ];

  final List<LocalizationsDelegate<dynamic>> _localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  List<Condition<double>> _getResponsiveWidth(BuildContext context) =>
      <Condition<double>>[
        const Condition<double>.equals(
          name: MOBILE,
          value: Constant.mobileBreakpoint,
        ),
        const Condition<double>.equals(
          name: TABLET,
          value: Constant.tabletBreakpoint,
        ),
        Condition<double>.equals(
          name: DESKTOP,
          value: context.screenWidth,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    /// This will tell you which image is oversized by throwing an exception.
    debugInvertOversizedImages = true;
    return MultiBlocProvider(
      providers: _providers,
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (BuildContext context, ThemeMode themeMode) =>
            MaterialApp.router(
          routerConfig: _appRouter.router,
          builder: (BuildContext context, Widget? child) =>
              ResponsiveBreakpoints.builder(
            child: Builder(
              builder: (BuildContext context) => ResponsiveScaledBox(
                width: ResponsiveValue<double>(
                  context,
                  defaultValue: Constant.mobileBreakpoint,
                  conditionalValues: _getResponsiveWidth(context),
                ).value,
                child: child!,
              ),
            ),
            breakpoints: _breakpoints,
          ),
          title: Constant.appName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          localizationsDelegates: _localizationsDelegates,
          supportedLocales: AppLocalizations.delegate.supportedLocales,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
