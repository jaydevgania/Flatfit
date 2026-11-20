import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/listing_model.dart';
import '../../domain/listing_type.dart';
import '../providers/listings_provider.dart';
import '../providers/my_listings_provider.dart';

class EditListingScreen extends ConsumerStatefulWidget {
  final Listing listing;

  const EditListingScreen({Key? key, required this.listing}) : super(key: key);

  @override
  ConsumerState<EditListingScreen> createState() => _EditListingScreenState();
}

class _EditListingScreenState extends ConsumerState<EditListingScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _rentController;
  late TextEditingController _depositController;
  late ListingStatus _status;
  bool _isSublet = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.listing.title);
    _descController = TextEditingController(text: widget.listing.description ?? '');
    _rentController = TextEditingController(text: widget.listing.rent.round().toString());
    _depositController = TextEditingController(text: widget.listing.deposit.round().toString());
    _status = widget.listing.status;
    _isSublet = widget.listing.isSublet;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _rentController.dispose();
    _depositController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final updated = widget.listing.copyWith(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      rent: double.tryParse(_rentController.text) ?? widget.listing.rent,
      deposit: double.tryParse(_depositController.text) ?? widget.listing.deposit,
      status: _status,
      isSublet: _isSublet,
    );

    final repo = ref.read(listingRepositoryProvider);
    await repo.updateListing(updated);
    ref.read(myListingsProvider.notifier).loadMyListings();
    ref.read(listingsProvider.notifier).fetchListings(refresh: true);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listing updated successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Listing'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 1,
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF6366F1)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Listing Status', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<ListingStatus>(
              value: _status,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: ListingStatus.values.map((s) {
                return DropdownMenuItem(
                  value: s,
                  child: Text(s.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (val) => setState(() => _status = val!),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Listing Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _rentController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Monthly Rent (₹)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _depositController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Deposit (₹)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile.adaptive(
              title: const Text('Sublet / Short Stay Flag'),
              value: _isSublet,
              onChanged: (val) => setState(() => _isSublet = val),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}
