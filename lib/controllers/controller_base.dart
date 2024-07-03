import 'package:flutter/material.dart';
import 'package:link/controllers/response.dart';
import 'package:link/models/repository_model.dart';
import 'package:link/repositories/repository.dart';

typedef OnCreateCallback<T> = void Function(Response<T>);
typedef OnUpdateCallback<T> = void Function(Response<T>);
typedef OnRemoveCallback<T> = void Function(T);

abstract class ControllerBase<T extends RepositoryModel> extends ChangeNotifier {
  @protected
  final Repository<T> repo;

  final Set<OnCreateCallback<T>> _onCreateCallbacks = {};
  final Set<OnUpdateCallback<T>> _onUpdateCallbacks = {};
  final Set<OnRemoveCallback<T>> _onRemoveCallbacks = {};

  ControllerBase(this.repo) {
    repo.addListener(_notifyListenersCallback);
  }

  @override
  void dispose() {
    repo.removeListener(() => notifyListeners);
    super.dispose();
  }

  List<T> getAll() => repo.data();
  T? getByKey(String key) => repo.getByKeyOrNull(key);

  void remove(T v) {
    repo.remove(v);
    notifyOnRemoveListeners(v);
  }

  void removeByKey(String key) {
    if (repo.containsKey(key)) {
      remove(repo.getByKey(key));
    }
  }

  void addOnCreteListener(OnCreateCallback<T> callback) {
    _onCreateCallbacks.add(callback);
  }

  void removeOnCreteListener(OnCreateCallback<T> callback) {
    _onCreateCallbacks.remove(callback);
  }

  void addOnUpdateListener(OnUpdateCallback<T> callback) {
    _onUpdateCallbacks.add(callback);
  }

  void removeOnUpdateListener(OnUpdateCallback<T> callback) {
    _onUpdateCallbacks.remove(callback);
  }

  void addOnRemoveListener(OnRemoveCallback<T> callback) {
    _onRemoveCallbacks.add(callback);
  }

  void removeOnRemoveListener(OnRemoveCallback<T> callback) {
    _onRemoveCallbacks.remove(callback);
  }

  @protected
  void notifyOnCreateListeners(Response<T> res) {
    for (var callback in _onCreateCallbacks) {
      callback(res);
    }
  }

  @protected
  void notifyOnUpdateListeners(Response<T> res) {
    for (var callback in _onUpdateCallbacks) {
      callback(res);
    }
  }

  @protected
  void notifyOnRemoveListeners(T v) {
    for (var callback in _onRemoveCallbacks) {
      callback(v);
    }
  }

  void _notifyListenersCallback() => notifyListeners();
}
