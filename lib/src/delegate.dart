// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart' hide Route;
import 'package:tree_router/src/builder.dart';

import 'inheritance.dart';
import 'route.dart';
import 'state.dart';

class TreeRouterDelegate extends RouterDelegate<Uri>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Uri> {
  late final RouteState _routeState;

  TreeRouterDelegate(List<Route> routes) {
    _routeState = RouteState(routes)
      ..addListener(notifyListeners);
  }

  @override
  void dispose() {
    _routeState.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RouteStateScope(
      routeState: _routeState,
      child: Builder(
        builder: (context) {
          return buildNavigator(
            context,
            _routeState.match!,
            () => _routeState.pop(),
          );
        }
      ),
    );
  }

  @override
  Uri get currentConfiguration {
    final match = _routeState.match;
    if (match == null) return Uri.parse('/');
    return Uri.parse(match.currentRoutePath);
  }

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Future<void> setNewRoutePath(Uri configuration) async {
    _routeState.goTo(configuration.path);
  }
}
