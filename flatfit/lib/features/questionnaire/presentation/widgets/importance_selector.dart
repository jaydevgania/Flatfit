import 'package:flutter/material.dart';
import '../../domain/importance_level.dart';

/// 3-button selector allowing users to set importance (Deal-breaker / Important / Nice to have)
class ImportanceSelector extends StatelessWidget {
  final ImportanceLevel selectedImportance;
  final ValueChanged<ImportanceLevel> onSelected;

  const ImportanceSelector({
    super.key,
    required this.selectedImportance,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.tune, size: 16, color: Colors.grey),
            SizedBox(width: 6),
            Text(
              'How important is this preference to you?',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: ImportanceLevel.values.map((level) {
            final isSelected = selectedImportance == level;
            final color = Color(level.colorValue);

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => onSelected(level),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? color.withValues(alpha: 0.12) : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? color : Colors.grey.shade300,
                        width: isSelected ? 2.0 : 1.0,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(level.emoji, style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 4),
                        Text(
                          level.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? color : Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
