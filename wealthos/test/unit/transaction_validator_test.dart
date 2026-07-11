import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/core/errors/failure.dart';
import 'package:wealthos/features/transactions/domain/new_transaction_input.dart';
import 'package:wealthos/features/transactions/domain/transaction_type.dart';

NewTransactionInput _input({
  required TransactionType type,
  int amount = 1000,
  String? accountId = 'a',
  String? destinationAccountId,
  String? adjustmentReason,
}) => NewTransactionInput(
  type: type,
  amountMinor: amount,
  currencyCode: 'AED',
  date: DateTime(2026, 7, 11),
  accountId: accountId,
  destinationAccountId: destinationAccountId,
  adjustmentReason: adjustmentReason,
);

void main() {
  test('valid income passes', () {
    expect(
      TransactionValidator.validate(_input(type: TransactionType.income)),
      isNull,
    );
  });

  test('expense with zero amount is rejected', () {
    final failure = TransactionValidator.validate(
      _input(type: TransactionType.expense, amount: 0),
    );
    expect(failure, isA<ValidationFailure>());
    expect(failure!.code, FailureCodes.amountMustBePositive);
  });

  test('expense with negative amount is rejected', () {
    final failure = TransactionValidator.validate(
      _input(type: TransactionType.expense, amount: -5),
    );
    expect(failure!.code, FailureCodes.amountMustBePositive);
  });

  test('income without account is rejected', () {
    final failure = TransactionValidator.validate(
      _input(type: TransactionType.income, accountId: null),
    );
    expect(failure!.code, FailureCodes.accountRequired);
  });

  test('transfer without destination is rejected', () {
    final failure = TransactionValidator.validate(
      _input(type: TransactionType.transfer),
    );
    expect(failure!.code, FailureCodes.destinationRequired);
  });

  test('transfer to same account is rejected', () {
    final failure = TransactionValidator.validate(
      _input(
        type: TransactionType.transfer,
        accountId: 'a',
        destinationAccountId: 'a',
      ),
    );
    expect(failure!.code, FailureCodes.sameAccountTransfer);
  });

  test('valid transfer passes', () {
    expect(
      TransactionValidator.validate(
        _input(
          type: TransactionType.transfer,
          accountId: 'a',
          destinationAccountId: 'b',
        ),
      ),
      isNull,
    );
  });

  test('adjustment allows negative amount but not zero', () {
    expect(
      TransactionValidator.validate(
        _input(
          type: TransactionType.adjustment,
          amount: -100,
          adjustmentReason: 'correction',
        ),
      ),
      isNull,
    );
    final zero = TransactionValidator.validate(
      _input(
        type: TransactionType.adjustment,
        amount: 0,
        adjustmentReason: 'correction',
      ),
    );
    expect(zero!.code, FailureCodes.amountMustBePositive);
  });

  test('adjustment without reason is rejected', () {
    final failure = TransactionValidator.validate(
      _input(type: TransactionType.adjustment, amount: 100),
    );
    expect(failure!.code, FailureCodes.adjustmentReasonRequired);
  });
}
