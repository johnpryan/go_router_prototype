import 'package:flutter/widgets.dart' hide Route;
import 'package:flutter_test/flutter_test.dart';
import 'package:tree_router/src/delegate.dart';
import 'package:tree_router/src/parser.dart';
import 'package:tree_router/src/route.dart';

void main() {
  group('TreeRouterDelegate', () {
    testWidgets('test 1', (WidgetTester tester) async {
      final routes = <Route>[];
      final delegate = TreeRouterDelegate(routes);
      final parser = TreeRouteInformationParser();
      final informationProvider = _TestRouteInformationProvider();
      await tester.pumpWidget(_TestWidget(
        routerDelegate: delegate,
        routeInformationParser: parser,
        informationProvider: informationProvider,
      ));
    });
  });
}

class _TestWidget<T> extends StatefulWidget {
  const _TestWidget(
      {Key? key,
      required this.routerDelegate,
      required this.informationProvider,
      required this.routeInformationParser})
      : super(key: key);

  final RouterDelegate<T> routerDelegate;
  final RouteInformationParser<T> routeInformationParser;
  final RouteInformationProvider informationProvider;

  @override
  State<_TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState<T> extends State<_TestWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return Router<T>(
      key: UniqueKey(),
      restorationScopeId: 'router',
      routerDelegate: widget.routerDelegate,
      routeInformationParser: widget.routeInformationParser,
      routeInformationProvider: widget.informationProvider,
    );
  }
}

class _TestRouteInformationProvider extends RouteInformationProvider
    with ChangeNotifier {
  @override
  RouteInformation get value => _value;
  RouteInformation _value = const RouteInformation(location: '/');

  set value(RouteInformation value) {
    if (value == _value) {
      return;
    }
    _value = value;
    notifyListeners();
  }
}
