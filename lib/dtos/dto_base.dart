/// Abstract base class for DTOs (Data Transfer Objects) that encapsulate fields of type [T].
///
/// This class provides methods to validate, create instances, and map fields to an object of type [T].
abstract class DTOBase<T> {
  /// Returns whether this DTO is valid for creation.
  bool isValid();

  /// Creates and returns a new instance of type [T] based of this DTO.
  ///
  /// Throws an exception if this DTO is not valid.
  /// The exception type is determined by the constructor of [T].
  ///
  /// Consider calling [isValid] to check the validation of this DTO beforehand.
  T create();

  /// Maps non-null fields of this DTO to the corresponding fields of [obj].
  ///
  /// Throws an exception if setting a field on [obj] fails.
  void mapTo(T obj);
}
