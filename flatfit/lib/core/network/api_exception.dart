/// Custom exception hierarchy for network and Supabase operations.
sealed class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  const AppException(this.message, {this.statusCode, this.details});

  @override
  String toString() => '$runtimeType: $message (statusCode: $statusCode)';
}

class NetworkException extends AppException {
  const NetworkException([String message = 'No internet connection', dynamic details])
      : super(message, details: details);
}

class ServerException extends AppException {
  const ServerException(String message, {int? statusCode, dynamic details})
      : super(message, statusCode: statusCode, details: details);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([String message = 'Unauthorized request', dynamic details])
      : super(message, statusCode: 401, details: details);
}

class NotFoundException extends AppException {
  const NotFoundException([String message = 'Resource not found', dynamic details])
      : super(message, statusCode: 404, details: details);
}

class ValidationException extends AppException {
  final Map<String, List<String>>? fieldErrors;

  const ValidationException(
    String message, {
    this.fieldErrors,
    dynamic details,
  }) : super(message, statusCode: 422, details: details);
}

class ConflictException extends AppException {
  const ConflictException([String message = 'Conflict occurred', dynamic details])
      : super(message, statusCode: 409, details: details);
}

class RateLimitException extends AppException {
  const RateLimitException([String message = 'Too many requests. Please slow down.', dynamic details])
      : super(message, statusCode: 429, details: details);
}
