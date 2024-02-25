import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pasa/core/domain/entity/value_object.dart';
import 'package:pasa/features/home/presentation/widgets/post_container_header.dart';

import '../../../../utils/mock_localization.dart';
import '../../../../utils/test_utils.dart';

void main() {
  group(PostContainerHeader, () {
    goldenTest(
      'renders correctly',
      fileName: 'post_container_header'.goldensVersion,
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestScenario(
            name: 'default',
            child: MockLocalization(child: PostContainerHeader(post: mockPost)),
          ),
          GoldenTestScenario(
            name: 'without tag',
            child: MockLocalization(
              child: PostContainerHeader(
                post: mockPost.copyWith(linkFlairText: ValueString()),
              ),
            ),
          ),
        ],
      ),
    );
  });
}
