import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class TreeRouteInformationParser extends RouteInformationParser<Uri> {
  @override
  Future<Uri> parseRouteInformation(
      RouteInformation routeInformation,
      ) =>
      SynchronousFuture<Uri>(Uri.parse(routeInformation.location!));

  @override
  RouteInformation restoreRouteInformation(Uri configuration) =>
      RouteInformation(location: configuration.toString());
}