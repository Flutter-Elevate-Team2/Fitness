import 'package:fitness_app/core/errors/error_strings.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:flutter/material.dart';

/// Translates developer-centric error strings into user-friendly messages
/// for the Smart Coach feature.
class SmartCoachErrorTranslator {
  static String translate(BuildContext context, String errorMessage) {
    final l10n = context.l10n;
    
    switch (errorMessage) {
      case ErrorStrings.noInternet:
      case ErrorStrings.connectionError:
      case ErrorStrings.networkError:
        return l10n.noInternetConnection;
        
      case ErrorStrings.connectionTimeout:
      case ErrorStrings.sendTimeout:
      case ErrorStrings.receiveTimeout:
        return l10n.smartCoachConnectionTimeout;
        
      case ErrorStrings.internalServerError:
      case ErrorStrings.serviceUnavailable:
        return l10n.smartCoachServerIssue;
        
      case ErrorStrings.unauthorized:
        return l10n.sessionExpiredMessage;
        
      case ErrorStrings.badCertificate:
        return l10n.smartCoachSecureConnectionFailed;
        
      case ErrorStrings.hiveError:
      case ErrorStrings.parsingError:
      case ErrorStrings.formatException:
        return l10n.smartCoachDataIssue;
        
      case ErrorStrings.defaultError:
      case ErrorStrings.unknownError:
        return l10n.smartCoachGenericError;
        
      default:
        // If it's a direct backend error message (e.g. from the API payload),
        // we can try to sanitize it, but usually returning it is fine unless
        // it's a raw exception string.
        if (errorMessage.contains('Exception') || errorMessage.contains('Error')) {
           return l10n.smartCoachGenericError;
        }
        return errorMessage;
    }
  }
}
