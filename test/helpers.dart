import 'package:flutter/widgets.dart';

Widget emptyBuilder(context) => const EmptyWidget();
Widget emptySwitcherBuilder(context, child) => child;

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Placeholder();
}

