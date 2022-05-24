// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart' hide Route;
import 'package:flutter_test/flutter_test.dart';
import 'package:tree_router/src/route.dart';
import 'package:tree_router/src/state.dart';

import 'helpers.dart';

void main() {
  group('TreeRouterDelegate', () {
    testWidgets('displays the home screen', (WidgetTester tester) async {
      final routes = <Route>[
        StackedRoute(
          path: '/',
          builder: (context) => const _HomeScreen(),
        ),
      ];
      await tester.pumpWidget(
        TestWidget(
          routes: routes,
          initialRoute: '/',
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Home Screen'), findsOneWidget);
    });

    testWidgets('Displays top-level routes', (WidgetTester tester) async {
      final provider = TestRouteInformationProvider();
      final routes = <Route>[
        StackedRoute(
          path: '/',
          builder: (context) => const _HomeScreen(),
        ),
        StackedRoute(
          path: '/a',
          builder: (context) => const _AScreen(),
        ),
      ];
      await tester.pumpWidget(
        TestWidget(
          routes: routes,
          initialRoute: '/',
          informationProvider: provider,
        ),
      );

      expect(find.text('Home Screen'), findsOneWidget);

      provider.value = const RouteInformation(location: '/a');
      await tester.pumpAndSettle();
      expect(find.text('AScreen'), findsOneWidget);
    });

    testWidgets(
        'StackedRoute adds pages to the Navigator for the active sub-route',
        (WidgetTester tester) async {
      final provider = TestRouteInformationProvider();
      final routes = <Route>[
        StackedRoute(
          path: '/',
          builder: (context) => const _HomeScreen(),
          routes: [
            StackedRoute(
              path: 'a',
              builder: (context) => const _AScreen(),
            ),
          ],
        ),
      ];
      await tester.pumpWidget(
        TestWidget(
          routes: routes,
          informationProvider: provider,
        ),
      );

      expect(find.text('Home Screen'), findsOneWidget);

      provider.value = const RouteInformation(location: '/a');
      await tester.pumpAndSettle();
      expect(find.text('AScreen'), findsOneWidget);
    });

    testWidgets('ShellRoute displays the child of the active sub-route',
        (WidgetTester tester) async {
      final provider = TestRouteInformationProvider();
      final routes = <Route>[
        ShellRoute(
          path: '/',
          builder: (context, child) => _ShellScreen(
            label: 'Shell Parent',
            child: child,
          ),
          routes: [
            StackedRoute(
              path: 'a',
              builder: (context) => const _AScreen(),
            ),
          ],
        ),
      ];

      await tester.pumpWidget(
        TestWidget(
          routes: routes,
          informationProvider: provider,
        ),
      );

      provider.value = const RouteInformation(location: '/a');
      await tester.pumpAndSettle();
      expect(find.text('Shell Parent'), findsOneWidget);
      expect(find.text('AScreen'), findsOneWidget);
    });

    testWidgets('ShellRoute displays the default child',
        (WidgetTester tester) async {
      final provider = TestRouteInformationProvider();
      final routes = <Route>[
        ShellRoute(
          path: '/',
          defaultRoute: 'a',
          builder: (context, child) => _ShellScreen(
            label: 'Shell Parent',
            child: child,
          ),
          routes: [
            StackedRoute(
              path: 'a',
              builder: (context) => const _AScreen(),
            ),
          ],
        ),
      ];

      await tester.pumpWidget(
        TestWidget(
          routes: routes,
          informationProvider: provider,
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Shell Parent'), findsOneWidget);
      expect(find.text('AScreen'), findsOneWidget);
    });

    testWidgets('ShellRoutes can be children of other ShellRoutes',
        (WidgetTester tester) async {
      final provider = TestRouteInformationProvider();

      late BuildContext parent1Context;
      late BuildContext parent2Context;
      late BuildContext parent3Context;

      final routes = <Route>[
        ShellRoute(
          path: '/',
          builder: (context, child) {
            parent1Context = context;
            return _ShellScreen(
              label: 'parent 1',
              child: child,
            );
          },
          routes: [
            ShellRoute(
              path: 'a',
              builder: (context, child) {
                parent2Context = context;
                return _ShellScreen(
                  label: 'parent 2',
                  child: child,
                );
              },
              routes: [
                ShellRoute(
                  path: 'b',
                  builder: (context, child) {
                    parent3Context = context;
                    return _ShellScreen(
                      label: 'parent 3',
                      child: child,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ];

      await tester.pumpWidget(
        TestWidget(
          routes: routes,
          informationProvider: provider,
        ),
      );

      provider.value = const RouteInformation(location: '/a/b');
      await tester.pumpAndSettle();
      expect(find.text('parent 1'), findsOneWidget);
      expect(find.text('parent 2'), findsOneWidget);
      expect(find.text('parent 3'), findsOneWidget);

      final parent1RouteState = RouteState.of(parent1Context);
      expect(parent1RouteState, isNotNull);
      expect(parent1RouteState!.route.path, '/');

      final parent2RouteState = RouteState.of(parent2Context);
      expect(parent2RouteState, isNotNull);
      expect(parent2RouteState!.route.path, 'a');

      final parent3RouteState = RouteState.of(parent3Context);
      expect(parent3RouteState, isNotNull);
      expect(parent3RouteState!.route.path, 'b');
    });
  });

  testWidgets('Displays the initial route immediately',
      (WidgetTester tester) async {
    final provider = TestRouteInformationProvider(initialRoute: '/a');
    final routes = <Route>[
      StackedRoute(
        path: '/',
        builder: (context) => const _HomeScreen(),
      ),
      StackedRoute(
        path: '/a',
        builder: (context) => const _AScreen(),
      ),
    ];

    await tester.pumpWidget(
      TestWidget(
        routes: routes,
        informationProvider: provider,
      ),
    );

    // expect(find.text('AScreen'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('AScreen'), findsOneWidget);
  });

  testWidgets('Reports the correct information back to the Router',
      (WidgetTester tester) async {
    final provider = TestRouteInformationProvider();
    final routes = <Route>[
      StackedRoute(
        path: '/',
        builder: (context) => const _HomeScreen(),
      ),
      StackedRoute(
        path: '/user/:id',
        builder: (context) => const _AScreen(),
      ),
    ];

    final widget = TestWidget(
      routes: routes,
      informationProvider: provider,
    );

    await tester.pumpWidget(widget);
    provider.value = const RouteInformation(location: '/user/123');
    await tester.pumpAndSettle();
    final path = widget.routerDelegate.currentConfiguration.path;
    expect(path, '/user/123');
  });

  testWidgets('Builds NavigatorRoutes correctly', (WidgetTester tester) async {
    final provider = TestRouteInformationProvider();
    final routes = <Route>[
      ShellRoute(
        path: '/',
        builder: (context, child) => Scaffold(
          body: Column(
            children: [
              const Text('Parent screen'),
              Expanded(child: child),
            ],
          ),
        ),
        routes: [
          NavigatorRoute(
            path: 'a',
            builder: (_) => const Text('First screen on the inner Navigator'),
            routes: [
              StackedRoute(
                path: 'b',
                builder: (_) =>
                    const Text('Additional screen on the inner Navigator'),
              ),
            ],
          )
        ],
      ),
    ];

    final widget = TestWidget(
      routes: routes,
      informationProvider: provider,
    );

    await tester.pumpWidget(widget);
    provider.value = const RouteInformation(location: '/a/b');
    await tester.pumpAndSettle();
    final path = widget.routerDelegate.currentConfiguration.path;
    expect(path, '/a/b');
    expect(find.byType(Navigator), findsNWidgets(2));
  });

  testWidgets('Displays the initial route immediately with child routes',
      (WidgetTester tester) async {
    final routes = [
      StackedRoute(
        path: '/',
        builder: (context) => const _HomeScreen(),
      ),
      StackedRoute(
        path: '/a',
        builder: (context) => const _AScreen(),
        routes: [
          StackedRoute(
            path: 'b',
            builder: (context) => const _BScreen(),
          ),
        ],
      ),
      StackedRoute(
        path: '/c',
        builder: (context) => const _CScreen(),
      ),
    ];

    await tester.pumpWidget(
      TestWidget(
        routes: routes,
        initialRoute: '/a',
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('AScreen'), findsOneWidget);
  });

  testWidgets('query parameters', (WidgetTester tester) async {
    final routes = <Route>[
      StackedRoute(
        path: '/',
        builder: (context) => const _QueryParamsScreen(),
      ),
    ];

    final routeState = GlobalRouteState(routes);

    await tester.pumpWidget(
      TestWidget(
        routes: routes,
        initialRoute: '/?q=foo',
        routeState: routeState,
      ),
    );

    await tester.pumpAndSettle();
    expect(routeState.match.parameters.query, hasLength(1));
    await tester.pumpAndSettle();
    expect(routeState.match.parameters.query, hasLength(1));
    expect(find.text('q: foo'), findsOneWidget);
  });
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('Home Screen');
  }
}

class _AScreen extends StatelessWidget {
  const _AScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('AScreen');
  }
}

class _BScreen extends StatelessWidget {
  const _BScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('BScreen');
  }
}

class _CScreen extends StatelessWidget {
  const _CScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('CScreen');
  }
}

class _QueryParamsScreen extends StatelessWidget {
  const _QueryParamsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final queryParams = RouteState.of(context)!.queryParameters;
    return Column(
      children: [
        ...queryParams.keys.map((key) => Text('$key: ${queryParams[key]}')),
      ],
    );
  }
}

class _ShellScreen extends StatelessWidget {
  final String label;
  final Widget child;

  const _ShellScreen({
    Key? key,
    required this.label,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label),
        child,
      ],
    );
  }
}
