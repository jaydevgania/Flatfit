import 'package:flutter/material.dart';
import '../../domain/models/exit_models.dart';

/// Visual timeline stepper tracking the 5 phases of moving out and replacement.
class ExitTimelineStepper extends StatelessWidget {
  final ExitPhase currentPhase;

  const ExitTimelineStepper({
    super.key,
    required this.currentPhase,
  });

  int _getPhaseIndex(ExitPhase phase) {
    switch (phase) {
      case ExitPhase.noticeGiven:
        return 0;
      case ExitPhase.findingReplacement:
        return 1;
      case ExitPhase.damageInspection:
        return 2;
      case ExitPhase.depositSettlement:
        return 3;
      case ExitPhase.handoverCompleted:
        return 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getPhaseIndex(currentPhase);
    final steps = [
      'Notice (30d)',
      'Replacement',
      'Inspection',
      'Settlement',
      'Handover',
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Exit & Replacement Protocol',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Step ${currentIndex + 1} of 5',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: Colors.teal.shade900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: List.generate(steps.length * 2 - 1, (index) {
              if (index.isEven) {
                final stepIndex = index ~/ 2;
                final isDone = stepIndex < currentIndex;
                final isCurrent = stepIndex == currentIndex;

                Color circleColor;
                if (isDone) {
                  circleColor = Colors.green.shade600;
                } else if (isCurrent) {
                  circleColor = Colors.teal.shade700;
                } else {
                  circleColor = Colors.grey.shade300;
                }

                return Column(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: circleColor,
                      child: isDone
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                          : Text(
                              '${stepIndex + 1}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      steps[stepIndex],
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                        color: isCurrent ? Colors.teal.shade900 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                );
              } else {
                final barIndex = index ~/ 2;
                final isDone = barIndex < currentIndex;
                return Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 16),
                    color: isDone ? Colors.green.shade600 : Colors.grey.shade300,
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
