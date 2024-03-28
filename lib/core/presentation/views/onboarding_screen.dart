import 'package:dartx/dartx.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pasa/app/constants/enum.dart';
import 'package:pasa/app/generated/assets.gen.dart';
import 'package:pasa/app/helpers/extensions/build_context_ext.dart';
import 'package:pasa/app/routes/route_name.dart';
import 'package:pasa/app/themes/app_sizes.dart';
import 'package:pasa/app/themes/app_spacing.dart';
import 'package:pasa/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:pasa/core/presentation/widgets/pasa_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends HookWidget {
  const OnboardingScreen({super.key});

  static const int totalPages = 3;
  static final Faker faker = Faker();

  //TODO: delete this once  onboarding title/subtitle is finalize
  static final String title1 = faker.lorem.words(3).join(' ');
  static final String title2 = faker.lorem.words(3).join(' ');
  static final String title3 = faker.lorem.words(3).join(' ');
  static final String body1 = faker.lorem.sentences(2).join(' ');
  static final String body2 = faker.lorem.sentences(2).join(' ');
  static final String body3 = faker.lorem.sentences(2).join(' ');

  String _getTitle(int index) =>
      switch (index) { 0 => title1, 1 => title2, 2 => title3, _ => '' };

  String _getBody(int index) =>
      switch (index) { 0 => body1, 1 => body2, 2 => body3, _ => '' };

  //TODO: finalize onboarding page images
  String _getImagePath(int index) => switch (index) {
        0 => Assets.images.onboardingTravel,
        1 => Assets.images.onboardingDeliver,
        2 => Assets.images.onboardingEarn,
        _ => ''
      };

  void _onNext(PageController pageController, int index) =>
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );

  Future<void> _onDone(BuildContext context) async {
    await context.read<AppCoreBloc>().setOnboardingDone();
    if (context.mounted) {
      GoRouter.of(context).goNamed(RouteName.login.name);
    }
  }

  void _onSkip(PageController pageController) => pageController.animateToPage(
        totalPages - 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );

  @override
  Widget build(BuildContext context) {
    final PageController pageController = usePageController();
    final ValueNotifier<int> index = useState<int>(0);
    const double indicatorSize = AppSizes.size8;

    return Scaffold(
      backgroundColor: context.colorScheme.background,
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView.builder(
              itemCount: totalPages,
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) => _OnBoardingPage(
                imagePath: _getImagePath(index),
                title: _getTitle(index),
                body: _getBody(index),
              ),
              onPageChanged: (int value) => index.value = value,
            ),
          ),
          Gap.large(),
          SmoothPageIndicator(
            controller: pageController,
            count: totalPages,
            effect: ExpandingDotsEffect(
              dotWidth: indicatorSize,
              dotHeight: indicatorSize,
              activeDotColor: context.colorScheme.primary,
            ),
          ),
          Gap.large(),
          _OnBoardingFooter(
            index: index,
            onDone: () => _onDone(context),
            onNext: () => _onNext(pageController, index.value + 1),
            onSkip: () => _onSkip(pageController),
          ),
        ],
      ),
    );
  }
}

class _OnBoardingFooter extends StatelessWidget {
  const _OnBoardingFooter({
    required this.index,
    required this.onDone,
    required this.onNext,
    required this.onSkip,
  });

  final ValueNotifier<int> index;
  final VoidCallback onDone;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = index.value >= OnboardingScreen.totalPages - 1;

    return Padding(
      padding: const EdgeInsets.all(Insets.large),
      child: Column(
        children: <Widget>[
          PasaButton(
            padding: EdgeInsets.zero,
            text: isLastPage
                ? context.i18n.onboarding__button_text__get_started
                : context.i18n.common_next.capitalize(),
            isExpanded: true,
            buttonType: ButtonType.filled,
            onPressed: () => isLastPage ? onDone() : onNext(),
          ),
          Gap.large(),
          if (!isLastPage) ...<Widget>[
            PasaButton(
              text: context.i18n.common_skip.capitalize(),
              isExpanded: true,
              buttonType: ButtonType.text,
              onPressed: onSkip,
              contentPadding: const EdgeInsets.all(Insets.xsmall),
              padding: EdgeInsets.zero,
            ),
          ],
        ],
      ),
    );
  }
}

class _OnBoardingPage extends StatelessWidget {
  const _OnBoardingPage({
    required this.imagePath,
    required this.title,
    required this.body,
  });

  final String imagePath;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    const double widthFactor = 0.8; // 90% of screen width
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.large),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox.square(
            dimension: context.screenWidth * widthFactor,
            child: SvgPicture.asset(
              imagePath,
              alignment: Alignment.bottomCenter,
            ),
          ),
          Gap.xxxlarge(),
          FractionallySizedBox(
            widthFactor: widthFactor,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: context.textTheme.displaySmall?.copyWith(
                color: context.colorScheme.primary,
              ),
            ),
          ),
          Gap.large(),
          FractionallySizedBox(
            widthFactor: widthFactor,
            child: Text(
              body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
