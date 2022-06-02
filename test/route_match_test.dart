// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router_prototype/src/match.dart';
import 'package:go_router_prototype/src/parameters.dart';
import 'package:go_router_prototype/src/route.dart';

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

      expect(match.path, '/a/b');
    });
    test('includes parameters', () {
      final match = RouteMatch(
        routes: [
          StackedRoute(path: '/', builder: emptyBuilder),
          StackedRoute(path: 'user/:id', builder: emptyBuilder),
        ],
        parameters: Parameters({'id': '123'}, {}),
      );

      expect(match.path, '/user/123');
    });

    test('combines the paths for the matched routes', () {
      final match = RouteMatch(
        routes: [
          ShellRoute(path: '/', builder: emptyShellBuilder),
          NestedStackRoute(path: 'a', builder: emptyBuilder),
          StackedRoute(path: 'b', builder: emptyBuilder),
        ],
        parameters: Parameters({}, {}),
      );

      expect(match.path, '/a/b');
    });

    test('combines the paths for the matched routes', () {
      final match = RouteMatch(
        routes: [
          ShellRoute(path: '/', builder: emptyShellBuilder),
          ShellRoute(path: 'Documents', builder: emptyShellBuilder),
          ShellRoute(path: 'Books', builder: emptyShellBuilder),
          ShellRoute(path: 'Left_Hand.epub', builder: emptyShellBuilder),
        ],
        parameters: Parameters({}, {}),
      );

      expect(match.path, '/Documents/Books/Left_Hand.epub');
    });

    group('prefix operations', () {
      RouteMatch _buildMatch(List<String> paths) {
        return RouteMatch(
          routes: [
            ...paths.map((p) => StackedRoute(path: p, builder: emptyBuilder))
          ],
          parameters: Parameters({}, {}),
        );
      }

      final match1 = _buildMatch(['/', 'Documents']);
      final match2 = _buildMatch(['/', 'Documents', 'Books', 'book1']);
      final match3 = _buildMatch(['/', 'Documents', 'Pictures']);

      test('isPrefixOf', () {
        expect(match1.isPrefixOf(match2), true);
        expect(match1.isPrefixOf(match1), true);
        expect(match3.isPrefixOf(match1), false);
      });

      test('getMatchingPrefixIndex', () {
        expect(match1.getMatchingPrefixIndex(match1), 2);
        expect(match1.getMatchingPrefixIndex(match2), 2);
        expect(match2.getMatchingPrefixIndex(match3), 2);
        expect(match3.getMatchingPrefixIndex(match1), -1);
      });
    });
  });
}
