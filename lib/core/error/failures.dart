import 'package:equatable/equatable.dart';

// Abstract base class for failures, used in the domain layer to represent errors in a platform-agnostic way.
// Extends Equatable to enable value comparison for testing and state management.
abstract class Failure extends Equatable {
  final String? message;
  const Failure({this.message});

  @override
  List<Object?> get props => [message];
}

// Represents server-related errors (e.g., Firebase Authentication failures).
class ServerFailure extends Failure {
  const ServerFailure({super.message});
}

// Represents network connectivity issues, used to handle offline scenarios.
class NetworkFailure extends Failure {
  const NetworkFailure({super.message});
}