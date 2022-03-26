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
  late final GlobalRouteState _globalRouteState;

  factory TreeRouterDelegate(List<Route> routes, {String initialRoute = '/'}) {
    final state = GlobalRouteState(routes, initialRoute);
    return TreeRouterDelegate.withState(state);
  }

  TreeRouterDelegate.withState(this._globalRouteState) {
    _globalRouteState.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _globalRouteState.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlobalRouteStateScope(
      state: _globalRouteState,
      child: Builder(builder: (context) {
        return buildMatch(
          context,
          _globalRouteState.match,
          () => _globalRouteState.pop(),
          navigatorKey,
        );
      }),
    );
  }

  @override
  Uri get currentConfiguration {
    final match = _globalRouteState.match;
    return Uri.parse(match.currentRoutePath);
  }

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Future<void> setNewRoutePath(Uri configuration) async {
    _globalRouteState.goTo(configuration.path);
  }
}
