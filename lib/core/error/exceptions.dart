class ServerException implements Exception {
  final String message;

  ServerException(this.message);

  @override
  String toString() {
    return message;  // Return the actual error message when the exception is printed
  }
}
