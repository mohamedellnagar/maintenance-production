import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wealthos/core/localization/generated/app_localizations.dart';
import 'package:wealthos/features/budgets/application/budgets_providers.dart';
import 'package:wealthos/features/budgets/domain/budget.dart';
import 'package:wealthos/features/budgets/domain/budget_calculator.dart';
import 'package:wealthos/features/budgets/domain/budget_item.dart';
import 'package:wealthos/features/budgets/presentation/budget_item_form_page.dart';
import 'package:wealthos/features/budgets/presentation/budget_month_page.dart';
import 'package:wealthos/features/budgets/presentation/widgets/budget_summary_card.dart';
import 'package:wealthos/features/budgets/presentation/widgets/expense_item_tile.dart';
import 'package:wealthos/features/categories/domain/category.dart';

import 'harness.dart';

final _now = DateTime(2026, 7, 1);

Budget _budget({BudgetStatus status = BudgetStatus.active}) => Budget(
  id: 'b',
  year: 2026,
  month: 7,
  currencyCode: 'AED',
  status: status,
  createdAt: _now,
  updatedAt: _now,
);

BudgetItem _expenseItem() => BudgetItem(
  id: 'e',
  budgetId: 'b',
  type: BudgetItemType.expense,
  categoryId: 'food',
  assignedAmountMinor: 100000,
  rolloverEnabled: false,
  displayOrder: 0,
  createdAt: _now,
  updatedAt: _now,
);

Category _foodCategory() => const Category(
  id: 'food',
  nameAr: 'الطعام',
  nameEn: 'Food',
  type: CategoryType.expense,
  isSystem: true,
  isArchived: false,
);

void main() {
  testWidgets('budget month shows an empty state when no budget exists', (
    tester,
  ) async {
    final harness = TestHarness();
    addTearDown(harness.dispose);
    await tester.pumpWidget(
      harness.wrap(
        const BudgetMonthPage(),
        extraOverrides: [
          budgetForMonthProvider.overrideWith((ref, m) => Stream.value(null)),
        ],
      ),
    );
    await pumpUntilStable(tester);
    final l = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l.budgetEmptyTitle), findsOneWidget);
    expect(
      find.widgetWithText(FilledButton, l.budgetCreateTitle),
      findsOneWidget,
    );
  });

  testWidgets('add budget item requires a category and an amount', (
    tester,
  ) async {
    final harness = TestHarness();
    addTearDown(harness.dispose);
    await tester.pumpWidget(
      harness.wrap(
        const BudgetItemFormPage(),
        categories: [_foodCategory()],
        extraOverrides: [
          budgetForMonthProvider.overrideWith((ref, m) => Stream.value(null)),
          allCategoriesProvider.overrideWith((ref) => Stream.value(const [])),
        ],
      ),
    );
    await pumpUntilStable(tester);
    final l = await AppLocalizations.delegate.load(const Locale('en'));
    await tester.tap(find.widgetWithText(FilledButton, l.commonSave));
    await pumpUntilStable(tester);
    expect(find.text(l.errorBudgetCategoryRequired), findsOneWidget);
    expect(find.text(l.errorRequired), findsWidgets);
  });

  testWidgets('overspent expense tile shows the overspent status', (
    tester,
  ) async {
    final harness = TestHarness();
    addTearDown(harness.dispose);
    final result = ExpenseItemResult(
      item: _expenseItem(),
      assignedMinor: 100000,
      rolloverInMinor: 0,
      actualSpentMinor: 130000,
    );
    await tester.pumpWidget(
      harness.wrap(
        Scaffold(
          body: ExpenseItemTile(
            result: result,
            categoriesById: {'food': _foodCategory()},
            currency: 'AED',
          ),
        ),
      ),
    );
    await pumpUntilStable(tester);
    final l = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l.budgetStatusOverspent), findsOneWidget);
  });

  testWidgets('dashboard budget card shows a create CTA when no budget', (
    tester,
  ) async {
    final harness = TestHarness();
    addTearDown(harness.dispose);
    await tester.pumpWidget(
      harness.wrap(
        const Scaffold(body: BudgetSummaryCard()),
        extraOverrides: [
          budgetForMonthProvider.overrideWith((ref, m) => Stream.value(null)),
        ],
      ),
    );
    await pumpUntilStable(tester);
    final l = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l.budgetCreateCta), findsOneWidget);
  });

  testWidgets('closed budget shows the closed banner and reopen action', (
    tester,
  ) async {
    final harness = TestHarness();
    addTearDown(harness.dispose);
    await tester.pumpWidget(
      harness.wrap(
        const BudgetMonthPage(),
        extraOverrides: [
          budgetForMonthProvider.overrideWith(
            (ref, m) => Stream.value(_budget(status: BudgetStatus.closed)),
          ),
          budgetItemsProvider.overrideWith(
            (ref, id) => Stream.value([_expenseItem()]),
          ),
          incomingRolloversProvider.overrideWith(
            (ref, id) => Stream.value(const []),
          ),
          allCategoriesProvider.overrideWith(
            (ref) => Stream.value([_foodCategory()]),
          ),
        ],
      ),
    );
    await pumpUntilStable(tester);
    final l = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l.budgetClosedBanner), findsOneWidget);
    expect(find.widgetWithText(TextButton, l.budgetReopen), findsOneWidget);
    // No add-item FAB while closed.
    expect(find.byType(FloatingActionButton), findsNothing);
  });
}
