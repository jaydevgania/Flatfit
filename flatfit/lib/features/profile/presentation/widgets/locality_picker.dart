import 'package:flutter/material.dart';

/// Search and selector for preferred localities with radius slider and tag chips.
class LocalityPicker extends StatefulWidget {
  final List<String> selectedLocalities;
  final ValueChanged<List<String>> onChanged;
  final double initialRadiusKm;
  final ValueChanged<double>? onRadiusChanged;

  const LocalityPicker({
    super.key,
    required this.selectedLocalities,
    required this.onChanged,
    this.initialRadiusKm = 5.0,
    this.onRadiusChanged,
  });

  @override
  State<LocalityPicker> createState() => _LocalityPickerState();
}

class _LocalityPickerState extends State<LocalityPicker> {
  final TextEditingController _searchController = TextEditingController();
  late double _radiusKm;

  static const List<String> _popularLocalities = [
    'Bandra West',
    'Andheri West',
    'Powai',
    'Juhu',
    'Koramangala',
    'Indiranagar',
    'HSR Layout',
    'Whitefield',
    'Cyber City, Gurgaon',
    'Sector 43, Gurgaon',
    'Hauz Khas',
    'Saket',
    'Gachibowli',
    'HITEC City',
    'Koregaon Park',
    'Viman Nagar',
  ];

  @override
  void initState() {
    super.initState();
    _radiusKm = widget.initialRadiusKm;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addLocality(String locality) {
    final clean = locality.trim();
    if (clean.isNotEmpty && !widget.selectedLocalities.contains(clean)) {
      widget.onChanged([...widget.selectedLocalities, clean]);
      _searchController.clear();
    }
  }

  void _removeLocality(String locality) {
    widget.onChanged(
      widget.selectedLocalities.where((item) => item != locality).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    final searchResults = _searchController.text.trim().isEmpty
        ? _popularLocalities
        : _popularLocalities.where((loc) =>
            loc.toLowerCase().contains(_searchController.text.toLowerCase()));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search bar
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search locality or add custom area...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.blue),
                    tooltip: 'Add custom locality',
                    onPressed: () => _addLocality(_searchController.text),
                  )
                : null,
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (_) => setState(() {}),
          onSubmitted: _addLocality,
        ),
        const SizedBox(height: 12),

        // Selected localities chips
        if (widget.selectedLocalities.isNotEmpty) ...[
          Text(
            'Selected Localities (${widget.selectedLocalities.length})',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.selectedLocalities.map((loc) {
              return Chip(
                avatar: const Icon(Icons.location_on, size: 16, color: Colors.white),
                label: Text(
                  loc,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: primaryColor,
                deleteIcon: const Icon(Icons.close, size: 16, color: Colors.white),
                onDeleted: () => _removeLocality(loc),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],

        // Search suggestions / popular localities
        Text(
          _searchController.text.isEmpty
              ? 'Popular Localities'
              : 'Suggestions',
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: searchResults.map((loc) {
            final isAdded = widget.selectedLocalities.contains(loc);
            return ActionChip(
              avatar: Icon(
                isAdded ? Icons.check : Icons.add,
                size: 16,
                color: isAdded ? primaryColor : Colors.grey.shade700,
              ),
              label: Text(loc),
              backgroundColor: isAdded
                  ? primaryColor.withValues(alpha: 0.1)
                  : Colors.grey.shade200,
              onPressed: () {
                if (isAdded) {
                  _removeLocality(loc);
                } else {
                  _addLocality(loc);
                }
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        // Search Radius Slider
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.radar, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  'Search Radius',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(
              'Within ${_radiusKm.toStringAsFixed(1)} km',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: _radiusKm,
          min: 1.0,
          max: 25.0,
          divisions: 24,
          label: '${_radiusKm.toStringAsFixed(0)} km',
          onChanged: (val) {
            setState(() => _radiusKm = val);
            widget.onRadiusChanged?.call(val);
          },
        ),
      ],
    );
  }
}
