// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router_prototype/src/route.dart';

import 'helpers.dart';

void main() {
  group('Route', () {
    test('equality', () {
      final route = StackedRoute(path: '/', builder: emptyBuilder);
      final route2 = StackedRoute(path: '/', builder: emptyBuilder);
      expect(route, equals(route2));
    });

    test('routes with different children are not equal', () {
      final route = StackedRoute(
        path: '/',
        builder: emptyBuilder,
        routes: [
          StackedRoute(path: 'a', builder: emptyBuilder),
        ],
      );
      final route2 = StackedRoute(path: '/', builder: emptyBuilder);
      expect(route, isNot(equals(route2)));
    });
  });
}
