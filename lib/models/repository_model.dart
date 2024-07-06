/// Abstract class defining common functionality for repository records.
///
/// Implementing classes are expected to provide methods for managing
/// repository records, such as fetching primary keys and cloning instances.
abstract class RepositoryModel<T> {
  /// Returns the primary key of the repository record.
  ///
  /// The primary key uniquely identifies the record within the repository.
  String primaryKey();

  /// Creates and returns a clone of this instance.
  T clone();
}
