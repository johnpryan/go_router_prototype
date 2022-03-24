import 'package:flutter/material.dart';
import 'package:tree_router/src/match.dart';
import 'package:tree_router/src/typedefs.dart';

import 'route.dart' as r;

Widget buildNavigator(
    BuildContext context, RouteMatch routeMatch, VoidCallback pop) {
  List<Page> pages = [];

  r.Route? nestedParent;
  for (var route in routeMatch.routes) {
    if (nestedParent != null) {
      // TODO: place a nested Navigator?
      pages.add(_nestedPageBuilder(
          context, nestedParent.nestedBuilder!, routeMatch, route.builder!));
      nestedParent = null;
      continue;
    }

    if (route.type == r.RouteType.stacked) {
      pages.add(_pageBuilder(context, route.builder!, routeMatch));
    } else if (route.type == r.RouteType.nested) {
      nestedParent = route;
    }
  }

  if (nestedParent != null) {
    // this nested doesn't have any children, add it with an empty child.
    pages.add(_nestedPageBuilder(context, nestedParent.nestedBuilder!,
        routeMatch, (_, __) => const SizedBox.shrink()));
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
    BuildContext context, TreeRouterBuilder builder, RouteMatch routeMatch) {
  return MaterialPage(child: builder(context, routeMatch));
}

Page _nestedPageBuilder(BuildContext context, NestedTreeRouterBuilder builder,
    RouteMatch routeMatch, TreeRouterBuilder childBuilder) {
  return MaterialPage(
      child: builder(context, routeMatch, childBuilder(context, routeMatch)));
}
