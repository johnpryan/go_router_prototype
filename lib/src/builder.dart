// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:tree_router/src/inheritance.dart';
import 'package:tree_router/src/match.dart';
import 'package:tree_router/src/typedefs.dart';

import 'route.dart' as r;
import 'state.dart';

Widget buildMatch(BuildContext context, RouteMatch routeMatch, VoidCallback pop,
    Key navigatorKey) {
  return _buildMatchRecursive(context, routeMatch, 0, pop, navigatorKey).widget;
}

// Builds a Navigator for all matched Routes from [startIndex] until the end of
// the the list, or if a route is a NavigatorRoute
_RecursiveBuildResult _buildMatchRecursive(BuildContext context,
    RouteMatch routeMatch, int startIndex, VoidCallback pop, Key navigatorKey,
    {Page? firstPage}) {
  final pages = <Page>[];
  if (firstPage != null) pages.add(firstPage);
  for (var i = startIndex; i < routeMatch.routes.length; i++) {
    final route = routeMatch.routes[i];
    if (route is r.StackedRoute) {
      final page = _buildPage(context, route, routeMatch);
      pages.add(page);
    } else if (route is r.ShellRoute) {
      final result = _buildShellRecursive(context, routeMatch, i, pop);
      final child = result.widget;
      pages.add(_pageForPlatform(child: child));
      i = result.newIndex;
    } else if (route is r.NavigatorRoute) {
      // Build the first page to display
      final page = _buildPage(context, route, routeMatch);
      // Build the inner Navigator it by recursively calling this method and
      // returning the result directly.
      final key = ValueKey(route);
      final innerNav = _buildMatchRecursive(
          context, routeMatch, i + 1, pop, key,
          firstPage: page);
      return innerNav;
    }
  }

  if (pages.isEmpty) {
    throw Exception(
        'Attempt to build a Navigator was built with an empty pages list');
  }

  Widget navigator = Navigator(
    key: navigatorKey,
    pages: pages,
    onPopPage: (Route<dynamic> route, dynamic result) {
      if (!route.didPop(result)) {
        return false;
      }
      // TODO: Pop from the correct Navigator with route.navigator
      pop();
      return true;
    },
  );

  return _RecursiveBuildResult(navigator, routeMatch.routes.length);
}

class _RecursiveBuildResult {
  final Widget widget;
  final int newIndex;

  _RecursiveBuildResult(this.widget, this.newIndex);
}

_RecursiveBuildResult _buildShellRecursive(
    BuildContext context, RouteMatch routeMatch, int i, VoidCallback pop) {
  final parent = routeMatch.routes[i] as r.ShellRoute;
  late final r.Route? child;

  if (i + 1 < routeMatch.routes.length) {
    child = routeMatch.routes[i + 1];
  } else {
    child = null;
  }

  Widget? childWidget;
  if (child is r.StackedRoute) {
    childWidget = _callRouteBuilder(context, child);
    i++;
  } else if (child is r.ShellRoute) {
    final result = _buildShellRecursive(context, routeMatch, i + 1, pop);
    childWidget = result.widget;
    i = result.newIndex;
  } else if (child is r.NavigatorRoute) {
    final key = ValueKey(child);
    final result = _buildMatchRecursive(context, routeMatch, i + 1, pop, key);
    childWidget = result.widget;
    i = result.newIndex;
  } else if (child == null) {
    childWidget = const SizedBox.shrink();
    i++;
  }

  final parentWidget = _callRouteBuilder(context, parent, child: childWidget!);

  return _RecursiveBuildResult(parentWidget, i);
}

Page _pageForPlatform({required Widget child}) {
  return MaterialPage(child: child);
}

Widget _callRouteBuilder(BuildContext context, r.Route route, {Widget? child}) {
  late final StackedRouteBuilder builder;
  if (route is r.NavigatorRoute) {
    builder = route.builder;
  } else if (route is r.StackedRoute) {
    builder = route.builder;
  } else if (route is r.ShellRoute) {
    if (child == null) {
      throw ('Attempt to build ShellRoute without a child widget');
    }
    return _wrapWithRouteStateScope(context, route,
        Builder(builder: (context) => route.builder(context, child)));
  }

  // The context passed to the builder must be below RouteStateScope.
  return _wrapWithRouteStateScope(
      context, route, Builder(builder: (context) => builder(context)));
}

Page _buildPage(BuildContext context, r.Route route, RouteMatch routeMatch) {
  return _pageForPlatform(child: _callRouteBuilder(context, route));
}

Widget _wrapWithRouteStateScope(
    BuildContext context, r.Route route, Widget child) {
  final globalState = GlobalRouteState.of(context);
  if (globalState == null) {
    throw Exception('No GlobalRouteState found during route build phase');
  }
  return RouteStateScope(
    state: RouteState(route, globalState),
    child: child,
  );
}
