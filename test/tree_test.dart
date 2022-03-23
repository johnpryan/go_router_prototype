import 'package:flutter_test/flutter_test.dart';
import 'package:tree_router/src/route.dart';

import 'package:tree_router/src/tree.dart';

void main() {
  group('RouteTree', () {
    test('constructor', () {
      final routes = <Route>[];
      final tree = RouteTree(routes);
    });
  });
}
