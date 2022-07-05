import 'package:flutter/material.dart';
import 'package:perseus_front_mobile/l10n/l10n.dart';

class HttpException implements Exception {
  HttpException(this.message, this.reason, this.codeStatus);

  String message;
  String reason;
  int codeStatus;

  String getTranslatedMessage(BuildContext context) {
    return '';
  }
}

class ForbiddenException implements HttpException {
  ForbiddenException(this.stackTrace);

  @override
  String message = 'Forbidden';

  @override
  String reason = 'Forbidden';

  @override
  int codeStatus = 403;
  StackTrace stackTrace;

  @override
  String toString() {
    return '[$codeStatus]: $reason\nstacktrace --> $stackTrace';
  }

  @override
  String getTranslatedMessage(BuildContext context) {
    return context.l10n.forbiddenException;
  }
}

class NotFoundException implements HttpException {
  NotFoundException(this.stackTrace);

  @override
  String message = 'Resource not found';
  @override
  String reason = 'Not Found';
  @override
  int codeStatus = 404;
  StackTrace stackTrace;

  @override
  String toString() {
    return '[$codeStatus]: $reason\nstacktrace --> $stackTrace';
  }

  @override
  String getTranslatedMessage(BuildContext context) {
    return context.l10n.notFoundException;
  }
}

class ConflictException implements HttpException {
  ConflictException(this.stackTrace);

  @override
  String message = 'Data already exists';
  @override
  String reason = 'Conflict';
  @override
  int codeStatus = 409;
  StackTrace stackTrace;

  @override
  String toString() {
    return '[$codeStatus]: $reason\nstacktrace --> $stackTrace';
  }

  @override
  String getTranslatedMessage(BuildContext context) {
    return context.l10n.conflictException;
  }
}

class InternalServerException implements HttpException {
  InternalServerException(this.stackTrace);

  @override
  String message = 'Internal Server Error';
  @override
  String reason = 'Internal Server Error';
  @override
  int codeStatus = 500;

  StackTrace stackTrace;

  @override
  String toString() {
    return '[$codeStatus]: $reason\nstacktrace --> $stackTrace';
  }

  @override
  String getTranslatedMessage(BuildContext context) {
    return context.l10n.internalServerException;
  }
}

class CommunicationTimeoutException implements HttpException {
  CommunicationTimeoutException(this.stackTrace);

  @override
  String message = 'Server is not reachable. Please verify your internet '
      'connection and try again';
  @override
  String reason = 'Communication exception';
  @override
  int codeStatus = 418;

  StackTrace stackTrace;

  @override
  String toString() {
    return '[$codeStatus]: $reason\nstacktrace --> $stackTrace';
  }

  @override
  String getTranslatedMessage(BuildContext context) {
    return context.l10n.timeoutException;
  }
}

class ExceptionUnknown implements HttpException {
  @override
  String message = 'Internal Server Error';
  @override
  String reason = 'Unknow Error';
  @override
  int codeStatus = 500;

  @override
  String toString() {
    return '[$codeStatus]: $reason';
  }

  @override
  String getTranslatedMessage(BuildContext context) {
    return context.l10n.unknownException;
  }
}
