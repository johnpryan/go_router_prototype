// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'match.dart';

typedef TreeRouterBuilder = Widget Function(
  BuildContext context,
  RouteMatch routeMatch,
);

typedef NestedTreeRouterBuilder = Widget Function(
  BuildContext context,
  RouteMatch routeMatch,
  Widget child,
);
