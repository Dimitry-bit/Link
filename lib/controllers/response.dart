/// Represents a response object that encapsulates either a data payload
/// or an error message.
class Response<T> {
  /// The data payload of this response.
  final T? data;

  /// The error message string if an operation resulted in an error.
  final List<String> errors = [];

  Response(this.data);

  /// Constructs an error [Response] object with the specified [message].
  ///
  /// This is a shorthand constructor for creating a response indicating failure.
  Response.error(String message) : data = null {
    addError(message);
  }

  /// Adds an error message to the response.
  ///
  /// Use this method to add detailed error messages when an operation fails.
  void addError(String message) => errors.add(message);

  /// Checks if the response has any errors.
  ///
  /// Returns `true` if there are errors, `false` otherwise.
  bool error() => errors.isNotEmpty;

  /// Retrieves a concatenated string of all error messages.
  ///
  /// [delimiter] specifies the separator between individual error messages.
  String errorStr({String delimiter = '\n'}) => errors.join(delimiter);
}
