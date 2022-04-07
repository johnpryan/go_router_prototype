// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart' hide Route;
import 'package:flutter_test/flutter_test.dart';
import 'package:tree_router/src/delegate.dart';
import 'package:tree_router/src/parser.dart';
import 'package:tree_router/tree_router.dart';

void main() {
  group('RouteState', () {
    testWidgets('.of() Returns a route state object',
        (WidgetTester tester) async {
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

    testWidgets('goTo() Navigates to the correct screen',
        (WidgetTester tester) async {
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

    testWidgets('pop() Navigates to the correct screen',
        (WidgetTester tester) async {
      BuildContext? childContext;
      final routes = [
        StackedRoute(
          path: '/',
          builder: (context) {
            return Builder(
              builder: (BuildContext context) {
                childContext ??= context;
                return const Text('Home');
              },
            );
          },
          routes: [
            StackedRoute(
              path: 'a',
              builder: (context) {
                return const Text('Screen A');
              },
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
      final routeState = RouteState.of(childContext!);
      if (routeState == null) fail('RouteState.of() returned null.');

      routeState.goTo('/a');
      await tester.pumpAndSettle();
      expect(find.text('Screen A'), findsOneWidget);

      routeState.pop();
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets(
        'Navigates to the correct screen when provided with a relative route path',
        (WidgetTester tester) async {
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
          routes: [
            StackedRoute(
              path: 'a',
              builder: (context) {
                aContext ??= context;
                return const Text('Screen A');
              },
              routes: [
                StackedRoute(
                  path: 'b/:id',
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
      expect(GlobalRouteState.of(rootContext!)!.match.routes, hasLength(1));

      // Navigate to 'a'
      var routeState = RouteState.of(rootContext!);
      expect(routeState, isNotNull);
      routeState!.goTo('a');
      await tester.pumpAndSettle();
      expect(find.text('Screen A'), findsOneWidget);
      expect(GlobalRouteState.of(aContext!)!.match.routes, hasLength(2));

      // Navigate to 'b'
      routeState = RouteState.of(aContext!);
      expect(routeState, isNotNull);
      routeState!.goTo('b/123');
      await tester.pumpAndSettle();
      expect(find.text('Screen B'), findsOneWidget);
      expect(GlobalRouteState.of(bContext!)!.match.routes, hasLength(3));
      expect(RouteState.of(bContext!)!.pathParameters, hasLength(1));
    });

    testWidgets('Relative route paths include path parameters',
        (WidgetTester tester) async {
      BuildContext? rootContext;
      BuildContext? aContext;
      final routes = [
        StackedRoute(
          path: '/',
          builder: (context) {
            rootContext ??= context;
            return const Text('Home');
          },
          routes: [
            StackedRoute(
              path: 'a/:id',
              builder: (context) {
                aContext ??= context;
                return const Text('Screen A');
              },
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
      expect(GlobalRouteState.of(rootContext!)!.match.routes, hasLength(1));

      // Navigate to 'a'
      var routeState = RouteState.of(rootContext!);
      expect(routeState, isNotNull);
      routeState!.goTo('a/123');
      await tester.pumpAndSettle();
      expect(find.text('Screen A'), findsOneWidget);
      expect(GlobalRouteState.of(aContext!)!.match.routes, hasLength(2));
      expect(RouteState.of(aContext!)!.pathParameters, hasLength(1));
    });

    testWidgets(
        'Relative route paths include path parameters of the parent route',
        (WidgetTester tester) async {
      BuildContext? rootContext;
      BuildContext? aContext;
      final routes = [
        StackedRoute(
          path: '/',
          builder: (context) {
            rootContext ??= context;
            return const Text('Home');
          },
          routes: [
            StackedRoute(
              path: 'a/:id',
              builder: (context) {
                aContext ??= context;
                return const Text('Screen A');
              },
              routes: [
                StackedRoute(
                    path: 'details',
                    builder: (context) {
                      return const Text('Screen A Details');
                    }),
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
      expect(GlobalRouteState.of(rootContext!)!.match.routes, hasLength(1));

      // Navigate to 'a'
      var routeState = RouteState.of(rootContext!);
      expect(routeState, isNotNull);
      routeState!.goTo('a/123');

      await tester.pumpAndSettle();
      expect(find.text('Screen A'), findsOneWidget);
      expect(GlobalRouteState.of(aContext!)!.match.routes, hasLength(2));
      expect(RouteState.of(aContext!)!.pathParameters, hasLength(1));

      routeState = RouteState.of(aContext!);
      expect(routeState, isNotNull);
      routeState!.goTo('details');

      await tester.pumpAndSettle();
      expect(find.text('Screen A Details'), findsOneWidget);
      expect(GlobalRouteState.of(aContext!)!.match.routes, hasLength(3));
      expect(RouteState.of(aContext!)!.pathParameters, hasLength(1));
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
