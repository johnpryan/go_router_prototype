// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:tree_router/src/builder.dart';

import 'inheritance.dart';
import 'route.dart';
import 'state.dart';

class GoRouterDelegate extends RouterDelegate<Uri>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Uri> {
  late final GlobalRouteState _globalRouteState;

  factory GoRouterDelegate(List<RouteBase> routes) {
    final state = GlobalRouteState(routes);
    return GoRouterDelegate.withState(state);
  }

  GoRouterDelegate.withState(this._globalRouteState) {
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
    final current = match.path;
    final currentUri = Uri.parse(current);
    return currentUri;
  }

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Future<void> setNewRoutePath(Uri configuration) async {
    // TODO: This is probably using decodeComponent incorrectly.
    await _globalRouteState.goTo(Uri.decodeComponent(configuration.toString()));
    return SynchronousFuture(null);
  }

  @override
  Future<void> setInitialRoutePath(Uri configuration) async {
    await _globalRouteState.goTo(Uri.decodeComponent(configuration.toString()),
        isInitial: true);
    return SynchronousFuture(null);
  }
}
