import 'package:flutter/material.dart';
import '../../domain/models/chore_models.dart';

/// Screen displaying the full House Fairness leaderboard, points distribution, and harmony metrics.
class ChoreFairnessScreen extends StatelessWidget {
  final ChoreFairnessReport report;

  const ChoreFairnessScreen({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    final sortedStats = List<FlatmateChoreStat>.from(report.flatmateStats)
      ..sort((a, b) => b.completedPoints.compareTo(a.completedPoints));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fairness Score & Leaderboard'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeroScoreCard(report.harmonyScore),
          const SizedBox(height: 20),
          const Text(
            'Flatmate Effort Leaderboard',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ...sortedStats.asMap().entries.map((entry) {
            final rank = entry.key + 1;
            final stat = entry.value;
            return _buildLeaderboardTile(rank, stat);
          }),
          const SizedBox(height: 24),
          _buildAlgorithmInfoCard(),
        ],
      ),
    );
  }

  Widget _buildHeroScoreCard(double score) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(16),
        border: BorderSide(color: Colors.teal.shade200),
      ),
      child: Column(
        children: [
          const Text(
            'Overall House Harmony',
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 6),
          Text(
            '${score.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            score >= 80 ? 'Excellent Balance! 🌟' : 'Fair Distribution in Progress',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.teal.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Total effort points logged: ${report.totalHousePointsCompleted} pts across household',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTile(int rank, FlatmateChoreStat stat) {
    Color medalColor;
    if (rank == 1) {
      medalColor = Colors.amber.shade700;
    } else if (rank == 2) {
      medalColor = Colors.blueGrey.shade400;
    } else {
      medalColor = Colors.brown.shade400;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: medalColor.withOpacity(0.15),
          child: Text(
            '#$rank',
            style: TextStyle(fontWeight: FontWeight.bold, color: medalColor),
          ),
        ),
        title: Text(stat.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          '${stat.completedCount} chores done • ${stat.pendingCount} pending${stat.overdueCount > 0 ? " • ${stat.overdueCount} overdue" : ""}',
          style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${stat.completedPoints} pts',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.teal.shade900,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlgorithmInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.balance, size: 20, color: Colors.teal.shade800),
              const SizedBox(width: 8),
              const Text(
                'How FlatFit Fairness Scoring Works',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Tasks are weighted by effort (1 pt for light, 2 pts for medium, 3 pts for heavy deep cleaning). '
            'The rotation engine automatically routes the next task to the flatmate with the lowest score to keep home life harmonious.',
            style: TextStyle(fontSize: 12.5, color: Colors.black87, height: 1.4),
          ),
        ],
      ),
    );
  }
}
