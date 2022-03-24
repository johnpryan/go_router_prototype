import 'package:flutter/material.dart';
import 'package:tree_router/src/match.dart';
import 'package:tree_router/src/state.dart';
import 'package:tree_router/src/typedefs.dart';

import 'parameters.dart';
import 'route.dart';

Widget buildNavigator(BuildContext context, RouteMatch routeMatch) {
  List<Page> pages = [];

  for (var route in routeMatch.routes) {
    if (route.type == RouteType.stacked) {
      pages.add(_pageBuilder(context, route.builder, routeMatch.parameters));
    }
  }
  return Navigator(
    pages: pages,
  );
}

Page _pageBuilder(BuildContext context, TreeRouterBuilder widgetBuilder,
    Parameters parameters) {
  final state = TreeRouterState(parameters: parameters);
  // TODO: switch based on app type
  return MaterialPage(child: widgetBuilder(context, state));
}
