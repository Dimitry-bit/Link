/// Represents a response object that encapsulates either a data payload
/// or an error message.
class Response<T> {
  /// The data payload of this response.
  T? data;

  /// The error message string if an operation resulted in an error.
  String errorStr;

  Response(this.data, {this.errorStr = ''});

  /// Constructs an error [Response] object with the specified [errorMessage].
  ///
  /// This is a shorthand constructor for creating a response indicating failure.
  Response.error(String errorMessage) : this(null, errorStr: errorMessage);
}
