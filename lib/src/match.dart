import 'route.dart';

class RouteMatch {
  List<Route> routes;
  Map<String, String> pathParameters;
  Map<String, String> queryParameters;

  RouteMatch({
    required this.routes,
    required this.pathParameters,
    required this.queryParameters,
  });
}
