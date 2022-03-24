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
                  Route(path: '/', builder: emptyBuilder),
                  Route(path: '/foo', builder: emptyBuilder),
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

    testWidgets('Builds a Navigator if when RouteType is nestedNavigator',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            late final BuildContext childContext;

            final topNavigator = buildNavigator(
              context,
              RouteMatch(
                routes: [
                  Route(
                    path: '/',
                    nestedBuilder: (context, child) {
                      return _ParentScreen(child: child);
                    },
                    type: RouteType.nested,
                  ),
                  Route(
                    path: 'foo',
                    builder: (context) {
                      childContext = context;
                      return const Placeholder();
                    },
                    type: RouteType.nestedNavigator,
                  ),
                ],
                parameters: Parameters.empty(),
              ),
              () {},
            );

            expect(Navigator.of(childContext), isNot(topNavigator));
            return const Placeholder();
          },
        ),
      );
    });
  });
}

class _ParentScreen extends StatelessWidget {
  final Widget child;

  const _ParentScreen({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
