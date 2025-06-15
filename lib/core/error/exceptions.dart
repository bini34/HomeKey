// Defines a custom exception class for errors thrown in the data layer.
// This allows the data layer to throw specific errors that can be caught and mapped to failures.
class ServerException implements Exception {
  final String? message;

  // Constructor accepts an optional message for detailed error reporting.
  ServerException({this.message});
}