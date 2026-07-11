import '../../../core/money/money.dart';
import 'transaction_type.dart';

/// Immutable domain representation of a financial transaction.
///
/// [amountMinor] is a strictly positive magnitude for income/expense/transfer;
/// for adjustments it is a signed delta applied to the account balance. The
/// direction of income/expense/transfer is derived from [type] and never from
/// the sign of the amount (an expense is never stored negative).
class Transaction {
  const Transaction({
    required this.id,
    required this.type,
    required this.amountMinor,
    required this.currencyCode,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    this.accountId,
    this.destinationAccountId,
    this.categoryId,
    this.note,
    this.adjustmentReason,
    this.deletedAt,
  });

  final String id;
  final TransactionType type;
  final int amountMinor;
  final String currencyCode;
  final DateTime date;
  final String? accountId;
  final String? destinationAccountId;
  final String? categoryId;
  final String? note;
  final String? adjustmentReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  bool get isDeleted => deletedAt != null;

  Money get amount =>
      Money(amountMinor: amountMinor, currencyCode: currencyCode);
}
