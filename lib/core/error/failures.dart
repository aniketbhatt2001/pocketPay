import 'exceptions.dart';

abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class InvalidDataFailure extends Failure {
  const InvalidDataFailure(super.message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}

/// Maps a known exception to its corresponding [Failure].
Failure mapExceptionToFailure(Object exception) {
  return switch (exception) {
    ServerException e => ServerFailure(e.message),
    NetworkException e => NetworkFailure(e.message),
    InvalidResponseException e => InvalidDataFailure(e.message),
    ParsingException e => InvalidDataFailure(e.message),
    UnauthorizedException e => UnauthorizedFailure(e.message),
    _ => UnknownFailure(exception.toString()),
  };
}
