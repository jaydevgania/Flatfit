import 'package:flutter/material.dart';
import '../../domain/models/expense_models.dart';

/// Reusable icon component with dedicated co-living colors and symbols for Indian households.
class ExpenseCategoryIcon extends StatelessWidget {
  final ExpenseCategory category;
  final double radius;

  const ExpenseCategoryIcon({
    super.key,
    required this.category,
    this.radius = 20,
  });

  static IconData getIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.rent:
        return Icons.home_work_outlined;
      case ExpenseCategory.electricity:
        return Icons.bolt;
      case ExpenseCategory.wifi:
        return Icons.wifi;
      case ExpenseCategory.groceries:
        return Icons.shopping_cart_outlined;
      case ExpenseCategory.cook:
        return Icons.restaurant;
      case ExpenseCategory.maid:
        return Icons.cleaning_services_outlined;
      case ExpenseCategory.other:
        return Icons.receipt_long;
    }
  }

  static Color getColor(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.rent:
        return Colors.indigo.shade700;
      case ExpenseCategory.electricity:
        return Colors.amber.shade800;
      case ExpenseCategory.wifi:
        return Colors.blue.shade700;
      case ExpenseCategory.groceries:
        return Colors.green.shade700;
      case ExpenseCategory.cook:
        return Colors.deepOrange.shade700;
      case ExpenseCategory.maid:
        return Colors.teal.shade700;
      case ExpenseCategory.other:
        return Colors.purple.shade700;
    }
  }

  static String getLabel(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.rent:
        return 'Rent';
      case ExpenseCategory.electricity:
        return 'Electricity';
      case ExpenseCategory.wifi:
        return 'WiFi';
      case ExpenseCategory.groceries:
        return 'Groceries';
      case ExpenseCategory.cook:
        return 'Cook';
      case ExpenseCategory.maid:
        return 'Maid';
      case ExpenseCategory.other:
        return 'Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getColor(category);

    return CircleAvatar(
      radius: radius,
      backgroundColor: color.withOpacity(0.12),
      child: Icon(
        getIcon(category),
        color: color,
        size: radius * 1.1,
      ),
    );
  }
}
