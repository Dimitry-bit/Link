import 'package:flutter/material.dart';
import 'package:link/controllers/events.dart';
import 'package:link/controllers/response.dart';
import 'package:link/dtos/dto_base.dart';
import 'package:link/models/repository_model.dart';
import 'package:link/repositories/repository.dart';

typedef OnCreatedCallback<T> = void Function(Response<T> res);
typedef OnUpdatedCallback<T> = void Function(Response<T> res);
typedef OnRemovedCallback<T> = void Function(T obj);

/// A generic CRUD controller for managing operations on objects of type [T].
///
/// This controller facilitates basic CRUD operations (Create, Read, Update, Delete)
/// using a repository of objects that extend [RepositoryModel].
///
/// The controller manages callbacks for create, update, and remove operations,
/// notifying listeners registered through callbacks whenever these operations occur.
class CrudController<T extends RepositoryModel<T>> extends ChangeNotifier {
  /// Event fired when an item is created though this controller.
  final Event<Response<T>> onCreated = Event();

  /// Event fired when an item is updated through this controller.
  final Event<Response<T>> onUpdated = Event();

  /// Event fired when an item is removed through this controller.
  final Event<T> onRemoved = Event();

  @protected
  final Repository<T> repo;

  CrudController(this.repo) {
    repo.addListener(notifyListeners);
  }

  @override
  void dispose() {
    repo.removeListener(notifyListeners);
    super.dispose();
  }

  /// Creates a new object of type [T] using the provided [dto].
  ///
  /// Returns a [Response] object indicating the success or failure of the operation.
  Response<T> create(DTOBase<T> dto) {
    final typeStr = T.toString();
    Response<T> res;

    if (dto.isValid()) {
      try {
        final T obj = dto.create();
        final key = obj.primaryKey();

        if (!repo.containsKey(key)) {
          res = Response.error("$typeStr {key: '$key'} already exists.");
        }

        repo.add(obj);
        res = Response(obj);
      } catch (e) {
        res = Response.error(e.toString());
      }
    } else {
      res = Response.error("Couldn't create $typeStr, invalid/missing data.");
    }

    onCreated.notifyListeners(res);
    return res;
  }

  /// Updates an existing object identified by [key] with the data from [dto].
  ///
  /// Returns a [Response] object indicating the success or failure of the operation.
  Response<T> update(String key, DTOBase<T> dto) {
    final typeStr = T.toString();
    final T? oldObj = getByKey(key);
    Response<T> res;

    if (oldObj != null) {
      T newObj = oldObj.clone();

      try {
        dto.mapTo(newObj);
        String newKey = newObj.primaryKey();

        if ((key == newKey) || !repo.contains(newObj)) {
          repo.update(key, newObj);
          res = Response(newObj);
        } else {
          res = Response.error("$typeStr {key: '$newKey'} already exists.");
        }
      } catch (e) {
        res = Response.error(e.toString());
      }
    } else {
      res = Response.error("$typeStr {key: '$key'} does not exist.");
    }

    onUpdated.notifyListeners(res);
    return res;
  }

  /// Retrieves all objects of type [T] from the repository.
  List<T> getAll() => repo.data();

  /// Retrieve an object of type [T] by its unique [key] from the repository.
  T? getByKey(String key) => repo.getByKeyOrNull(key);

  /// Remove an object identifier by its unique [key] from the repository.
  ///
  /// If [key] is found in the repository, it is removed and the [onRemoved]
  /// listeners are notified. If [key] does not exist in the repository,
  /// this method performs no action.
  void removeByKey(String key) {
    if (repo.containsKey(key)) {
      remove(repo.getByKey(key));
    }
  }

  /// Remove [obj] from the repository.
  ///
  /// If [obj] is found in the repository, it is removed and the [onRemoved]
  /// listeners are notified. If [obj] does not exist in the repository,
  /// this method performs no action.
  void remove(T obj) {
    repo.remove(obj);
    onRemoved.notifyListeners(obj);
  }
}
