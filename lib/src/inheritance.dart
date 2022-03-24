import 'package:flutter/cupertino.dart';

import 'state.dart';

class RouteStateScope extends InheritedWidget {
  final RouteState routeState;

  const RouteStateScope(
      {required this.routeState, required Widget child, Key? key})
      : super(child: child, key: key);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget is RouteStateScope &&
        routeState != oldWidget.routeState;
  }
}
