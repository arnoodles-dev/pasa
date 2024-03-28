// import 'package:flash/flash.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:pasa/app/constants/constant.dart';
// import 'package:pasa/app/constants/enum.dart';
// import 'package:pasa/app/constants/mock_data.dart';
// import 'package:pasa/app/helpers/extensions/build_context_ext.dart';
// import 'package:pasa/app/themes/app_spacing.dart';
// import 'package:pasa/app/utils/dialog_utils.dart';
// import 'package:pasa/app/utils/error_message_utils.dart';
// import 'package:pasa/core/domain/bloc/app_core/app_core_bloc.dart';
// import 'package:pasa/core/domain/bloc/theme/theme_bloc.dart';
// import 'package:pasa/core/domain/entity/failure.dart';
// import 'package:pasa/core/domain/entity/user.dart';
// import 'package:pasa/core/presentation/widgets/pasa_app_bar.dart';
// import 'package:pasa/core/presentation/widgets/pasa_avatar.dart';
// import 'package:pasa/core/presentation/widgets/pasa_button.dart';
// import 'package:pasa/core/presentation/widgets/pasa_info_text_field.dart';
// import 'package:pasa/features/auth/domain/bloc/auth/auth_bloc.dart';
// import 'package:skeletonizer/skeletonizer.dart';

import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => const ColoredBox(
        color: Colors.red,
        child: Center(
          child: Text('PROFILE SCREEN'),
        ),
      );
}

// class ProfileScreen extends HookWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final ValueNotifier<bool> isDialogShowing = useState(false);
//     final Color iconColor = context.colorScheme.onSecondaryContainer;

//     return Scaffold(
//       backgroundColor: context.colorScheme.background,
//       appBar: PasaAppBar(
//         titleColor: context.colorScheme.primary,
//         actions: <Widget>[
//           IconButton(
//             onPressed: () => context
//                 .read<ThemeBloc>()
//                 .switchTheme(Theme.of(context).brightness),
//             icon: Theme.of(context).brightness == Brightness.dark
//                 ? Icon(Icons.light_mode, color: iconColor)
//                 : Icon(Icons.dark_mode, color: iconColor),
//           ),
//         ],
//       ),
//       body: Center(
//         child: ConstrainedBox(
//           constraints: const BoxConstraints(
//             maxWidth: Constant.mobileBreakpoint,
//           ),
//           child: RefreshIndicator(
//             onRefresh: () => context.read<AuthBloc>().getUser(),
//             child: BlocSelector<AppCoreBloc, AppCoreState,
//                 Map<AppScrollController, ScrollController>>(
//               selector: (AppCoreState state) => state.scrollControllers,
//               builder: (
//                 BuildContext context,
//                 Map<AppScrollController, ScrollController> scrollControllers,
//               ) =>
//                   CustomScrollView(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 controller: scrollControllers.isNotEmpty
//                     ? scrollControllers[AppScrollController.profile]
//                     : ScrollController(),
//                 slivers: <Widget>[
//                   SliverFillRemaining(
//                     child: BlocConsumer<AuthBloc, AuthState>(
//                       listener: (BuildContext context, AuthState state) =>
//                           _onStateChangedListener(
//                         context,
//                         state,
//                         isDialogShowing,
//                       ),
//                       buildWhen: _buildWhen,
//                       builder: (BuildContext context, AuthState authState) =>
//                           authState.maybeWhen(
//                         orElse: () => Skeletonizer(
//                           child: _ProfileContent(user: MockData.user),
//                         ),
//                         authenticated: (User user) =>
//                             _ProfileContent(user: user),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _onStateChangedListener(
//     BuildContext context,
//     AuthState state,
//     ValueNotifier<bool> isDialogShowing,
//   ) {
//     state.whenOrNull(
//       failed: (Failure failure) async {
//         isDialogShowing.value = true;

//         await DialogUtils.showError(
//           context,
//           ErrorMessageUtils.generate(context, failure),
//           position: FlashPosition.top,
//         );
//         isDialogShowing.value = false;
//       },
//     );
//   }

//   bool _buildWhen(_, AuthState current) => current.maybeMap(
//         orElse: () => true,
//         failed: (_) => false,
//       );
// }

// class _ProfileContent extends StatelessWidget {
//   const _ProfileContent({
//     required this.user,
//   });

//   final User user;

//   @override
//   Widget build(BuildContext context) => Padding(
//         padding: const EdgeInsets.symmetric(
//           horizontal: Insets.xlarge,
//         ),
//         child: Column(
//           children: <Widget>[
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   _ProfileName(user: user),
//                   _ProfileDetails(user: user),
//                 ],
//               ),
//             ),
//             PasaButton(
//               text: context.i18n.profile__button_text__logout,
//               isExpanded: true,
//               buttonType: ButtonType.filled,
//               onPressed: () => context.read<AuthBloc>().logout(),
//               padding: EdgeInsets.zero,
//               contentPadding: const EdgeInsets.symmetric(
//                 vertical: Insets.small,
//               ),
//             ),
//             const Gap(Insets.large),
//           ],
//         ),
//       );
// }

// class _ProfileDetails extends StatelessWidget {
//   const _ProfileDetails({
//     required this.user,
//   });

//   final User user;

//   @override
//   Widget build(BuildContext context) => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Gap.small(),
//           PasaInfoTextField(
//             title: context.i18n.profile__label_text__email,
//             description: user.email.getOrCrash(),
//           ),
//           Gap.small(),
//           PasaInfoTextField(
//             title: context.i18n.profile__label_text__phone_number,
//             description: user.contactNumber.getOrCrash(),
//           ),
//           Gap.small(),
//           PasaInfoTextField(
//             title: context.i18n.profile__label_text__gender,
//             description: user.gender.name.capitalize(),
//           ),
//           Gap.small(),
//           PasaInfoTextField(
//             title: context.i18n.profile__label_text__birthday,
//             description: user.birthday.defaultFormat(),
//           ),
//           Gap.small(),
//           PasaInfoTextField(
//             title: context.i18n.profile__label_text__age,
//             description: user.age,
//           ),
//         ],
//       );
// }

// class _ProfileName extends StatelessWidget {
//   const _ProfileName({
//     required this.user,
//   });

//   final User user;

//   @override
//   Widget build(BuildContext context) {
//     final TextStyle? nameStyle = context.textTheme.headlineMedium?.copyWith(
//       color: context.colorScheme.onSecondaryContainer,
//     );

//     return Row(
//       children: <Widget>[
//         PasaAvatar(
//           size: 80,
//           imageUrl: user.avatar?.getOrCrash(),
//         ),
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.all(Insets.large),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text(
//                   user.firstName.getOrCrash(),
//                   style: nameStyle,
//                 ),
//                 Text(
//                   user.lastName.getOrCrash(),
//                   style: nameStyle,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
