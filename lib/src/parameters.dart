import 'package:collection/collection.dart';
import 'package:quiver/core.dart';

class Parameters {
  final Map<String, String> path;
  final Map<String, String> query;

  Parameters(this.path, this.query);
  Parameters.empty() : path = {}, query = {};

  static const _equality = MapEquality();

  @override
  bool operator ==(Object other) {
    return other is Parameters &&
        _equality.equals(path, other.path) &&
        _equality.equals(query, other.query);
  }

  @override
  int get hashCode => hash2(_equality.hash(path), _equality.hash(query));

  @override
  String toString() => 'Parameters: $path $query';
}
