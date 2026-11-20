import 'package:flutter/material.dart';

/// Custom dual-thumb slider with Indian Rupee (₹) formatting and quick preset chips.
class BudgetRangeSlider extends StatelessWidget {
  final int minBudget;
  final int maxBudget;
  final double absoluteMin;
  final double absoluteMax;
  final int step;
  final ValueChanged<RangeValues> onChanged;

  const BudgetRangeSlider({
    super.key,
    required this.minBudget,
    required this.maxBudget,
    this.absoluteMin = 5000,
    this.absoluteMax = 60000,
    this.step = 1000,
    required this.onChanged,
  });

  String _formatCurrency(num value) {
    if (value >= 100000) {
      return '₹${(value / 100000).toStringAsFixed(1)}L';
    } else if (value >= 1000) {
      return '₹${(value / 1000).toStringAsFixed(0)}k';
    }
    return '₹$value';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    final currentMin = minBudget.toDouble().clamp(absoluteMin, absoluteMax);
    final currentMax = maxBudget.toDouble().clamp(absoluteMin, absoluteMax);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display values in stylized badges
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildPriceBadge(
              label: 'Min Rent',
              amount: minBudget,
              color: Colors.grey.shade800,
            ),
            Container(
              height: 2,
              width: 20,
              color: Colors.grey.shade300,
            ),
            _buildPriceBadge(
              label: 'Max Rent',
              amount: maxBudget,
              color: primaryColor,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // RangeSlider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: primaryColor,
            inactiveTrackColor: primaryColor.withValues(alpha: 0.15),
            trackHeight: 6.0,
            thumbColor: primaryColor,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
            overlayColor: primaryColor.withValues(alpha: 0.1),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: primaryColor,
            valueIndicatorTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: RangeSlider(
            values: RangeValues(currentMin, currentMax),
            min: absoluteMin,
            max: absoluteMax,
            divisions: ((absoluteMax - absoluteMin) / step).round(),
            labels: RangeLabels(
              _formatCurrency(currentMin),
              _formatCurrency(currentMax),
            ),
            onChanged: onChanged,
          ),
        ),

        // Helper text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatCurrency(absoluteMin),
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
              Text(
                '${_formatCurrency(absoluteMax)}+',
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Quick budget presets for Indian cities
        Text(
          'Popular Budget Tiers',
          style: theme.textTheme.labelMedium?.copyWith(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildPresetChip('Budget (₹5k - ₹12k)', 5000, 12000),
            _buildPresetChip('Mid-tier (₹12k - ₹25k)', 12000, 25000),
            _buildPresetChip('Premium (₹25k - ₹45k)', 25000, 45000),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceBadge({
    required String label,
    required int amount,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          Text(
            _formatCurrency(amount),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(String label, int min, int max) {
    final isSelected = minBudget == min && maxBudget == max;
    return ChoiceChip(
      label: Text(label),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      selected: isSelected,
      onSelected: (_) {
        onChanged(RangeValues(min.toDouble(), max.toDouble()));
      },
    );
  }
}
