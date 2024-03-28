import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasa/app/constants/enum.dart';
import 'package:pasa/app/generated/assets.gen.dart';
import 'package:pasa/app/helpers/extensions/build_context_ext.dart';
import 'package:pasa/app/themes/app_spacing.dart';
import 'package:pasa/app/themes/app_text_style.dart';
import 'package:pasa/app/utils/url_launcher_utils.dart';
import 'package:pasa/core/domain/bloc/remote_config/remote_config_bloc.dart';
import 'package:pasa/core/presentation/widgets/pasa_button.dart';

class AppUpdateScreen extends StatelessWidget {
  const AppUpdateScreen({super.key});

  void _onUpdateNow(BuildContext context) {
    final String? storeLink = context.read<RemoteConfigBloc>().storeLink;
    if (storeLink?.isNotEmpty ?? false) {
      UrlLauncherUtils.openBrowser(storeLink!);
    }
  }

  @override
  Widget build(BuildContext context) {
    const double widthFactor = 0.8; // 80% of screen width
    const int logoSize = 200;
    return Scaffold(
      backgroundColor: context.colorScheme.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Insets.large),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Spacer(),
                //TODO: change to app logo
                Image.asset(
                  Assets.icons.launcherIcon.path,
                  fit: BoxFit.contain,
                  width: logoSize.toDouble(),
                  height: logoSize.toDouble(),
                  cacheHeight: logoSize,
                  cacheWidth: logoSize,
                ),
                Gap.xlarge(),
                FractionallySizedBox(
                  widthFactor: widthFactor,
                  child: Text(
                    context.i18n.app_update__label_text__title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: context.textTheme.displaySmall?.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: AppFontWeight.medium,
                    ),
                  ),
                ),
                Gap.large(),
                FractionallySizedBox(
                  widthFactor: widthFactor,
                  child: Text(
                    context.i18n.app_update__label_text__subtitle,
                    textAlign: TextAlign.center,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: context.colorScheme.secondary,
                    ),
                  ),
                ),
                const Spacer(),
                PasaButton(
                  buttonType: ButtonType.filled,
                  isExpanded: true,
                  text: context.i18n.app_update__button_text__update_now,
                  onPressed: () => _onUpdateNow(context),
                ),
                Gap.xxxlarge(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
