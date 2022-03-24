// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart' hide Route;
import 'package:flutter_test/flutter_test.dart';
import 'package:tree_router/src/route.dart';

import 'package:tree_router/src/tree.dart';

void main() {
  group('RouteTree', () {
    test('Looks up routes', () {
      final routes = <Route>[
        Route(
          builder: (context, state) => const EmptyWidget(),
          path: '/',
        ),
        Route(
          builder: (context, state) => const EmptyWidget(),
          path: '/item/:id',
        ),
      ];

      var lookup = RouteTree(routes).get('/');
      expect(lookup, routes.first);

      lookup = RouteTree(routes).get('/item/1');
      expect(lookup, routes[1]);
    });
  });
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Placeholder();
}
