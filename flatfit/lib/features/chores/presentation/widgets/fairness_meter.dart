import 'package:flutter/material.dart';
import '../../domain/models/chore_models.dart';

/// Visual gauge and summary card displaying the household Chore Fairness Score.
class FairnessMeterCard extends StatelessWidget {
  final ChoreFairnessReport report;
  final VoidCallback onTap;

  const FairnessMeterCard({
    super.key,
    required this.report,
    required this.onTap,
  });

  Color _getScoreColor(double score) {
    if (score >= 85) return Colors.green.shade600;
    if (score >= 70) return Colors.teal.shade600;
    if (score >= 50) return Colors.amber.shade700;
    return Colors.red.shade700;
  }

  @override
  Widget build(BuildContext context) {
    final score = report.harmonyScore;
    final color = _getScoreColor(score);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: BorderSide(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 58,
                  height: 58,
                  child: CircularProgressIndicator(
                    value: score / 100.0,
                    strokeWidth: 6,
                    backgroundColor: Colors.grey.shade100,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                Text(
                  '${score.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'House Harmony Score',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.stars, color: color, size: 16),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    score >= 80
                        ? 'Chore distribution is very balanced among flatmates!'
                        : 'Workload slightly uneven; view fairness report to balance.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
