// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart' hide Route;
import 'package:tree_router/src/builder.dart';

import 'route.dart';
import 'state.dart';
import 'tree.dart';

class TreeRouterDelegate extends RouterDelegate<Uri>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Uri> {
  final RouteTree _routeTree;
  late final RouteState _routeState;

  TreeRouterDelegate(List<Route> routes, {String initialRoute = '/'})
      : _routeTree = RouteTree(routes) {
    _routeState = RouteState(_routeTree.get(initialRoute))
      ..addListener(notifyListeners);
  }

  @override
  void dispose() {
    _routeState.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildNavigator(
      context,
      _routeState.match,
      () => _routeState.pop(),
    );
  }

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Future<void> setNewRoutePath(Uri configuration) async {
    final match = _routeTree.get(configuration.path);
    _routeState.match = match;
  }
}
