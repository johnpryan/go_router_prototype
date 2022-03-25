// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

typedef StackedRouteBuilder = Widget Function(
  BuildContext context,
);

typedef SwitcherRouteBuilder = Widget Function(
  BuildContext context,
  Widget child,
);

typedef NestedNavigatorRouteBuilder = Widget Function(
  BuildContext context,
);
