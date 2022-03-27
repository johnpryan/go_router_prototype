// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart' hide Route;
import 'package:flutter_web_plugins/url_strategy.dart';

import 'path_parameters.dart';

void main() {
  usePathUrlStrategy();
  runApp(PathParametersDemo());
}
