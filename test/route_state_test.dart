// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart' hide Route;
import 'package:flutter_test/flutter_test.dart';
import 'package:tree_router/src/delegate.dart';
import 'package:tree_router/src/parser.dart';
import 'package:tree_router/tree_router.dart';

void main() {
  group('RouteState.of', () {
    testWidgets('Returns a route state object', (WidgetTester tester) async {
      late final BuildContext childContext;
      final routes = [
        StackedRoute(
          path: '/',
          builder: (context) => Builder(
            builder: (BuildContext context) {
              childContext = context;
              return const Placeholder();
            },
          ),
        ),
      ];

      await tester.pumpWidget(
        _TestApp(
          routes: routes,
        ),
      );

      expect(RouteState.of(childContext), isNotNull);
    });
  });

  group('RouteState.goTo()', () {
    testWidgets('Navigates to the correct screen', (WidgetTester tester) async {
      late final BuildContext childContext;
      final routes = [
        StackedRoute(
          path: '/',
          builder: (context) {
            return Builder(
              builder: (BuildContext context) {
                childContext = context;
                return const Text('Home');
              },
            );
          },
        ),
        StackedRoute(
          path: '/a',
          builder: (context) {
            return const Text('Screen A');
          },
        ),
      ];

      await tester.pumpWidget(
        _TestApp(
          routes: routes,
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      final routeState = RouteState.of(childContext);
      if (routeState == null) fail('RouteState.of() returned null.');
      routeState.goTo('/a');
      await tester.pumpAndSettle();
      expect(find.text('Screen A'), findsOneWidget);
    });
  });
}

class _TestApp extends StatelessWidget {
  final List<Route> routes;

  const _TestApp({required this.routes, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: TreeRouterDelegate(routes),
      routeInformationParser: TreeRouteInformationParser(),
    );
  }
}
