import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pasa/app/themes/app_sizes.dart';

class PasaIcon extends StatelessWidget {
  const PasaIcon({required this.icon, super.key, this.size, this.color});

  final Either<String, IconData> icon;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: size ?? AppSizes.size24,
        child: icon.fold(
          (String path) => SvgPicture.asset(
            path,
            colorFilter: color != null
                ? ColorFilter.mode(color!, BlendMode.color)
                : null,
          ),
          (IconData iconData) => Icon(
            iconData,
            color: color,
          ),
        ),
      );
}
