class ForbiddenException implements Exception {
  ForbiddenException(this.stackTrace);

  String message = 'Forbidden';
  String reason = 'Forbidden';
  int codeStatus = 403;
  StackTrace stackTrace;

  @override
  String toString() {
    return '[$codeStatus]: $reason\nstacktrace --> $stackTrace';
  }
}
class NotFoundException implements Exception {
  NotFoundException(this.stackTrace);

  String message = 'Resource not found';
  String reason = 'Not Found';
  int codeStatus = 404;
  StackTrace stackTrace;

  @override
  String toString() {
    return '[$codeStatus]: $reason\nstacktrace --> $stackTrace';
  }
}

class ConflictException implements Exception {
  ConflictException(this.stackTrace);

  String message = 'Data already exists';
  String reason = 'Conflict';
  int codeStatus = 409;
  StackTrace stackTrace;

  @override
  String toString() {
    return '[$codeStatus]: $reason\nstacktrace --> $stackTrace';
  }
}

class InternalServerException implements Exception {
  InternalServerException(this.stackTrace);

  String message = 'Internal Server Error';
  String reason = 'Internal Server Error';
  int codeStatus = 500;

  StackTrace stackTrace;

  @override
  String toString() {
    return '[$codeStatus]: $reason\nstacktrace --> $stackTrace';
  }
}

class ExceptionUnknow implements Exception {
  String message = 'Internal Server Error';
  String reason = 'Unknow Error';
  int codeStatus = 500;

  @override
  String toString() {
    return '[$codeStatus]: $reason';
  }
}
