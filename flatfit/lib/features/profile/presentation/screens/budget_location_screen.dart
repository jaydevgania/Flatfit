import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/budget_range_slider.dart';
import '../widgets/locality_picker.dart';

/// Screen 3 in Onboarding: Budget, Localities, Move-in Date, Stay Duration
class BudgetLocationScreen extends ConsumerStatefulWidget {
  const BudgetLocationScreen({super.key});

  @override
  ConsumerState<BudgetLocationScreen> createState() => _BudgetLocationScreenState();
}

class _BudgetLocationScreenState extends ConsumerState<BudgetLocationScreen> {
  late int _budgetMin;
  late int _budgetMax;
  late List<String> _localities;
  DateTime? _moveInDate;
  String _stayDuration = '12+ months';

  final List<String> _durationOptions = [
    '3 - 6 months',
    '6 - 12 months',
    '12+ months',
    'Flexible',
  ];

  @override
  void initState() {
    super.initState();
    final draft = ref.read(onboardingProvider);
    _budgetMin = draft.budgetMin;
    _budgetMax = draft.budgetMax;
    _localities = List.from(draft.preferredLocalities);
    _moveInDate = draft.moveInDate ?? DateTime.now().add(const Duration(days: 14));
    _stayDuration = draft.stayDuration ?? '12+ months';
  }

  void _syncState() {
    ref.read(onboardingProvider.notifier).setBudgetAndLocation(
          budgetMin: _budgetMin,
          budgetMax: _budgetMax,
          localities: _localities,
          moveInDate: _moveInDate,
          stayDuration: _stayDuration,
        );
  }

  Future<void> _pickMoveInDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _moveInDate ?? now.add(const Duration(days: 14)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 180)),
    );

    if (picked != null) {
      setState(() => _moveInDate = picked);
      _syncState();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Budget & Preferences 💰',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Specify your monthly rent budget and target areas.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),

          // Budget Range Slider
          BudgetRangeSlider(
            minBudget: _budgetMin,
            maxBudget: _budgetMax,
            onChanged: (values) {
              setState(() {
                _budgetMin = values.start.round();
                _budgetMax = values.end.round();
              });
              _syncState();
            },
          ),
          const SizedBox(height: 28),

          const Divider(),
          const SizedBox(height: 20),

          // Locality Picker
          Text(
            'Preferred Localities',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Pick at least 1 locality where you are looking to live.',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),
          LocalityPicker(
            selectedLocalities: _localities,
            onChanged: (updated) {
              setState(() => _localities = updated);
              _syncState();
            },
          ),
          const SizedBox(height: 24),

          const Divider(),
          const SizedBox(height: 20),

          // Move-in Date Picker
          Text(
            'Target Move-in Date',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: _pickMoveInDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade50,
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 20, color: Colors.blue),
                  const SizedBox(width: 12),
                  Text(
                    _moveInDate != null
                        ? '${_moveInDate!.day}/${_moveInDate!.month}/${_moveInDate!.year}'
                        : 'Select target date',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  const Text('Change', style: TextStyle(color: Colors.blue, fontSize: 13)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Stay Duration
          Text(
            'Expected Stay Duration',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _durationOptions.map((option) {
              final isSelected = _stayDuration == option;
              return ChoiceChip(
                label: Text(option),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _stayDuration = option);
                    _syncState();
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
