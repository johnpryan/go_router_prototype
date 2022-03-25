import 'package:flutter/material.dart';
import 'package:tree_router/src/match.dart';
import 'package:tree_router/src/typedefs.dart';

import 'route.dart' as r;

Widget buildMatch(
    BuildContext context, RouteMatch routeMatch, VoidCallback pop) {
  return buildMatchRecursive(context, routeMatch, 0, pop);
}

// Builds a Navigator for all matched Routes from [startIndex] until the end of
// the the list, or if a route is a NestedNavigatorRoute
Widget buildMatchRecursive(BuildContext context, RouteMatch routeMatch,
    int startIndex, VoidCallback pop) {
  final pages = <Page>[];
  for (var i = startIndex; i < routeMatch.routes.length; i++) {
    final route = routeMatch.routes[i];
    if (route is r.StackedRoute) {
      final page = _buildPage(context, route.builder, routeMatch);
      pages.add(page);
    } else if (route is r.SwitcherRoute) {
      final result = buildSwitcherRecursive(context, routeMatch, i);
      final child = result.widget;
      pages.add(_pageForPlatform(child: child));
      i = result.newIndex;
    } else if (route is r.NestedNavigatorRoute) {
      // TODO: handle pop callback correctly.
      final childWidget = buildMatchRecursive(context, routeMatch, i + 1, pop);
      pages.add(_pageForPlatform(child: childWidget));
      break;
    }
  }
  return Navigator(
    pages: pages,
    onPopPage: (Route<dynamic> route, dynamic result) {
      if (!route.didPop(result)) {
        return false;
      }
      pop();
      return true;
    },
  );
}

class _SwitcherBuildResult {
  final Widget widget;
  final int newIndex;

  _SwitcherBuildResult(this.widget, this.newIndex);
}

_SwitcherBuildResult buildSwitcherRecursive(
    BuildContext context, RouteMatch routeMatch, int i) {
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
    final result = buildSwitcherRecursive(context, routeMatch, i+1);
    childWidget = result.widget;
    i = result.newIndex;
  } else if (child is r.NestedNavigatorRoute) {
    childWidget = child.builder(context);
    i++;
  } else if (child == null) {
    childWidget = const SizedBox.shrink();
    i++;
  }

  final parentWidget = parent.builder(context, childWidget);

  return _SwitcherBuildResult(parentWidget, i);
}

Page _pageForPlatform({required Widget child}) {
  return MaterialPage(child: child);
}

Page _buildPage(
    BuildContext context, StackedRouteBuilder builder, RouteMatch routeMatch) {
  return _pageForPlatform(child: builder(context));
}
