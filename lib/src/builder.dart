import 'package:flutter/material.dart';
import 'package:tree_router/src/match.dart' ;
import 'package:tree_router/src/typedefs.dart';

import 'route.dart' hide Route;

Widget buildNavigator(BuildContext context, RouteMatch routeMatch, VoidCallback pop) {
  List<Page> pages = [];

  for (var route in routeMatch.routes) {
    if (route.type == RouteType.stacked) {
      pages.add(_pageBuilder(context, route.builder, routeMatch));
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

Page _pageBuilder(
    BuildContext context, TreeRouterBuilder builder, RouteMatch routeMatch) {
  return MaterialPage(child: builder(context, routeMatch));
}
