import '../../accounts/domain/account_type.dart';

/// Computes the signed delta an adjustment must store so that an account reaches
/// a user-supplied *actual* balance.
///
/// The user always enters an intuitive, positive-facing display balance (for a
/// liability that is the outstanding debt). The delta is the signed difference
/// between the desired signed balance and the currently calculated one, and it
/// is what gets stored on the adjustment transaction.
abstract final class AdjustmentCalculator {
  const AdjustmentCalculator._();

  /// delta = desiredSignedBalance − calculatedSignedBalance.
  ///
  /// * [actualDisplayMinor] — the new balance the user typed (display value).
  /// * [calculatedSignedMinor] — the account's current signed balance,
  ///   excluding any adjustment being edited.
  static int delta({
    required AccountClassification classification,
    required int actualDisplayMinor,
    required int calculatedSignedMinor,
  }) {
    final desiredSigned = classification == AccountClassification.liability
        ? -actualDisplayMinor
        : actualDisplayMinor;
    return desiredSigned - calculatedSignedMinor;
  }
}
