// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart' hide Route;
import 'package:flutter_test/flutter_test.dart';
import 'package:tree_router/src/builder.dart';
import 'package:tree_router/src/match.dart';
import 'package:tree_router/src/parameters.dart';
import 'package:tree_router/src/route.dart';

import 'helpers.dart';

void main() {
  group('buildRoute', () {
    testWidgets('returns a Navigator', (WidgetTester tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (BuildContext context) {
            final result = buildNavigator(
              context,
              RouteMatch(
                routes: [
                  StackedRoute(path: '/', builder: emptyBuilder),
                  StackedRoute(path: '/foo', builder: emptyBuilder),
                ],
                parameters: Parameters.empty(),
              ),
              () {},
            );

            expect(result, const TypeMatcher<Navigator>());
            final navigator = result as Navigator;
            expect(navigator.pages, hasLength(2));

            return const Placeholder();
          },
        ),
      );
    });
  });
}
