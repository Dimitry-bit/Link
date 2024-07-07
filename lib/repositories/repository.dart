import 'package:flutter/material.dart';
import 'package:link/models/repository_model.dart';

class Repository<Value extends RepositoryModel> extends ChangeNotifier {
  Map<String, Value> _data = {};

  Repository();

  Repository.initialize(Set<Value> data) {
    _data = {for (var e in data) e.primaryKey(): e};
  }

  List<Value> data() => _data.values.toList();

  Iterator<Value> iterator() => _data.values.iterator;

  bool isEmpty() => _data.isEmpty;
  bool isNotEmpty() => _data.isNotEmpty;

  int length() => _data.length;

  Value first() => _data.entries.first.value;
  Value? firstOrNull() => _data.entries.firstOrNull?.value;

  Value last() => _data.entries.last.value;
  Value? lastOrNull() => _data.entries.lastOrNull?.value;

  bool contains(Value value) => _data.containsKey(value.primaryKey());
  bool containsKey(String key) => _data.containsKey(key);

  /// Adds [value] into this repository.
  ///
  /// Throws an assertion error if [value] is already present this repository .
  void add(Value value) {
    assert(!contains(value));

    _data[value.primaryKey()] = value;
    notifyListeners();
  }

  /// Returns the [Value] associated with [key].
  ///
  /// Throws exception if no [Value] is associated with [key].
  Value getByKey(String key) {
    return _data[key]!;
  }

  /// Returns the [Value] associated with [RepositoryModel] key.
  ///
  /// Returns null if no [Value] is associated with [key].
  Value? getByKeyOrNull(String key) {
    return _data[key];
  }

  /// Updates the value associated with [key] to [newValue].
  ///
  /// If [key] exists in this repository and [newValue] has the same primary key as [key],
  /// the existing value is updated to [newValue].
  ///
  /// If [key] does not exist in this repository or [newValue] has a different primary key,
  /// [key]'s current value is removed, and [newValue] is added with its primary key as the new key.
  ///
  /// Throws an assertion error if [newValue] is already present in this repository.
  void update(String key, Value newValue) {
    if (containsKey(key) && key == newValue.primaryKey()) {
      _data.update(key, (value) => value = newValue);
    } else {
      assert(!contains(newValue));

      _data.remove(key);
      _data[newValue.primaryKey()] = newValue;
    }

    notifyListeners();
  }

  void removeByKey(String key) {
    Value? removed = _data.remove(key);
    if (removed != null) {
      notifyListeners();
    }
  }

  void remove(Value value) => removeByKey(value.primaryKey());

  void clear() {
    _data.clear();
    notifyListeners();
  }

  List<dynamic> toJson() {
    return _data.values
        .map((e) => (e as dynamic).toJson() as Map<String, dynamic>)
        .toList();
  }

  factory Repository.fromJson(
    List<dynamic> json,
    Value Function(Map<String, dynamic>) fromJsonFactory,
  ) {
    Set<Value> data = json.map((e) => fromJsonFactory(e)).toSet();
    return Repository.initialize(data);
  }
}
