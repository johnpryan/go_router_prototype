library tree_router;

import 'src/delegate.dart';
import 'src/parser.dart';
import 'src/route.dart';

export 'src/route.dart';

class TreeRouter {
  final TreeRouterDelegate delegate;
  final TreeRouteInformationParser parser;

  TreeRouter({
    required List<Route> routes,
  })  : delegate = TreeRouterDelegate(routes),
        parser = TreeRouteInformationParser();
}
