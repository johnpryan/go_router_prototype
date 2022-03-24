import 'package:flutter/material.dart' hide Route;
import 'package:flutter_test/flutter_test.dart';
import 'package:tree_router/src/delegate.dart';
import 'package:tree_router/src/parser.dart';
import 'package:tree_router/src/route.dart';

void main() {
  group('TreeRouterDelegate', () {
    testWidgets('displays the home screen', (WidgetTester tester) async {
      final routes = <Route>[
        Route(path: '/', builder: (context, state) => const _HomeScreen()),
      ];
      final delegate = TreeRouterDelegate(routes);
      final parser = TreeRouteInformationParser();
      final informationProvider = _TestRouteInformationProvider();
      await tester.pumpWidget(
        _TestWidget(
          routerDelegate: delegate,
          routeInformationParser: parser,
          informationProvider: informationProvider,
        ),
      );
      expect(find.text('Home Screen'), findsOneWidget);
    });
  });
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('Home Screen');
  }
}


class _TestWidget extends StatefulWidget {
  const _TestWidget(
      {Key? key,
      required this.routerDelegate,
      required this.informationProvider,
      required this.routeInformationParser})
      : super(key: key);

  final TreeRouterDelegate routerDelegate;
  final TreeRouteInformationParser routeInformationParser;
  final _TestRouteInformationProvider informationProvider;

  @override
  State<_TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState<T> extends State<_TestWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
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
