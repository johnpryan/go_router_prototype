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

    testWidgets(
        'Navigates to the correct screen when provided with a'
        ' relative route path',(WidgetTester tester) async {
      BuildContext? rootContext;
      BuildContext? aContext;
      BuildContext? bContext;
      final routes = [
        StackedRoute(
          path: '/',
          builder: (context) {
            rootContext ??= context;
            return const Text('Home');
          },
          children: [
            StackedRoute(
              path: 'a',
              builder: (context) {
                aContext ??= context;
                return const Text('Screen A');
              },
              children: [
                StackedRoute(
                  path: 'b',
                  builder: (context) {
                    bContext ??= context;
                    return const Text('Screen B');
                  },
                ),
              ],
            ),
          ],
        ),
      ];

      await tester.pumpWidget(
        _TestApp(
          routes: routes,
        ),
      );

      expect(find.text('Home'), findsOneWidget);

      // Navigate to 'a'
      var routeState = RouteState.of(rootContext!);
      if (routeState == null) fail('RouteState.of() returned null.');
      routeState.goTo('a');
      await tester.pumpAndSettle();
      expect(find.text('Screen A'), findsOneWidget);

      // Navigate to 'b'
      routeState = RouteState.of(aContext!);
      if (routeState == null) fail('RouteState.of() returned null.');
      routeState.goTo('b');
      await tester.pumpAndSettle();
      expect(find.text('Screen B'), findsOneWidget);
    }, skip: true);
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
