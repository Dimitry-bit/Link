class Response<T> {
  T? data;
  String errorStr;

  Response(this.data, {this.errorStr = ''});
  Response.error(String errorMessage) : this(null, errorStr: errorMessage);
}
