import '../errors/failure.dart';
import 'generated/app_localizations.dart';

/// Resolves a [Failure] to a user-facing, localized message. Keeps all
/// human-readable text out of the domain/data layers.
extension FailureL10n on AppLocalizations {
  String messageFor(Failure failure) => switch (failure.code) {
    FailureCodes.required => errorRequired,
    FailureCodes.invalidAmount => errorInvalidAmount,
    FailureCodes.amountMustBePositive => errorAmountPositive,
    FailureCodes.currencyMismatch => errorCurrencyMismatch,
    FailureCodes.sameAccountTransfer => errorSameAccountTransfer,
    FailureCodes.accountRequired => errorAccountRequired,
    FailureCodes.destinationRequired => errorDestinationRequired,
    FailureCodes.categoryRequired => errorCategoryRequired,
    FailureCodes.adjustmentReasonRequired => errorAdjustmentReasonRequired,
    FailureCodes.accountNotFound => errorAccountNotFound,
    FailureCodes.database => errorDatabase,
    _ => errorUnexpected,
  };
}
