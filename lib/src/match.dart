import 'package:path/path.dart' as p;
import 'package:tree_router/src/matching.dart';
import 'parameters.dart';
import 'route.dart';

class RouteMatch {
  final List<Route> routes;
  final Parameters parameters;

  const RouteMatch({
    required this.routes,
    required this.parameters,
  });

  RouteMatch pop() {
    final newRoutes = List<Route>.from(routes)..removeLast();
    // todo: remove parameters?
    return RouteMatch(routes: newRoutes, parameters: parameters);
  }

  String get currentRoutePath {
    return fillParameters(p.joinAll(routes.map((r) => r.path)), parameters);
  }

  @override
  String toString() {
    return 'RouteMatch: $routes, $parameters';
  }
}
