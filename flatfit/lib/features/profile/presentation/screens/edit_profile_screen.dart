import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/housing_goal.dart';
import '../../domain/occupation_type.dart';
import '../../domain/profile_model.dart';
import '../providers/profile_provider.dart';
import '../widgets/budget_range_slider.dart';
import '../widgets/housing_goal_card.dart';
import '../widgets/locality_picker.dart';
import '../widgets/photo_grid.dart';

/// Screen allowing users to view and edit all their profile fields
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _cityController;
  late TextEditingController _bioController;

  String? _gender;
  OccupationType? _occupation;
  HousingGoal? _housingGoal;
  int _budgetMin = 10000;
  int _budgetMax = 25000;
  List<String> _localities = [];
  String _stayDuration = '12+ months';
  bool _isSaving = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider).value;
    _nameController = TextEditingController(text: profile?.fullName ?? '');
    _ageController = TextEditingController(
      text: profile?.age != null ? profile!.age.toString() : '',
    );
    _cityController = TextEditingController(text: profile?.city ?? '');
    _bioController = TextEditingController(text: profile?.bio ?? '');
    _gender = profile?.gender;
    _occupation = profile?.occupation;
    _housingGoal = profile?.housingGoal;
    _budgetMin = profile?.budgetMin ?? 10000;
    _budgetMax = profile?.budgetMax ?? 25000;
    _localities = List.from(profile?.preferredLocalities ?? []);
    _stayDuration = profile?.stayDuration ?? '12+ months';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _cityController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final current = ref.read(profileProvider).value;
    final age = int.tryParse(_ageController.text.trim());

    if (current == null) {
      setState(() => _isSaving = false);
      return;
    }

    final updated = current.copyWith(
      fullName: _nameController.text.trim(),
      age: age,
      gender: _gender,
      occupation: _occupation,
      city: _cityController.text.trim(),
      bio: _bioController.text.trim(),
      housingGoal: _housingGoal,
      budgetMin: _budgetMin,
      budgetMax: _budgetMax,
      preferredLocalities: _localities,
      stayDuration: _stayDuration,
    );

    final success = await ref.read(profileProvider.notifier).saveProfile(updated);

    setState(() => _isSaving = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully! ✨')),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile. Please try again.')),
        );
      }
    }
  }

  Future<void> _handleAddPhoto() async {
    final photo = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (photo != null) {
      final current = ref.read(profileProvider).value;
      final position = current?.photos.length ?? 0;
      await ref.read(profileProvider.notifier).uploadPhoto(photo, position);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profile = ref.watch(profileProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveChanges,
            child: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photos section
              PhotoGrid(
                remotePhotos: profile?.photos,
                onAddPhoto: _handleAddPhoto,
                onRemovePhoto: (index) {
                  if (profile != null && index < profile.photos.length) {
                    final photo = profile.photos[index];
                    ref
                        .read(profileProvider.notifier)
                        .deletePhoto(photo.id, photo.position);
                  }
                },
              ),
              const SizedBox(height: 24),

              const Divider(),
              const SizedBox(height: 16),

              // Basic Info Fields
              Text(
                'Basic Details',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        prefixIcon: Icon(Icons.cake_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _gender,
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        prefixIcon: Icon(Icons.wc_outlined),
                      ),
                      items: ['Male', 'Female', 'Non-binary', 'Other']
                          .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                          .toList(),
                      onChanged: (val) => setState(() => _gender = val),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<OccupationType>(
                value: _occupation,
                decoration: const InputDecoration(
                  labelText: 'Occupation',
                  prefixIcon: Icon(Icons.work_outline),
                ),
                items: OccupationType.values
                    .map((o) => DropdownMenuItem(
                          value: o,
                          child: Text('${o.emoji} ${o.label}'),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _occupation = val),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  prefixIcon: Icon(Icons.location_city_outlined),
                ),
              ),
              const SizedBox(height: 24),

              const Divider(),
              const SizedBox(height: 16),

              // Housing Goal
              Text(
                'Housing Goal',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...HousingGoal.values.map((goal) {
                return HousingGoalCard(
                  goal: goal,
                  isSelected: _housingGoal == goal,
                  onTap: () => setState(() => _housingGoal = goal),
                );
              }),
              const SizedBox(height: 24),

              const Divider(),
              const SizedBox(height: 16),

              // Budget & Localities
              Text(
                'Budget & Preferred Localities',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              BudgetRangeSlider(
                minBudget: _budgetMin,
                maxBudget: _budgetMax,
                onChanged: (values) {
                  setState(() {
                    _budgetMin = values.start.round();
                    _budgetMax = values.end.round();
                  });
                },
              ),
              const SizedBox(height: 20),
              LocalityPicker(
                selectedLocalities: _localities,
                onChanged: (locs) => setState(() => _localities = locs),
              ),
              const SizedBox(height: 24),

              const Divider(),
              const SizedBox(height: 16),

              // Bio
              Text(
                'Bio / About You',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _bioController,
                maxLines: 4,
                maxLength: 500,
                decoration: const InputDecoration(
                  hintText: 'Share a bit about your lifestyle and habits...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),

              // Save CTA
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveChanges,
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Save Profile Changes',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
