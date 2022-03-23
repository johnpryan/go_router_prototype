import 'package:flutter/widgets.dart' hide Route;

import 'route.dart';

class TreeRouterDelegate extends RouterDelegate<Uri>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Uri> {
  final List<Route> routes;

  TreeRouterDelegate(this.routes);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Future<void> setNewRoutePath(Uri configuration) {
    // TODO: implement setNewRoutePath
    throw UnimplementedError();
  }
}
