// Network / API level
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
