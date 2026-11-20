import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/meet_provider.dart';
import '../widgets/meet_place_card.dart';

class MeetSchedulerScreen extends ConsumerStatefulWidget {
  final String conversationId;
  final String partnerName;

  const MeetSchedulerScreen({
    Key? key,
    required this.conversationId,
    required this.partnerName,
  }) : super(key: key);

  @override
  ConsumerState<MeetSchedulerScreen> createState() =>
      _MeetSchedulerScreenState();
}

class _MeetSchedulerScreenState extends ConsumerState<MeetSchedulerScreen> {
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _contactController =
      TextEditingController(text: '+91 98765 43210');
  TimeOfDay _selectedTime = const TimeOfDay(hour: 16, minute: 30);
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 2));

  @override
  void dispose() {
    _notesController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      _updateDateTime();
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
      _updateDateTime();
    }
  }

  void _updateDateTime() {
    final combined = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    ref
        .read(meetProvider(widget.conversationId).notifier)
        .selectDate(combined);
  }

  @override
  Widget build(BuildContext context) {
    final meetState = ref.watch(meetProvider(widget.conversationId));
    final meetNotifier =
        ref.read(meetProvider(widget.conversationId).notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('Meet ${widget.partnerName}'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1E293B),
      ),
      body: meetState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Safety Header Banner
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(Icons.shield, color: Color(0xFF2563EB), size: 22),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'FlatFit Safe Meet: Always meet prospective flatmates in well-lit public cafes or metro plazas first.',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF1E40AF),
                              fontWeight: FontWeight.w500,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Date & Time Picker
                  const Text(
                    '1. Choose Date & Time',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickDate,
                          icon: const Icon(Icons.calendar_today, size: 16),
                          label: Text(
                            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickTime,
                          icon: const Icon(Icons.access_time, size: 16),
                          label: Text(
                            _selectedTime.format(context),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Suggested Public Places
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '2. Neutral Public Place',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Midpoint suggestions',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...meetState.suggestedPlaces.map((place) {
                    final isSelected = meetState.selectedPlace?.id == place.id;
                    return MeetPlaceCard(
                      place: place,
                      isSelected: isSelected,
                      onSelect: () => meetNotifier.selectPlace(place),
                    );
                  }).toList(),
                  const SizedBox(height: 18),

                  // Live Location Sharing Toggle with Emergency Contact
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.share_location,
                              color: Color(0xFF0D9488),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Share Live Location with Trusted Contact',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Switch.adaptive(
                              value: meetState.isLiveLocationEnabled,
                              activeColor: const Color(0xFF0D9488),
                              onChanged: (val) {
                                meetNotifier.toggleLiveLocation(
                                  val,
                                  contactPhone: _contactController.text,
                                );
                              },
                            ),
                          ],
                        ),
                        if (meetState.isLiveLocationEnabled) ...[
                          const SizedBox(height: 8),
                          const Text(
                            'Emergency Contact Phone (will receive SMS tracking link during meetup):',
                            style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _contactController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.phone, size: 16),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Notes TextField
                  TextField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      labelText: 'Notes (e.g. Discuss bills, quiet hours)',
                      hintText: 'Add an agenda or landmark details...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),

                  // Confirm button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final success = await meetNotifier.confirmMeet(
                          hostId: 'current_user',
                          participantId: 'user_other',
                          notes: _notesController.text.trim(),
                        );
                        if (success && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Meetup scheduled & invite sent to chat!'),
                              backgroundColor: Color(0xFF0D9488),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        'Send Meetup Invitation',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
