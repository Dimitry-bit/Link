class Repository<Value> {
  Set<Value> _data = {};

  Repository();

  Repository.initialize(Set<Value> data) : _data = data;

  Set<Value> data() => _data;

  Iterator<Value> iterator() => _data.iterator;

  bool isEmpty() => _data.isEmpty;
  bool isNotEmpty() => _data.isNotEmpty;

  int length() => _data.length;

  Value first() => _data.first;
  Value? firstOrNull() => _data.firstOrNull;

  Value last() => _data.last;
  Value? lastOrNull() => _data.lastOrNull;

  bool contains(Value value) => _data.contains(value);

  bool add(Value value) => _data.add(value);

  bool remove(Value value) => _data.remove(value);

  void clear() => _data.clear();

  List<dynamic> toJson() => _data
      .map((e) => (e as dynamic).toJson() as Map<String, dynamic>)
      .toList();

  factory Repository.fromJson(
    List<dynamic> json,
    Value Function(Map<String, dynamic>) fromJsonFactory,
  ) {
    Set<Value> data = json.map((e) => fromJsonFactory(e)).toSet();
    return Repository.initialize(data);
  }
}
