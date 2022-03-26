// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart' hide Route;
import 'package:flutter_test/flutter_test.dart';
import 'package:tree_router/src/delegate.dart';
import 'package:tree_router/src/parser.dart';
import 'package:tree_router/src/route.dart';

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
        _TestWidget(
          routes: routes,
          informationProvider: _TestRouteInformationProvider(),
        ),
      );
      expect(find.text('Home Screen'), findsOneWidget);
    });

    testWidgets('Displays top-level routes', (WidgetTester tester) async {
      final provider = _TestRouteInformationProvider();
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
        _TestWidget(
          routes: routes,
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
      final provider = _TestRouteInformationProvider();
      final routes = <Route>[
        StackedRoute(
          path: '/',
          builder: (context) => const _HomeScreen(),
          children: [
            StackedRoute(
              path: 'a',
              builder: (context) => const _AScreen(),
            ),
          ],
        ),
      ];
      await tester.pumpWidget(
        _TestWidget(
          routes: routes,
          informationProvider: provider,
        ),
      );

      expect(find.text('Home Screen'), findsOneWidget);

      provider.value = const RouteInformation(location: '/a');
      await tester.pumpAndSettle();
      expect(find.text('AScreen'), findsOneWidget);
    });

    testWidgets('SwitcherRoute displays the child of the active sub-route',
        (WidgetTester tester) async {
      final provider = _TestRouteInformationProvider();
      final routes = <Route>[
        SwitcherRoute(
          path: '/',
          builder: (context, child) => _SwitcherParentScreen(child: child),
          children: [
            StackedRoute(
              path: 'a',
              builder: (context) => const _AScreen(),
            ),
          ],
        ),
      ];

      await tester.pumpWidget(
        _TestWidget(
          routes: routes,
          informationProvider: provider,
        ),
      );

      provider.value = const RouteInformation(location: '/a');
      await tester.pumpAndSettle();
      expect(find.text('Switcher Parent'), findsOneWidget);
      expect(find.text('AScreen'), findsOneWidget);
    });
  });

  testWidgets('Displays the initial route immediately',
      (WidgetTester tester) async {
    final provider = _TestRouteInformationProvider(initialRoute: '/a');
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
      _TestWidget(
        routes: routes,
        informationProvider: provider,
      ),
    );

    expect(find.text('AScreen'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('AScreen'), findsOneWidget);
  });

  testWidgets('Reports the correct information back to the Router',
      (WidgetTester tester) async {
    final provider = _TestRouteInformationProvider();
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

    final widget = _TestWidget(
      routes: routes,
      informationProvider: provider,
    );

    await tester.pumpWidget(widget);
    provider.value = const RouteInformation(location: '/user/123');
    await tester.pumpAndSettle();
    final path = widget.routerDelegate.currentConfiguration.path;
    expect(path, '/user/123');
  });

  testWidgets('Builds NestedNavigatorRoutes correctly',
      (WidgetTester tester) async {
    final provider = _TestRouteInformationProvider();
    final routes = <Route>[
      SwitcherRoute(
        path: '/',
        builder: (context, child) => Scaffold(
          body: Column(
            children: [
              const Text('Parent screen'),
              Expanded(child: child),
            ],
          ),
        ),
        children: [
          NestedNavigatorRoute(
            path: 'a',
            builder: (_) =>
                const Text('First screen on the nested a Navigator'),
            children: [
              StackedRoute(
                path: 'b',
                builder: (_) =>
                    const Text('Additional screen on the nested Navigator'),
              ),
            ],
          )
        ],
      ),
    ];

    final widget = _TestWidget(
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

  testWidgets('Displays the initial route immediately with nested routes',
      (WidgetTester tester) async {
    final routes = [
      StackedRoute(
        path: '/',
        builder: (context) => const _HomeScreen(),
      ),
      StackedRoute(
        path: '/a',
        builder: (context) => const _AScreen(),
        children: [
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
      _TestWidget(
        routes: routes,
        informationProvider: _TestRouteInformationProvider(initialRoute: '/a'),
        initialRoute: '/a',
      ),
    );

    expect(find.text('AScreen'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('AScreen'), findsOneWidget);
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

class _SwitcherParentScreen extends StatelessWidget {
  final Widget child;

  const _SwitcherParentScreen({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Switcher Parent'),
        child,
      ],
    );
  }
}

class _TestWidget extends StatefulWidget {
  final TreeRouterDelegate routerDelegate;
  final TreeRouteInformationParser routeInformationParser;
  final _TestRouteInformationProvider informationProvider;
  final String? initialRoute;

  _TestWidget({
    Key? key,
    required List<Route> routes,
    required this.informationProvider,
    this.initialRoute,
  })  : routerDelegate = initialRoute == null
            ? TreeRouterDelegate(routes)
            : TreeRouterDelegate(routes, initialRoute: initialRoute),
        routeInformationParser = TreeRouteInformationParser(),
        super(key: key);

  @override
  State<_TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState<T> extends State<_TestWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: widget.routerDelegate,
      routeInformationParser: widget.routeInformationParser,
      routeInformationProvider: widget.informationProvider,
    );
  }
}

class _TestRouteInformationProvider extends RouteInformationProvider
    with ChangeNotifier {
  RouteInformation _value;

  _TestRouteInformationProvider({String initialRoute = '/'})
      : _value = RouteInformation(location: initialRoute);

  @override
  RouteInformation get value => _value;

  set value(RouteInformation value) {
    if (value == _value) {
      return;
    }
    _value = value;
    notifyListeners();
  }
}
