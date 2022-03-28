// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart' hide Route;
import 'package:tree_router/src/delegate.dart';
import 'package:tree_router/src/parser.dart';
import 'package:tree_router/tree_router.dart';

Widget emptyBuilder(context) => const EmptyWidget();

Widget emptySwitcherBuilder(context, child) => child;

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Placeholder();
}

class TestWidget extends StatefulWidget {
  final TreeRouterDelegate routerDelegate;
  final TreeRouteInformationParser routeInformationParser;
  final TestRouteInformationProvider informationProvider;

  TestWidget({
    Key? key,
    required List<Route> routes,
    TestRouteInformationProvider? informationProvider,
    GlobalRouteState? routeState,
    String initialRoute = '/',
  })  : routerDelegate = routeState == null
            ? TreeRouterDelegate(routes)
            : TreeRouterDelegate.withState(routeState),
        routeInformationParser = TreeRouteInformationParser(),
        informationProvider = informationProvider ??
            TestRouteInformationProvider(initialRoute: initialRoute),
        super(key: key);

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState<T> extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: widget.routerDelegate,
      routeInformationParser: widget.routeInformationParser,
      routeInformationProvider: widget.informationProvider,
    );
  }
}

class TestRouteInformationProvider extends RouteInformationProvider
    with ChangeNotifier {
  RouteInformation _value;

  TestRouteInformationProvider({String initialRoute = '/'})
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
