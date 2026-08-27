import 'package:life_sync_app/core/utils/api_date_codec.dart';
import 'package:life_sync_app/core/value_objects/money_amount.dart';

final class FinanceCategoryModel {
  const FinanceCategoryModel({
    required this.id,
    required this.name,
    required this.active,
    this.description,
    this.icon,
    this.color,
  });
  factory FinanceCategoryModel.fromJson(Map<String, dynamic> json) =>
      FinanceCategoryModel(
        id: (json['id'] as num).toInt(),
        name: json['name'] as String,
        description: json['description'] as String?,
        icon: json['icon'] as String?,
        color: json['color'] as String?,
        active: json['active'] as bool? ?? true,
      );
  final int id;
  final String name;
  final String? description;
  final String? icon;
  final String? color;
  final bool active;
}

final class BudgetModel {
  const BudgetModel({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.category,
    required this.limitAmount,
    required this.spentAmount,
    required this.remainingAmount,
  });
  factory BudgetModel.fromJson(Map<String, dynamic> json) => BudgetModel(
    id: (json['id'] as num).toInt(),
    userId: (json['userId'] as num).toInt(),
    categoryId: (json['categoryId'] as num).toInt(),
    category: json['category'] as String,
    limitAmount: MoneyAmount.parse(json['limitAmount']),
    spentAmount: MoneyAmount.parse(json['spentAmount']),
    remainingAmount: MoneyAmount.parse(json['remainingAmount']),
  );
  final int id;
  final int userId;
  final int categoryId;
  final String category;
  final MoneyAmount limitAmount;
  final MoneyAmount spentAmount;
  final MoneyAmount remainingAmount;
  double get progress => spentAmount.ratioOf(limitAmount);
}

enum FinanceEntryType { income, expense }

final class FinanceEntryModel {
  const FinanceEntryModel({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    this.description,
    this.createdAt,
    this.updatedAt,
  });
  factory FinanceEntryModel.fromJson(
    Map<String, dynamic> json,
    FinanceEntryType type,
  ) {
    final dateKey = type == FinanceEntryType.income
        ? 'incomeDate'
        : 'expenseDate';
    return FinanceEntryModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      categoryId: (json['categoryId'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      amount: MoneyAmount.parse(json['amount']),
      date: ApiDateCodec.decodeDate(json[dateKey] as String),
      type: type,
      createdAt: json['createdAt'] == null
          ? null
          : ApiDateCodec.decodeLocalDateTime(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : ApiDateCodec.decodeLocalDateTime(json['updatedAt'] as String),
    );
  }
  final int id;
  final int userId;
  final int categoryId;
  final String title;
  final String? description;
  final MoneyAmount amount;
  final DateTime date;
  final FinanceEntryType type;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  bool get isExpense => type == FinanceEntryType.expense;
}

final class FinanceData {
  const FinanceData({
    required this.categories,
    required this.budgets,
    required this.incomes,
    required this.expenses,
  });
  final List<FinanceCategoryModel> categories;
  final List<BudgetModel> budgets;
  final List<FinanceEntryModel> incomes;
  final List<FinanceEntryModel> expenses;
  List<FinanceEntryModel> get history =>
      [...incomes, ...expenses]..sort((a, b) {
        final date = b.date.compareTo(a.date);
        return date != 0
            ? date
            : (b.createdAt ?? b.date).compareTo(a.createdAt ?? a.date);
      });
}
