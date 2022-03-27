// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:tree_router/src/match.dart';
import 'package:tree_router/src/parameters.dart';
import 'package:tree_router/src/route.dart';

import 'helpers.dart';

void main() {
  group('RouteMatch.currentRoutePath', () {
    test('combines the paths for the matched routes', () {
      final match = RouteMatch(
        routes: [
          StackedRoute(path: '/', builder: emptyBuilder),
          StackedRoute(path: 'a', builder: emptyBuilder),
          StackedRoute(path: 'b', builder: emptyBuilder),
        ],
        parameters: Parameters({}, {}),
      );

      expect(match.currentRoutePath, '/a/b');
    });
    test('includes parameters', () {
      final match = RouteMatch(
        routes: [
          StackedRoute(path: '/', builder: emptyBuilder),
          StackedRoute(path: 'user/:id', builder: emptyBuilder),
        ],
        parameters: Parameters({'id': '123'}, {}),
      );

      expect(match.currentRoutePath, '/user/123');
    });

    test('combines the paths for the matched routes', () {
      final match = RouteMatch(
        routes: [
          SwitcherRoute(path: '/', builder: emptySwitcherBuilder),
          NestedNavigatorRoute(path: 'a', builder: emptyBuilder),
          StackedRoute(path: 'b', builder: emptyBuilder),
        ],
        parameters: Parameters({}, {}),
      );

      expect(match.currentRoutePath, '/a/b');
    });
    test('combines the paths for the matched routes', () {
      final match = RouteMatch(
        routes: [
          SwitcherRoute(path: '/', builder: emptySwitcherBuilder),
          SwitcherRoute(path: 'Documents', builder: emptySwitcherBuilder),
          SwitcherRoute(path: 'Books', builder: emptySwitcherBuilder),
          SwitcherRoute(path: 'Left_Hand.epub', builder: emptySwitcherBuilder),
        ],
        parameters: Parameters({}, {}),
      );

      expect(match.currentRoutePath, '/Documents/Books/Left_Hand.epub');
    });
  });
}
