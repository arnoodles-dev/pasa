import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pasa/app/constants/constant.dart';
import 'package:pasa/app/generated/assets.gen.dart';
import 'package:pasa/app/helpers/extensions/build_context_ext.dart';
import 'package:pasa/app/helpers/injection.dart';
import 'package:pasa/app/themes/app_spacing.dart';
import 'package:pasa/app/themes/app_text_style.dart';
import 'package:pasa/app/utils/dialog_utils.dart';
import 'package:pasa/app/utils/error_message_utils.dart';
import 'package:pasa/core/domain/entity/failure.dart';
import 'package:pasa/core/presentation/widgets/connectivity_checker.dart';
import 'package:pasa/core/presentation/widgets/pasa_button.dart';
import 'package:pasa/core/presentation/widgets/pasa_icon.dart';
import 'package:pasa/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:pasa/features/auth/domain/bloc/login/login_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  void _onPopInvoked(BuildContext context, bool didPop) {
    if (!didPop) {
      DialogUtils.showExitDialog(context);
    }
  }

  void _onStateChangedListener(BuildContext context, LoginState state) {
    state.loginStatus.whenOrNull(
      success: () => context.read<AuthBloc>().authenticate(),
      failed: (Failure failure) => DialogUtils.showError(
        context,
        ErrorMessageUtils.generate(context, failure),
        position: FlashPosition.top,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) => _onPopInvoked(context, didPop),
        child: BlocProvider<LoginBloc>(
          create: (BuildContext context) => getIt<LoginBloc>(),
          child: Builder(
            builder: (BuildContext context) =>
                BlocListener<LoginBloc, LoginState>(
              listener: _onStateChangedListener,
              child: ConnectivityChecker.scaffold(
                backgroundColor: context.colorScheme.primary,
                body: Center(
                  child: Container(
                    padding: const EdgeInsets.all(Insets.xlarge),
                    constraints: const BoxConstraints(
                      maxWidth: Constant.mobileBreakpoint,
                    ),
                    child: Column(
                      children: <Widget>[
                        const Spacer(),
                        Center(
                          child: Text(
                            Constant.appName.toUpperCase().split('').join(' '),
                            textAlign: TextAlign.center,
                            style: context.textTheme.displayLarge?.copyWith(
                              color: context.colorScheme.onPrimary,
                              fontSize: 84,
                              fontWeight: AppFontWeight.black,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Spacer(),
                        PasaButton(
                          icon: PasaIcon(
                            icon: left(Assets.icons.google),
                          ),
                          text: context.i18n.login__button_text__login_google,
                          isExpanded: true,
                          onPressed: () => context
                              .read<LoginBloc>()
                              .loginWithProvider(OAuthProvider.google),
                          padding: EdgeInsets.zero,
                        ),
                        Gap.large(),
                        PasaButton(
                          icon: PasaIcon(
                            icon: left(Assets.icons.facebook),
                          ),
                          text: context.i18n.login__button_text__login_facebook,
                          isExpanded: true,
                          onPressed: () => context
                              .read<LoginBloc>()
                              .loginWithProvider(OAuthProvider.facebook),
                          padding: EdgeInsets.zero,
                        ),
                        Gap.medium(),
                        const _LoginButtonDivider(),
                        Gap.medium(),
                        PasaButton(
                          icon: PasaIcon(
                            icon: right(Icons.call_rounded),
                            color: context.colorScheme.primary,
                          ),
                          text: context.i18n.login__button_text__login_mobile,
                          isExpanded: true,
                          onPressed: () => DialogUtils.showError(
                            context,
                            context.i18n.common_error_feature_unavailable,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class _LoginButtonDivider extends StatelessWidget {
  const _LoginButtonDivider();

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          Expanded(
            child: Divider(
              color: context.colorScheme.onPrimary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Insets.medium,
            ),
            child: Text(
              context.i18n.common_or,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onPrimary,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: context.colorScheme.onPrimary,
            ),
          ),
        ],
      );
}
