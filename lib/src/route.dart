import 'redirect.dart';
import 'typedefs.dart';

enum RouteType {
  stacked,
  nested,
}

class Route {
  final String path;
  final TreeRouterBuilder builder;
  final List<Route> children;
  final RouteType type;
  final Redirect? redirect;

  const Route({
    required this.path,
    required this.builder,
    this.children = const [],
    this.type = RouteType.stacked,
    this.redirect,
  });
}
