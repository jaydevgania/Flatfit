import 'package:flutter/material.dart';
import '../../domain/ai_interviewer.dart';

/// Screen allowing two prospective flatmates to complete a quick 5-step compatibility interview.
class AiInterviewerScreen extends StatefulWidget {
  final String matchName;
  final Map<String, String>? initialMatchAnswers;

  const AiInterviewerScreen({
    super.key,
    this.matchName = 'Aarav Mehta',
    this.initialMatchAnswers,
  });

  @override
  State<AiInterviewerScreen> createState() => _AiInterviewerScreenState();
}

class _AiInterviewerScreenState extends State<AiInterviewerScreen> {
  int _currentIndex = 0;
  final Map<String, String> _myAnswers = {};
  late final Map<String, String> _matchAnswers;
  InterviewSummary? _summary;

  @override
  void initState() {
    super.initState();
    _matchAnswers = widget.initialMatchAnswers ?? {
      'q1_rhythm': 'Balanced Rhythm (Sleep around midnight, up 7:30 - 8:30 AM)',
      'q2_cleanliness': 'Immediate wash after eating, counter kept spotless',
      'q3_guests': 'Occasional friends / weekend dinners with advance notice',
      'q4_kitchen': 'Cook together, share groceries & kitchen supplies',
      'q5_bills': 'Strict auto-pay 1st of month, splitwise updated real-time',
    };
  }

  void _selectOption(String questionId, String option) {
    setState(() {
      _myAnswers[questionId] = option;
      if (_currentIndex < AiInterviewerEngine.defaultQuestions.length - 1) {
        _currentIndex++;
      } else {
        // Compute summary
        _summary = AiInterviewerEngine.generateSummary(
          userAAnswers: _myAnswers,
          userBAnswers: _matchAnswers,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final questions = AiInterviewerEngine.defaultQuestions;
    final isDone = _summary != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isDone ? 'Compatibility Summary' : 'AI Match Interviewer'),
        centerTitle: true,
      ),
      body: isDone
          ? _buildSummaryView(context)
          : Column(
              children: [
                // Progress indicator
                LinearProgressIndicator(
                  value: (_currentIndex + 1) / questions.length,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0D9488)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${_currentIndex + 1} of ${questions.length}',
                        style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Comparing with ${widget.matchName}',
                        style: const TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildQuestionCard(context, questions[_currentIndex]),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildQuestionCard(BuildContext context, InterviewQuestion q) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                q.topic.name.toUpperCase(),
                style: const TextStyle(color: Color(0xFF0D9488), fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              q.promptText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.3),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: q.options.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, idx) {
                  final opt = q.options[idx];
                  final isSelected = _myAnswers[q.id] == opt;

                  return InkWell(
                    onTap: () => _selectOption(q.id, opt),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFE6FFFA) : Colors.grey.shade50,
                        border: Border.all(
                          color: isSelected ? const Color(0xFF0D9488) : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                            color: isSelected ? const Color(0xFF0D9488) : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              opt,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? const Color(0xFF0D9488) : Colors.black87,
                              ),
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
      ),
    );
  }

  Widget _buildSummaryView(BuildContext context) {
    final summary = _summary!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Synergy Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF3730A3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white24,
                  child: Text(
                    '${summary.synergyScore}%',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Compatibility with ${widget.matchName}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        summary.summaryVerdict,
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Shared Strengths
          const Text('Where You Align', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          ...summary.sharedStrengths.map((s) => _buildItemRow(Icons.check_circle, Colors.green, s)),
          const SizedBox(height: 20),

          // Friction Points
          if (summary.frictionPoints.isNotEmpty) ...[
            const Text('Things to Discuss', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            ...summary.frictionPoints.map((f) => _buildItemRow(Icons.info_outline, Colors.orange, f)),
            const SizedBox(height: 20),
          ],

          // Icebreakers
          const Text('Suggested Icebreakers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          ...summary.suggestedIcebreakers.map((ice) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.teal.shade100),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline, color: Color(0xFF0D9488), size: 18),
                    const SizedBox(width: 10),
                    Expanded(child: Text(ice, style: const TextStyle(fontSize: 13, height: 1.3))),
                  ],
                ),
              )),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.message),
              label: Text('Chat with ${widget.matchName}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D9488),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(IconData icon, Color color, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, height: 1.35))),
        ],
      ),
    );
  }
}
