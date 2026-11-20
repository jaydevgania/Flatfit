import 'dart:math';
import '../models/chore_models.dart';

/// Engine responsible for chore rotation, fairness scoring, and nudge generation.
class ChoreRotationEngine {
  /// Selects the best candidate to assign a chore next.
  /// Prefers flatmates with lowest completed effort points to balance the workload.
  static String pickNextAssignee({
    required List<String> candidateUserIds,
    required Map<String, int> historicalEffortPoints,
    String? previousAssigneeId,
  }) {
    if (candidateUserIds.isEmpty) return '';
    if (candidateUserIds.length == 1) return candidateUserIds.first;

    // Filter candidates (try to avoid back-to-back assignment of same chore if > 1 candidate)
    final eligible = candidateUserIds.where((u) => u != previousAssigneeId).toList();
    final pool = eligible.isNotEmpty ? eligible : candidateUserIds;

    // Pick candidate with minimum points
    String bestCandidate = pool.first;
    int minPts = historicalEffortPoints[bestCandidate] ?? 0;

    for (final uid in pool) {
      final pts = historicalEffortPoints[uid] ?? 0;
      if (pts < minPts) {
        minPts = pts;
        bestCandidate = uid;
      }
    }

    return bestCandidate;
  }

  /// Calculates the house harmony / fairness score (0 to 100%).
  /// A high score means effort is evenly divided among flatmates.
  static ChoreFairnessReport calculateFairnessReport({
    required List<String> memberUserIds,
    required Map<String, String> userNames,
    required List<ChoreAssignment> assignments,
  }) {
    if (memberUserIds.isEmpty) {
      return const ChoreFairnessReport(
        harmonyScore: 100.0,
        flatmateStats: [],
        totalHousePointsCompleted: 0,
      );
    }

    final stats = <String, FlatmateChoreStat>{};
    for (final uid in memberUserIds) {
      final userAssignments = assignments.where((a) => a.userId == uid).toList();
      final completed = userAssignments.where((a) => a.isCompleted).toList();
      final completedPts = completed.fold<int>(0, (s, a) => s + a.effortPoints);
      final pending = userAssignments.where((a) => !a.isCompleted && !a.isOverdue).length;
      final overdue = userAssignments.where((a) => a.isOverdue).length;

      stats[uid] = FlatmateChoreStat(
        userId: uid,
        userName: userNames[uid] ?? uid,
        completedPoints: completedPts,
        completedCount: completed.length,
        pendingCount: pending,
        overdueCount: overdue,
      );
    }

    final totalPts = stats.values.fold<int>(0, (s, st) => s + st.completedPoints);
    final n = memberUserIds.length;
    final idealShare = n > 0 ? (totalPts / n) : 0.0;

    double harmonyScore = 100.0;
    if (totalPts > 0 && idealShare > 0) {
      // Calculate mean absolute deviation
      double totalDeviation = 0;
      for (final st in stats.values) {
        totalDeviation += (st.completedPoints - idealShare).abs();
      }
      final relativeDeviation = totalDeviation / (totalPts * 2); // 0 to 1
      harmonyScore = ((1.0 - relativeDeviation) * 100.0).clamp(10.0, 100.0);
    }

    return ChoreFairnessReport(
      harmonyScore: (harmonyScore * 10).round() / 10.0,
      flatmateStats: stats.values.toList(),
      totalHousePointsCompleted: totalPts,
    );
  }

  /// Generates a friendly reminder nudge for a pending or overdue chore.
  static String generateChoreNudge({
    required String choreTitle,
    required String assigneeName,
    bool isOverdue = false,
  }) {
    if (isOverdue) {
      return 'Hey $assigneeName! ⏰ The "$choreTitle" task was due yesterday. '
          'Could you please wrap it up today so we keep our House Harmony score up? 🙏';
    } else {
      return 'Friendly heads up for $assigneeName! ✨ You have "$choreTitle" scheduled for today. Thanks for keeping our home clean! 🏡';
    }
  }
}
