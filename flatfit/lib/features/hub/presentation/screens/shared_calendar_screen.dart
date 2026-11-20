import 'package:flutter/material.dart';
import 'package:flatfit/features/hub/domain/models/hub_models.dart';

/// Screen displaying the shared house calendar for flatmate transparency.
class SharedCalendarScreen extends StatefulWidget {
  final String flatId;
  final String currentUserId;
  final String currentUserName;
  final List<HubCalendarEvent>? events;

  const SharedCalendarScreen({
    super.key,
    required this.flatId,
    required this.currentUserId,
    required this.currentUserName,
    this.events,
  });

  @override
  State<SharedCalendarScreen> createState() => _SharedCalendarScreenState();
}

class _SharedCalendarScreenState extends State<SharedCalendarScreen> {
  late List<HubCalendarEvent> _events;
  CalendarEventType? _filterType;

  @override
  void initState() {
    super.initState();
    _events = widget.events != null ? List.from(widget.events!) : _getSampleEvents();
  }

  List<HubCalendarEvent> _getSampleEvents() {
    final now = DateTime.now();
    return [
      HubCalendarEvent(
        id: 'evt_1',
        flatId: widget.flatId,
        userId: widget.currentUserId,
        creatorName: widget.currentUserName,
        title: 'Friends visiting for match screening',
        description: '3 college friends coming over for match. Will wrap up by 11 PM.',
        type: CalendarEventType.party,
        startTime: now.add(const Duration(hours: 4)),
        endTime: now.add(const Duration(hours: 8)),
        createdAt: now,
      ),
      HubCalendarEvent(
        id: 'evt_2',
        flatId: widget.flatId,
        userId: 'user_ananya',
        creatorName: 'Ananya Sharma',
        title: 'Parents visiting for the weekend',
        description: 'Staying Friday evening to Sunday afternoon.',
        type: CalendarEventType.guest,
        startTime: now.add(const Duration(days: 2)),
        endTime: now.add(const Duration(days: 4)),
        isAllDay: true,
        createdAt: now,
      ),
      HubCalendarEvent(
        id: 'evt_3',
        flatId: widget.flatId,
        userId: 'user_kabir',
        creatorName: 'Kabir Mehta',
        title: 'Torrent Power Scheduled Maintenance',
        description: 'Scheduled transformer maintenance; power cut from 10 AM to 1 PM.',
        type: CalendarEventType.powerCut,
        startTime: now.add(const Duration(days: 3, hours: 10)),
        endTime: now.add(const Duration(days: 3, hours: 13)),
        createdAt: now,
      ),
    ];
  }

  void _showAddEventDialog() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    CalendarEventType selectedType = CalendarEventType.guest;
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add House Calendar Event'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Event Title',
                    hintText: 'e.g. Maid taking leave / Guests visiting',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<CalendarEventType>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Event Type',
                    border: OutlineInputBorder(),
                  ),
                  items: CalendarEventType.values
                      .map((t) => DropdownMenuItem(value: t, child: Text(t.name.toUpperCase())))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setDialogState(() => selectedType = val);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Notes / Timings',
                    hintText: 'Any special arrangements or timing notes',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty) return;
                setState(() {
                  _events.insert(
                    0,
                    HubCalendarEvent(
                      id: 'evt_${DateTime.now().millisecondsSinceEpoch}',
                      flatId: widget.flatId,
                      userId: widget.currentUserId,
                      creatorName: widget.currentUserName,
                      title: titleCtrl.text.trim(),
                      description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
                      type: selectedType,
                      startTime: selectedDate,
                      createdAt: DateTime.now(),
                    ),
                  );
                });
                Navigator.pop(ctx);
              },
              child: const Text('Save Event'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getEventColor(CalendarEventType type) {
    switch (type) {
      case CalendarEventType.guest:
        return Colors.teal.shade700;
      case CalendarEventType.party:
        return Colors.purple.shade700;
      case CalendarEventType.maintenance:
        return Colors.orange.shade800;
      case CalendarEventType.powerCut:
        return Colors.red.shade700;
      case CalendarEventType.maidOff:
        return Colors.blueGrey.shade800;
      case CalendarEventType.cleaning:
        return Colors.blue.shade700;
      case CalendarEventType.other:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    var displayList = _events;
    if (_filterType != null) {
      displayList = displayList.where((e) => e.type == _filterType).toList();
    }
    displayList.sort((a, b) => a.startTime.compareTo(b.startTime));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared House Calendar'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _filterType == null,
                  onSelected: (_) => setState(() => _filterType = null),
                ),
                const SizedBox(width: 6),
                ...CalendarEventType.values.map(
                  (type) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(type.name),
                      selected: _filterType == type,
                      onSelected: (val) => setState(() => _filterType = val ? type : null),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: displayList.isEmpty
                ? const Center(child: Text('No events scheduled'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: displayList.length,
                    itemBuilder: (_, idx) {
                      final evt = displayList[idx];
                      final color = _getEventColor(evt.type);

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 50,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      '${evt.startTime.day}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: color,
                                      ),
                                    ),
                                    Text(
                                      _monthShort(evt.startTime.month),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            evt.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: color.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            evt.type.name.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: color,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (evt.description != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        evt.description!,
                                        style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                                      ),
                                    ],
                                    const SizedBox(height: 6),
                                    Text(
                                      'Posted by ${evt.creatorName}',
                                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        onPressed: _showAddEventDialog,
        child: const Icon(Icons.add_alert_outlined),
      ),
    );
  }

  String _monthShort(int month) {
    const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return m[month - 1];
  }
}
