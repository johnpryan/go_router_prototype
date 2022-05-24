import 'package:flutter/material.dart';
import 'package:tree_router/tree_router.dart';

class SongScreen extends StatelessWidget {
  const SongScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final songId = RouteState.of(context).pathParameters['songId'];
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('Song $songId'),
      ),
    );
  }
}
