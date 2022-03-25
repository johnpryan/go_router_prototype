// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:tree_router/src/match.dart';
import 'package:tree_router/src/typedefs.dart';

import 'route.dart' as r;

Navigator buildMatch(BuildContext context, RouteMatch routeMatch,
    VoidCallback pop, Key navigatorKey) {
  return buildMatchRecursive(context, routeMatch, 0, pop, navigatorKey).widget
      as Navigator;
}

// Builds a Navigator for all matched Routes from [startIndex] until the end of
// the the list, or if a route is a NestedNavigatorRoute
_RecursiveBuildResult buildMatchRecursive(BuildContext context,
    RouteMatch routeMatch, int startIndex, VoidCallback pop, Key navigatorKey,
    {Page? firstPage}) {
  final pages = <Page>[];
  if (firstPage != null) pages.add(firstPage);
  for (var i = startIndex; i < routeMatch.routes.length; i++) {
    final route = routeMatch.routes[i];
    if (route is r.StackedRoute) {
      final page = _buildPage(context, route.builder, routeMatch);
      pages.add(page);
    } else if (route is r.SwitcherRoute) {
      final result = buildSwitcherRecursive(context, routeMatch, i, pop);
      final child = result.widget;
      pages.add(_pageForPlatform(child: child));
      i = result.newIndex;
    } else if (route is r.NestedNavigatorRoute) {
      // Build the first page to display
      final page = _buildPage(context, route.builder, routeMatch);
      // Build the inner Navigator it by recursively calling this method and
      // returning the result directly.
      final key = ValueKey(route);
      final innerNav = buildMatchRecursive(context, routeMatch, i + 1, pop, key,
          firstPage: page);
      return innerNav;
    }
  }

  if (pages.isEmpty) {
    throw ('Attempt to build a Navigator was built with an empty pages list');
  }

  final navigator = Navigator(
    key: navigatorKey,
    pages: pages,
    onPopPage: (Route<dynamic> route, dynamic result) {
      if (!route.didPop(result)) {
        return false;
      }
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

_RecursiveBuildResult buildSwitcherRecursive(
    BuildContext context, RouteMatch routeMatch, int i, VoidCallback pop) {
  final parent = routeMatch.routes[i] as r.SwitcherRoute;
  late final r.Route? child;

  if (i + 1 < routeMatch.routes.length) {
    child = routeMatch.routes[i + 1];
  } else {
    child = null;
  }

  late final Widget childWidget;
  if (child is r.StackedRoute) {
    childWidget = child.builder(context);
    i++;
  } else if (child is r.SwitcherRoute) {
    final result = buildSwitcherRecursive(context, routeMatch, i + 1, pop);
    childWidget = result.widget;
    i = result.newIndex;
  } else if (child is r.NestedNavigatorRoute) {
    final key = ValueKey(child);
    final result = buildMatchRecursive(context, routeMatch, i + 1, pop, key);
    childWidget = result.widget;
    i = result.newIndex;
  } else if (child == null) {
    childWidget = const SizedBox.shrink();
    i++;
  }

  final parentWidget = parent.builder(context, childWidget);

  return _RecursiveBuildResult(parentWidget, i);
}

Page _pageForPlatform({required Widget child}) {
  return MaterialPage(child: child);
}

Page _buildPage(
    BuildContext context, StackedRouteBuilder builder, RouteMatch routeMatch) {
  return _pageForPlatform(child: builder(context));
}
