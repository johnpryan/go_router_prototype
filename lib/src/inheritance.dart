// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';

import 'state.dart';

class RouteStateScope extends InheritedWidget {
  final RouteState state;

  RouteStateScope({required this.state, required Widget child})
      : super(child: child, key: ValueKey(state.route));

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget is RouteStateScope && state != oldWidget.state;
  }
}

class GlobalRouteStateScope extends InheritedWidget {
  final GlobalRouteState state;

  const GlobalRouteStateScope({
    required this.state,
    required Widget child,
    Key? key,
  }) : super(child: child, key: key);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget is GlobalRouteStateScope && state != oldWidget.state;
  }
}
