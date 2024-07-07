// A generic class for managing a list of callbacks argument of type [T].
class Event<Argument> {
  final List<void Function(Argument)> _callbacks = [];

  void addListener(void Function(Argument) listener) {
    _callbacks.add(listener);
  }

  void removeListener(void Function(Argument) listener) {
    _callbacks.remove(listener);
  }

  /// Notifies all registered listeners of this listener with the provided argument [arg].
  void notifyListeners(Argument arg) {
    for (var callback in _callbacks) {
      callback(arg);
    }
  }
}
