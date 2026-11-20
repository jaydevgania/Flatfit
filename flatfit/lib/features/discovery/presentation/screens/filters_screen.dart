import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/discovery_filters.dart';
import '../providers/discovery_provider.dart';
import '../providers/filters_provider.dart';

/// Modal bottom sheet providing comprehensive discovery filters.
class FiltersScreen extends ConsumerStatefulWidget {
  const FiltersScreen({super.key});

  @override
  ConsumerState<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends ConsumerState<FiltersScreen> {
  late DiscoveryFilters _localFilters;

  static const List<String> mumbaiLocalities = [
    'Bandra West',
    'Andheri West',
    'Powai',
    'Versova',
    'Lower Parel',
    'Khar West',
    'Juhu',
    'Worli',
    'BKC',
    'Santacruz West',
    'Goregaon East',
    'Malad West',
  ];

  static const List<String> occupationOptions = [
    'working',
    'student',
    'freelancer',
  ];

  @override
  void initState() {
    super.initState();
    _localFilters = ref.read(filtersProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle and header
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 8),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Discovery Filters',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _localFilters = DiscoveryFilters.defaults;
                        });
                      },
                      child: const Text('Reset All', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Scrollable Filter Sections
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                // 1. Budget Range Section
                _buildSectionHeader('Monthly Budget Range (₹)'),
                RangeSlider(
                  values: RangeValues(_localFilters.budgetMin, _localFilters.budgetMax),
                  min: 5000,
                  max: 80000,
                  divisions: 75,
                  activeColor: const Color(0xFF4F46E5),
                  labels: RangeLabels(
                    '₹${_localFilters.budgetMin.toInt()}',
                    '₹${_localFilters.budgetMax.toInt()}',
                  ),
                  onChanged: (values) {
                    setState(() {
                      _localFilters = _localFilters.copyWith(
                        budgetMin: values.start,
                        budgetMax: values.end,
                      );
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Min: ₹${_localFilters.budgetMin.toInt()}',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text('Max: ₹${_localFilters.budgetMax.toInt()}',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 20),

                // 2. Preferred Localities (Multi-select)
                _buildSectionHeader('Preferred Localities (Mumbai)'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: mumbaiLocalities.map((loc) {
                    final isSelected = _localFilters.localities.contains(loc);
                    return FilterChip(
                      label: Text(loc, style: const TextStyle(fontSize: 12)),
                      selected: isSelected,
                      selectedColor: const Color(0xFFEEF2FF),
                      checkmarkColor: const Color(0xFF4F46E5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF6366F1) : Colors.grey.shade300,
                      ),
                      onSelected: (selected) {
                        final list = List<String>.from(_localFilters.localities);
                        if (selected) {
                          list.add(loc);
                        } else {
                          list.remove(loc);
                        }
                        setState(() {
                          _localFilters = _localFilters.copyWith(localities: list);
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // 3. Gender Preference
                _buildSectionHeader('Flatmate Gender'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildRadioChoice('Any', 'any', _localFilters.gender, (val) {
                      setState(() => _localFilters = _localFilters.copyWith(gender: val));
                    }),
                    const SizedBox(width: 8),
                    _buildRadioChoice('Female Only', 'female', _localFilters.gender, (val) {
                      setState(() => _localFilters = _localFilters.copyWith(gender: val));
                    }),
                    const SizedBox(width: 8),
                    _buildRadioChoice('Male Only', 'male', _localFilters.gender, (val) {
                      setState(() => _localFilters = _localFilters.copyWith(gender: val));
                    }),
                  ],
                ),
                const SizedBox(height: 20),

                // 4. Room Type
                _buildSectionHeader('Room Type'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildRadioChoice('Any', 'any', _localFilters.roomType, (val) {
                      setState(() => _localFilters = _localFilters.copyWith(roomType: val));
                    }),
                    const SizedBox(width: 8),
                    _buildRadioChoice('Single Room', 'single', _localFilters.roomType, (val) {
                      setState(() => _localFilters = _localFilters.copyWith(roomType: val));
                    }),
                    const SizedBox(width: 8),
                    _buildRadioChoice('Shared Room', 'shared', _localFilters.roomType, (val) {
                      setState(() => _localFilters = _localFilters.copyWith(roomType: val));
                    }),
                  ],
                ),
                const SizedBox(height: 20),

                // 5. Furnishing
                _buildSectionHeader('Furnishing'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildRadioChoice('Any', 'any', _localFilters.furnishing, (val) {
                      setState(() => _localFilters = _localFilters.copyWith(furnishing: val));
                    }),
                    const SizedBox(width: 8),
                    _buildRadioChoice('Furnished', 'furnished', _localFilters.furnishing, (val) {
                      setState(() => _localFilters = _localFilters.copyWith(furnishing: val));
                    }),
                    const SizedBox(width: 8),
                    _buildRadioChoice('Semi', 'semi_furnished', _localFilters.furnishing, (val) {
                      setState(() => _localFilters = _localFilters.copyWith(furnishing: val));
                    }),
                  ],
                ),
                const SizedBox(height: 20),

                // 6. Age Range
                _buildSectionHeader(
                    'Age Range (${_localFilters.ageMin} - ${_localFilters.ageMax} yrs)'),
                RangeSlider(
                  values: RangeValues(
                    _localFilters.ageMin.toDouble(),
                    _localFilters.ageMax.toDouble(),
                  ),
                  min: 18,
                  max: 60,
                  divisions: 42,
                  activeColor: const Color(0xFF4F46E5),
                  onChanged: (vals) {
                    setState(() {
                      _localFilters = _localFilters.copyWith(
                        ageMin: vals.start.round(),
                        ageMax: vals.end.round(),
                      );
                    });
                  },
                ),
                const SizedBox(height: 20),

                // 7. Occupation Type
                _buildSectionHeader('Occupation'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: occupationOptions.map((occ) {
                    final isSel = _localFilters.occupations.contains(occ);
                    return FilterChip(
                      label: Text(occ.toUpperCase(), style: const TextStyle(fontSize: 12)),
                      selected: isSel,
                      selectedColor: const Color(0xFFEEF2FF),
                      checkmarkColor: const Color(0xFF4F46E5),
                      onSelected: (sel) {
                        final list = List<String>.from(_localFilters.occupations);
                        if (sel) {
                          list.add(occ);
                        } else {
                          list.remove(occ);
                        }
                        setState(() {
                          _localFilters = _localFilters.copyWith(occupations: list);
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // 8. Minimum Compatibility Score
                _buildSectionHeader(
                    'Minimum Compatibility Score (${_localFilters.minCompatibilityScore.toInt()}%)'),
                Slider(
                  value: _localFilters.minCompatibilityScore,
                  min: 0,
                  max: 90,
                  divisions: 9,
                  activeColor: const Color(0xFF10B981),
                  label: '${_localFilters.minCompatibilityScore.toInt()}%',
                  onChanged: (val) {
                    setState(() {
                      _localFilters = _localFilters.copyWith(minCompatibilityScore: val);
                    });
                  },
                ),
                const SizedBox(height: 12),

                // 9. Verified Profiles Only Toggle
                SwitchListTile(
                  title: const Text('Verified Profiles Only',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Only show profiles with KYC & workplace verification',
                      style: TextStyle(fontSize: 12)),
                  value: _localFilters.onlyVerified,
                  activeColor: const Color(0xFF4F46E5),
                  contentPadding: EdgeInsets.zero,
                  onChanged: (val) {
                    setState(() {
                      _localFilters = _localFilters.copyWith(onlyVerified: val);
                    });
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(filtersProvider.notifier).updateFilters(_localFilters);
                        ref.read(discoveryProvider.notifier).loadProfiles();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Apply Filters (${_localFilters.activeFilterCount})',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1F2937),
      ),
    );
  }

  Widget _buildRadioChoice(
    String label,
    String value,
    String current,
    ValueChanged<String> onSelected,
  ) {
    final isSelected = current == value;
    return Expanded(
      child: InkWell(
        onTap: () => onSelected(value),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : const Color(0xFF4B5563),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
