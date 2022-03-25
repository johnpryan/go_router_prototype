import 'package:flutter/material.dart';
import 'package:tree_router/src/match.dart';
import 'package:tree_router/src/typedefs.dart';

import 'route.dart' hide Route;

Widget buildNavigator(
    BuildContext context, RouteMatch routeMatch, VoidCallback pop) {
  List<Page> pages = [];

  SwitcherRoute? parent;
  for (var route in routeMatch.routes) {
    if (parent != null) {
      route = route as StackedRoute; // TODO: also NestedNavigatorRoute
      pages.add(
          _switcherBuilder(context, parent.builder, routeMatch, route.builder));
      parent = null;
      continue;
    }

    if (route is StackedRoute) {
      pages.add(_pageBuilder(context, route.builder, routeMatch));
    } else if (route is SwitcherRoute) {
      parent = route;
    }
  }

  if (parent != null) {
    // this nested doesn't have any children, add it with an empty child.
    pages.add(_switcherBuilder(
        context, parent.builder, routeMatch, (_) => const SizedBox.shrink()));
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

Page _pageBuilder(
    BuildContext context, StackedRouteBuilder builder, RouteMatch routeMatch) {
  return MaterialPage(child: builder(context));
}

Page _switcherBuilder(BuildContext context, SwitcherRouteBuilder builder,
    RouteMatch routeMatch, StackedRouteBuilder childBuilder) {
  final childWidget = childBuilder(context);
  final parentWidget = builder(context, childWidget);
  return MaterialPage(child: parentWidget);
}
