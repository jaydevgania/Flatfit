import 'package:flutter/material.dart';
import '../../domain/models/chore_models.dart';

/// Screen allowing flatmates to define new chores with frequency and effort weighting.
class AddChoreScreen extends StatefulWidget {
  final String flatId;
  final List<String> flatmateIds;
  final Map<String, String> flatmateNames;

  const AddChoreScreen({
    super.key,
    required this.flatId,
    required this.flatmateIds,
    required this.flatmateNames,
  });

  @override
  State<AddChoreScreen> createState() => _AddChoreScreenState();
}

class _AddChoreScreenState extends State<AddChoreScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  ChoreFrequency _frequency = ChoreFrequency.weekly;
  ChoreEffort _effort = ChoreEffort.medium;
  late Set<String> _selectedMembers;

  @override
  void initState() {
    super.initState();
    _selectedMembers = Set.from(widget.flatmateIds);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _saveChore() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedMembers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one flatmate for the rotation.')),
      );
      return;
    }

    final chore = Chore(
      id: 'ch_${DateTime.now().millisecondsSinceEpoch}',
      flatId: widget.flatId,
      title: _titleController.text.trim(),
      description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
      frequency: _frequency,
      effort: _effort,
      rotationUserIds: _selectedMembers.toList(),
      createdAt: DateTime.now(),
    );

    Navigator.pop(context, chore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Chore to Rotation'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Chore Name',
                hintText: 'e.g. Clean kitchen counters, Wash bathroom, Water plants',
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Notes / Expectations',
                hintText: 'e.g. Use disinfectant spray; empty lint filter',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Frequency', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              children: ChoreFrequency.values.map((freq) {
                final isSelected = _frequency == freq;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(freq.name.toUpperCase()),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) setState(() => _frequency = freq);
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text('Effort Weighting (Points)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 4),
            Text(
              'Used by the fairness engine to ensure heavy tasks give more credit.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            ...ChoreEffort.values.map((eff) {
              final isSelected = _effort == eff;
              return RadioListTile<ChoreEffort>(
                value: eff,
                groupValue: _effort,
                activeColor: Colors.teal.shade700,
                title: Text(eff.label, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  eff == ChoreEffort.light
                      ? '5-10 min tasks (trash, water plants)'
                      : eff == ChoreEffort.medium
                          ? '15-25 min tasks (dishes, dusting)'
                          : '40+ min tasks (bathroom scrub, deep clean)',
                  style: const TextStyle(fontSize: 11.5),
                ),
                onChanged: (val) {
                  if (val != null) setState(() => _effort = val);
                },
              );
            }),
            const SizedBox(height: 16),
            const Text('Include Flatmates in Rotation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            ...widget.flatmateIds.map((id) {
              final isSelected = _selectedMembers.contains(id);
              return CheckboxListTile(
                dense: true,
                title: Text(widget.flatmateNames[id] ?? id),
                value: isSelected,
                activeColor: Colors.teal.shade700,
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      _selectedMembers.add(id);
                    } else if (_selectedMembers.length > 1) {
                      _selectedMembers.remove(id);
                    }
                  });
                },
              );
            }),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _saveChore,
              child: const Text(
                'Add Chore & Start Rotation',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
