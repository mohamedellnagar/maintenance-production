import '../../../core/money/money.dart';
import 'account_type.dart';

/// Immutable domain representation of a financial account.
///
/// The stored [openingBalance] is a *signed net-worth contribution*: asset
/// accounts start positive, liability accounts start negative (a credit card
/// with 500 owed has an opening balance of -500). This keeps a single, uniform
/// balance formula across every account type (see `BalanceCalculator`).
class Account {
  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.classification,
    required this.currencyCode,
    required this.openingBalanceMinor,
    required this.displayOrder,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
    this.institutionName,
    this.accountNumberLast4,
    this.icon,
  });

  final String id;
  final String name;
  final AccountType type;
  final AccountClassification classification;
  final String currencyCode;
  final int openingBalanceMinor;
  final String? institutionName;
  final String? accountNumberLast4;
  final String? icon;
  final int displayOrder;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;

  Money get openingBalance =>
      Money(amountMinor: openingBalanceMinor, currencyCode: currencyCode);

  bool get isLiability => classification == AccountClassification.liability;
  bool get isAsset => classification == AccountClassification.asset;
}
