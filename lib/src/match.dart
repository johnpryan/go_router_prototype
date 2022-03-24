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
}
