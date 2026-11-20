import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/occupation_type.dart';
import '../providers/onboarding_provider.dart';

/// Screen 1 in Onboarding: Basic Info (Name, Age, Gender, Occupation, City)
class BasicInfoScreen extends ConsumerStatefulWidget {
  const BasicInfoScreen({super.key});

  @override
  ConsumerState<BasicInfoScreen> createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends ConsumerState<BasicInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _cityController;
  String? _selectedGender;
  OccupationType? _selectedOccupation;

  final List<String> _genderOptions = ['Male', 'Female', 'Non-binary', 'Other'];
  final List<String> _popularCities = [
    'Mumbai',
    'Bengaluru',
    'Delhi NCR',
    'Pune',
    'Hyderabad',
    'Chennai',
  ];

  @override
  void initState() {
    super.initState();
    final draft = ref.read(onboardingProvider);
    _nameController = TextEditingController(text: draft.fullName);
    _ageController = TextEditingController(
      text: draft.age != null ? draft.age.toString() : '',
    );
    _cityController = TextEditingController(text: draft.city ?? '');
    _selectedGender = draft.gender;
    _selectedOccupation = draft.occupation;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _syncState() {
    final age = int.tryParse(_ageController.text.trim());
    if (_nameController.text.isNotEmpty &&
        age != null &&
        _selectedGender != null &&
        _selectedOccupation != null &&
        _cityController.text.isNotEmpty) {
      ref.read(onboardingProvider.notifier).setBasicInfo(
            fullName: _nameController.text.trim(),
            age: age,
            gender: _selectedGender!,
            occupation: _selectedOccupation!,
            city: _cityController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tell us about yourself 👋',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'This helps potential flatmates discover and connect with you.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),

            // Full Name
            Text(
              'Full Name',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'e.g. Rahul Sharma',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              textCapitalization: TextCapitalization.words,
              onChanged: (_) => _syncState(),
            ),
            const SizedBox(height: 20),

            // Age & Gender
            Row(
              children: [
                // Age Field
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Age',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'e.g. 24',
                          prefixIcon: const Icon(Icons.cake_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (_) => _syncState(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Gender Dropdown
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gender',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: InputDecoration(
                          hintText: 'Select gender',
                          prefixIcon: const Icon(Icons.wc_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: _genderOptions.map((g) {
                          return DropdownMenuItem(value: g, child: Text(g));
                        }).toList(),
                        onChanged: (val) {
                          setState(() => _selectedGender = val);
                          _syncState();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Occupation
            Text(
              'What do you do?',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: OccupationType.values.map((occ) {
                final isSelected = _selectedOccupation == occ;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() => _selectedOccupation = occ);
                        _syncState();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary.withValues(alpha: 0.1)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(occ.emoji, style: const TextStyle(fontSize: 22)),
                            const SizedBox(height: 6),
                            Text(
                              occ.label.split(' ').first,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // City
            Text(
              'Which city are you looking in?',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _cityController,
              decoration: InputDecoration(
                hintText: 'e.g. Mumbai, Bengaluru',
                prefixIcon: const Icon(Icons.location_city_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (_) => _syncState(),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: _popularCities.map((city) {
                final isSelected = _cityController.text.toLowerCase() ==
                    city.toLowerCase();
                return ChoiceChip(
                  label: Text(city),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      _cityController.text = city;
                      _syncState();
                      setState(() {});
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
