import 'package:flutter/material.dart';
import 'package:tree_router/src/match.dart';
import 'package:tree_router/src/typedefs.dart';

import 'route.dart' as r;

Navigator buildNavigator(
    BuildContext context, RouteMatch routeMatch, VoidCallback pop) {
  List<Page> pages = [];

  r.Route? nestedParent;
  for (var route in routeMatch.routes) {
    if (nestedParent != null) {
      if (route.type == r.RouteType.stacked ||
          route.type == r.RouteType.nested) {
        // Build the widget for the current route, then call the parent's
        // nestedBuilder, passing it as the with 'child' parameter.
        pages.add(_nestedPageBuilder(
            context, nestedParent.nestedBuilder!, routeMatch, route.builder!));
        nestedParent = null;
        continue;
      } else if (route.type == r.RouteType.nestedNavigator) {
        // Build a navigator for the remaining routes.

        final nestedNavigator =
            buildNestedNavigator(context, routeMatch, route, pop);
        final childWidget =
            nestedParent.nestedBuilder!(context, nestedNavigator);
      }
    }

    if (route.type == r.RouteType.stacked) {
      pages.add(_pageBuilder(context, route.builder!, routeMatch));
    } else if (route.type == r.RouteType.nested) {
      nestedParent = route;
    } else if (route.type == r.RouteType.nestedNavigator) {
      throw ('Unexpected Route with type nestedNavigator');
    }
  }

  if (nestedParent != null) {
    // this nested doesn't have any children, add it with an empty child.
    pages.add(_nestedPageBuilder(context, nestedParent.nestedBuilder!,
        routeMatch, (_) => const SizedBox.shrink()));
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

Navigator buildNestedNavigator(BuildContext context, RouteMatch routeMatch,
    r.Route current, VoidCallback onPop) {
  final routeIndex = routeMatch.routes.indexOf(current);
  if (routeIndex + 1 >= routeMatch.routes.length) {
    throw ('Error building nested Navigator with no child Route matches');
  }

  final remainingRoutes = routeMatch.routes.sublist(routeIndex + 1);
  final remainingRoutesAsMatch =
      RouteMatch(routes: remainingRoutes, parameters: routeMatch.parameters);

  return buildNavigator(context, remainingRoutesAsMatch, onPop);
}

Page _pageBuilder(
    BuildContext context, TreeRouterBuilder builder, RouteMatch routeMatch) {
  return MaterialPage(child: builder(context));
}

Page _nestedPageBuilder(BuildContext context, NestedTreeRouterBuilder builder,
    RouteMatch routeMatch, TreeRouterBuilder childBuilder) {
  return MaterialPage(child: builder(context, childBuilder(context)));
}
