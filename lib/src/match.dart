import 'parameters.dart';
import 'route.dart';

class RouteMatch {
  final List<Route> routes;
  final Parameters parameters;

  RouteMatch({
    required this.routes,
    required this.parameters,
  });
}
