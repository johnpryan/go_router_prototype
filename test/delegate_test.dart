import 'package:flutter/material.dart' hide Route;
import 'package:flutter_test/flutter_test.dart';
import 'package:tree_router/src/delegate.dart';
import 'package:tree_router/src/parser.dart';
import 'package:tree_router/src/route.dart';

void main() {
  group('TreeRouterDelegate', () {
    testWidgets('displays the home screen', (WidgetTester tester) async {
      final routes = <Route>[
        Route(
          path: '/',
          builder: (context, state) => const _HomeScreen(),
        ),
      ];
      await tester.pumpWidget(
        _TestWidget(
          routes: routes,
          informationProvider: _TestRouteInformationProvider(),
        ),
      );
      expect(find.text('Home Screen'), findsOneWidget);
    });

    testWidgets('switches between top-level routes',
        (WidgetTester tester) async {
      final provider = _TestRouteInformationProvider();
      final routes = <Route>[
        Route(
          path: '/',
          builder: (context, state) => const _HomeScreen(),
        ),
        Route(
          path: '/a',
          builder: (context, state) => const _AScreen(),
        ),
      ];
      await tester.pumpWidget(
        _TestWidget(
          routes: routes,
          informationProvider: provider,
        ),
      );

      expect(find.text('Home Screen'), findsOneWidget);

      provider.value = const RouteInformation(location: '/a');
      await tester.pumpAndSettle();
      expect(find.text('AScreen'), findsOneWidget);
    });

    testWidgets('Adds pages to the Navigator for sub-routes',
        (WidgetTester tester) async {
      final provider = _TestRouteInformationProvider();
      final routes = <Route>[
        Route(
          path: '/',
          builder: (context, state) => const _HomeScreen(),
          children: [
            Route(
              path: 'a',
              builder: (context, state) => const _AScreen(),
            ),
          ],
        ),
      ];
      await tester.pumpWidget(
        _TestWidget(
          routes: routes,
          informationProvider: provider,
        ),
      );

      expect(find.text('Home Screen'), findsOneWidget);

      provider.value = const RouteInformation(location: '/a');
      await tester.pumpAndSettle();
      expect(find.text('AScreen'), findsOneWidget);
    });

    testWidgets('Adds sub-routes to the subtree if the type is nested',
        (WidgetTester tester) async {
      final provider = _TestRouteInformationProvider();
      final routes = <Route>[
        Route(
          path: '/',
          nestedBuilder: (context, state, child) =>
              _NestedParentScreen(child: child),
          type: RouteType.nested,
          children: [
            Route(
              path: 'a',
              builder: (context, state) => const _AScreen(),
            ),
          ],
        ),
      ];

      await tester.pumpWidget(
        _TestWidget(
          routes: routes,
          informationProvider: provider,
        ),
      );

      provider.value = const RouteInformation(location: '/a');
      await tester.pumpAndSettle();
      expect(find.text('Nested Parent'), findsOneWidget);
      expect(find.text('AScreen'), findsOneWidget);
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

class _AScreen extends StatelessWidget {
  const _AScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('AScreen');
  }
}

class _NestedParentScreen extends StatelessWidget {
  final Widget child;

  const _NestedParentScreen({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Nested Parent'),
        child,
      ],
    );
  }
}

class _TestWidget extends StatefulWidget {
  final TreeRouterDelegate routerDelegate;
  final TreeRouteInformationParser routeInformationParser;
  final _TestRouteInformationProvider informationProvider;

  _TestWidget(
      {Key? key,
      required List<Route> routes,
      required this.informationProvider})
      : routerDelegate = TreeRouterDelegate(routes),
        routeInformationParser = TreeRouteInformationParser(),
        super(key: key);

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
