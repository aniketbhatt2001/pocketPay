// Network / API level
import 'package:supabase_flutter/supabase_flutter.dart';

class ServerException implements Exception {
  final String message;
  ServerException(this.message);

  @override
  String toString() {
    // TODO: implement toString
    return message;
  }
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() {
    // TODO: implement toString
    return message;
  }
}

// Data issues
class InvalidResponseException implements Exception {
  final String message;
  InvalidResponseException(this.message);
  @override
  String toString() {
    // TODO: implement toString
    return message;
  }
}

class ParsingException implements Exception {
  final String message;
  ParsingException(this.message);
  @override
  String toString() {
    // TODO: implement toString
    return message;
  }
}

// Auth-specific
class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
  @override
  String toString() {
    // TODO: implement toString
    return message;
  }
}

Exception mapFunctionExceptionToCustom(Object error) {
  if (error is! FunctionException) {
    return ServerException('Unexpected error');
  }

  final data = error.details;

  // Supabase usually returns: { error: "message" }
  final message =
      (data is Map<String, dynamic> ? data['error'] : null) as String? ??
      'Something went wrong';

  // You can extend this logic based on backend error codes
  if (message.toLowerCase().contains('unauthorized')) {
    return UnauthorizedException(message);
  }

  if (message.toLowerCase().contains('network')) {
    return NetworkException(message);
  }

  return ServerException(message);
}
