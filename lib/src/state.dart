import 'package:flutter/foundation.dart';

import 'match.dart';

class RouteState extends ChangeNotifier {
  RouteMatch _match;

  RouteState(this._match);

  set match(RouteMatch match) {
    // Don't notify listeners if the destination is the same
    if (_match == match) return;

    _match = match;
    notifyListeners();
  }

  RouteMatch get match => _match;

  void pop() {
    _match = match.pop();
    notifyListeners();
  }
}
