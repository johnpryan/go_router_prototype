// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tree_router/src/delegate.dart';
import 'package:tree_router/src/match.dart';
import 'package:tree_router/src/parameters.dart';
import 'package:tree_router/src/parser.dart';
import 'package:tree_router/src/route.dart';
import 'package:tree_router/src/state.dart';

void main() {
  group('buildRoute', () {
    testWidgets(
        'Configures the Navigator based on the match in GlobalRouteState',
        (WidgetTester tester) async {
      final routeB =
          StackedRoute(path: 'b', builder: (_) => const Text('Screen B'));
      final routeA = StackedRoute(
          path: '/', builder: (_) => const Text('Screen B'), routes: [routeB]);
      final routes = [routeA];

      final routeMatch = RouteMatch(
        routes: [routeA, routeB],
        parameters: Parameters.empty(),
      );

      final globalRouteState = GlobalRouteState(routes);
      final routerDelegate = GoRouterDelegate.withState(globalRouteState);

      await tester.pumpWidget(
        _TestWidget(
          informationProvider: _TestRouteInformationProvider(),
          routerDelegate: routerDelegate,
        ),
      );

      await globalRouteState.setMatch(routeMatch);
      await tester.pumpAndSettle();

      expect(find.text('Screen B'), findsOneWidget);
    });
  });
}

class _TestWidget extends StatefulWidget {
  final GoRouterDelegate routerDelegate;
  final GoRouteInformationParser routeInformationParser;
  final _TestRouteInformationProvider informationProvider;

  _TestWidget(
      {Key? key,
      required this.informationProvider,
      required this.routerDelegate})
      : routeInformationParser = GoRouteInformationParser(),
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
