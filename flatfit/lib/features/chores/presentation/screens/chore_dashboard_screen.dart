import 'package:flutter/material.dart';
import '../../domain/models/chore_models.dart';
import '../../domain/services/chore_rotation_engine.dart';
import '../widgets/chore_card.dart';
import '../widgets/fairness_meter.dart';
import 'add_chore_screen.dart';
import 'chore_fairness_screen.dart';
import 'chore_swap_dialog.dart';

/// Central screen for Module 9 (Chore Planner & Rotation Engine).
class ChoreDashboardScreen extends StatefulWidget {
  final String flatId;
  final String currentUserId;
  final String currentUserName;

  const ChoreDashboardScreen({
    super.key,
    required this.flatId,
    required this.currentUserId,
    this.currentUserName = 'Rohan Verma',
  });

  @override
  State<ChoreDashboardScreen> createState() => _ChoreDashboardScreenState();
}

class _ChoreDashboardScreenState extends State<ChoreDashboardScreen> {
  late List<ChoreAssignment> _assignments;
  final List<String> _memberIds = ['user_rohan', 'user_ananya', 'user_kabir'];
  final Map<String, String> _memberNames = {
    'user_rohan': 'Rohan Verma',
    'user_ananya': 'Ananya Sharma',
    'user_kabir': 'Kabir Mehta',
  };

  @override
  void initState() {
    super.initState();
    _assignments = _getSampleAssignments();
  }

  List<ChoreAssignment> _getSampleAssignments() {
    final now = DateTime.now();
    return [
      ChoreAssignment(
        id: 'asg_1',
        choreId: 'ch_trash',
        choreTitle: 'Take out daily kitchen trash & dry waste',
        userId: widget.currentUserId,
        userName: widget.currentUserName,
        dueDate: now,
        effortPoints: 1,
        effort: ChoreEffort.light,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      ChoreAssignment(
        id: 'asg_2',
        choreId: 'ch_dish',
        choreTitle: 'Unload drying rack & wipe kitchen counters',
        userId: 'user_ananya',
        userName: 'Ananya Sharma',
        dueDate: now,
        effortPoints: 2,
        effort: ChoreEffort.medium,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      ChoreAssignment(
        id: 'asg_3',
        choreId: 'ch_bath',
        choreTitle: 'Deep scrub bathroom & mirror (Weekly)',
        userId: 'user_kabir',
        userName: 'Kabir Mehta',
        dueDate: now.add(const Duration(days: 1)),
        effortPoints: 3,
        effort: ChoreEffort.heavy,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      ChoreAssignment(
        id: 'asg_4',
        choreId: 'ch_fridge',
        choreTitle: 'Clean refrigerator shelves & discard expired food',
        userId: widget.currentUserId,
        userName: widget.currentUserName,
        dueDate: now.subtract(const Duration(days: 1)),
        completedAt: now.subtract(const Duration(hours: 12)),
        effortPoints: 2,
        effort: ChoreEffort.medium,
        createdAt: now.subtract(const Duration(days: 3)),
      ),
    ];
  }

  void _onToggleChore(ChoreAssignment asg, bool isCompleted) {
    setState(() {
      final idx = _assignments.indexWhere((a) => a.id == asg.id);
      if (idx != -1) {
        _assignments[idx] = _assignments[idx].copyWith(
          completedAt: isCompleted ? DateTime.now() : null,
        );
      }
    });

    if (isCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 Awesome! You earned ${asg.effortPoints} points for "${asg.choreTitle}".'),
          backgroundColor: Colors.green.shade700,
        ),
      );
    }
  }

  void _sendNudge(ChoreAssignment asg) {
    final nudgeText = ChoreRotationEngine.generateChoreNudge(
      choreTitle: asg.choreTitle,
      assigneeName: asg.userName,
      isOverdue: asg.isOverdue,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sent reminder to ${asg.userName}: "$nudgeText"'),
        backgroundColor: Colors.amber.shade900,
      ),
    );
  }

  void _openSwapDialog(ChoreAssignment asg) {
    showDialog(
      context: context,
      builder: (_) => ChoreSwapDialog(
        assignment: asg,
        memberNames: _memberNames,
        currentUserId: widget.currentUserId,
        onSwapProposed: (targetUserId, message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Swap request sent to ${_memberNames[targetUserId]}!'),
              backgroundColor: Colors.teal.shade700,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final report = ChoreRotationEngine.calculateFairnessReport(
      memberUserIds: _memberIds,
      userNames: _memberNames,
      assignments: _assignments,
    );

    final pendingChores = _assignments.where((a) => !a.isCompleted).toList();
    final completedChores = _assignments.where((a) => a.isCompleted).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chore Planner & Rotation'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard_outlined),
            tooltip: 'Fairness Score & Leaderboard',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChoreFairnessScreen(report: report),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          FairnessMeterCard(
            report: report,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChoreFairnessScreen(report: report),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pending House Chores (${pendingChores.length})',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Auto-rotating weekly',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          ...pendingChores.map(
            (asg) => ChoreCard(
              assignment: asg,
              currentUserId: widget.currentUserId,
              onToggleComplete: (val) => _onToggleChore(asg, val),
              onNudge: () => _sendNudge(asg),
              onSwap: () => _openSwapDialog(asg),
            ),
          ),
          if (completedChores.isNotEmpty) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Completed Recently (${completedChores.length})',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            ...completedChores.map(
              (asg) => ChoreCard(
                assignment: asg,
                currentUserId: widget.currentUserId,
                onToggleComplete: (val) => _onToggleChore(asg, val),
              ),
            ),
          ],
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_task),
        label: const Text('Add Chore'),
        onPressed: () async {
          final newChore = await Navigator.push<Chore>(
            context,
            MaterialPageRoute(
              builder: (_) => AddChoreScreen(
                flatId: widget.flatId,
                flatmateIds: _memberIds,
                flatmateNames: _memberNames,
              ),
            ),
          );
          if (newChore != null) {
            // Assign immediately using fair rotation engine
            final historicalPoints = <String, int>{
              for (final st in report.flatmateStats) st.userId: st.completedPoints
            };
            final nextAssignee = ChoreRotationEngine.pickNextAssignee(
              candidateUserIds: newChore.rotationUserIds.isNotEmpty
                  ? newChore.rotationUserIds
                  : _memberIds,
              historicalEffortPoints: historicalPoints,
            );

            setState(() {
              _assignments.insert(
                0,
                ChoreAssignment(
                  id: 'asg_${DateTime.now().millisecondsSinceEpoch}',
                  choreId: newChore.id,
                  choreTitle: newChore.title,
                  userId: nextAssignee,
                  userName: _memberNames[nextAssignee] ?? nextAssignee,
                  dueDate: DateTime.now().add(const Duration(days: 1)),
                  effortPoints: newChore.effort.points,
                  effort: newChore.effort,
                  createdAt: DateTime.now(),
                ),
              );
            });
          }
        },
      ),
    );
  }
}
