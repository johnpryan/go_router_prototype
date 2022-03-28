// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:path_to_regexp/path_to_regexp.dart';

import 'parameters.dart';

bool hasMatch(String template, String path) {
  return _hasMatch(template, path, true);
}

bool hasExactMatch(String template, String path) {
  return _hasMatch(template, path, false);
}

bool _hasMatch(String template, String path, bool prefix) {
  final parameters = <String>[];

  // remove query parameters
  path = Uri.decodeComponent(Uri.parse(path).path);

  var pathRegExp = pathToRegExp(template,
      parameters: parameters, prefix: prefix, caseSensitive: true);
  return pathRegExp.hasMatch(path);
}

Parameters extractParameters(String template, String path) {
  final queryParams = Uri.parse(path).queryParameters;
  final parameters = <String>[];
  var pathRegExp = pathToRegExp(template,
      parameters: parameters, prefix: true, caseSensitive: true);
  final match = pathRegExp.matchAsPrefix(path);
  if (match == null) return Parameters({}, queryParams);
  return Parameters(extract(parameters, match), queryParams);
}

final _fillRegex = RegExp(r'\:([A-Za-z0-9- .%]*)');

String fillParameters(String template, Parameters parameters) {
  final filledPaths = template.replaceAllMapped(_fillRegex, (match) {
    var paramName = match.group(0)!.replaceAll(':', '');
    if (parameters.path.containsKey(paramName)) {
      return parameters.path[paramName]!;
    }
    return '';
  });

  // Uri.toString() adds a '?' if there are no query parameters so skip if there
  // aren't any.
  if (parameters.query.isEmpty) {
    return filledPaths;
  }
  return Uri.parse(filledPaths)
      .replace(queryParameters: parameters.query)
      .toString();
}

List<String> parseParameterNames(String path) {
  final List<String> result = [];
  final matches = _fillRegex.allMatches(path);

  for (var match in matches) {
    assert(match.groupCount <= 1);

    if (match.groupCount == 1) {
      final matchedStr = match.group(0);
      if (matchedStr != null) {
        result.add(matchedStr.replaceAll(':', ''));
      }
    }
  }
  return result;
}
