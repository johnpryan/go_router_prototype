import 'package:path_to_regexp/path_to_regexp.dart';

bool hasMatch(String template, String path) {
  return _hasMatch(template, path, true);
}

bool hasExactMatch(String template, String path) {
  return _hasMatch(template, path, false);
}

bool _hasMatch(String template, String path, bool prefix) {
  final parameters = <String>[];
  var pathRegExp = pathToRegExp(
      template, parameters: parameters, prefix: prefix, caseSensitive: true);
  return pathRegExp.hasMatch(path);
}

Map<String, String> extractParameters(String template, String path) {
  final parameters = <String>[];
  var pathRegExp = pathToRegExp(
      template, parameters: parameters, prefix: true, caseSensitive: true);
  final match = pathRegExp.matchAsPrefix(path);
  if (match == null) return {};
  return extract(parameters, match);
}
