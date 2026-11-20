import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/profile_coach.dart';
import '../providers/ai_providers.dart';

/// Screen allowing the user to get real-time AI guidance to boost profile appeal and trust.
class ProfileCoachScreen extends ConsumerStatefulWidget {
  final String initialBio;
  final int initialPhotoCount;
  final bool hasKycVerified;
  final bool hasWorkEmailVerified;
  final bool hasVoiceIntro;
  final String? occupation;
  final String? city;

  const ProfileCoachScreen({
    super.key,
    this.initialBio = 'Working in IT. Need a room in Mumbai. Clean person.',
    this.initialPhotoCount = 2,
    this.hasKycVerified = false,
    this.hasWorkEmailVerified = false,
    this.hasVoiceIntro = false,
    this.occupation = 'Software Engineer',
    this.city = 'Mumbai',
  });

  @override
  ConsumerState<ProfileCoachScreen> createState() => _ProfileCoachScreenState();
}

class _ProfileCoachScreenState extends ConsumerState<ProfileCoachScreen> {
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(text: widget.initialBio);

    // Initial analysis
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileCoachProvider.notifier).analyze(
            bio: widget.initialBio,
            photoCount: widget.initialPhotoCount,
            hasVoiceIntro: widget.hasVoiceIntro,
            hasKycVerified: widget.hasKycVerified,
            hasWorkEmailVerified: widget.hasWorkEmailVerified,
            occupation: widget.occupation,
            city: widget.city,
          );
    });
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileCoachProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Profile Coach'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Re-analyze',
            onPressed: () {
              ref.read(profileCoachProvider.notifier).analyze(
                    bio: _bioController.text,
                    photoCount: widget.initialPhotoCount,
                    hasVoiceIntro: widget.hasVoiceIntro,
                    hasKycVerified: widget.hasKycVerified,
                    hasWorkEmailVerified: widget.hasWorkEmailVerified,
                    occupation: widget.occupation,
                    city: widget.city,
                  );
            },
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.result == null
              ? const Center(child: Text('No analysis available.'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Score Card Header
                      _buildScoreHeader(context, state.result!),
                      const SizedBox(height: 20),

                      // High Impact Tips
                      Text(
                        'Trust & Appeal Boosters',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      ...state.result!.tips.map((tip) => _buildTipCard(context, tip)),
                      const SizedBox(height: 24),

                      // Bio Rewrite Assistant
                      Text(
                        'AI Bio Rewriter',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select a style to generate a tailored bio matching your personality:',
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 12),
                      _buildToneChips(context, state),
                      const SizedBox(height: 12),
                      _buildRewritePreview(context, state),
                      const SizedBox(height: 24),

                      // Photo Order Guidance
                      Text(
                        'Optimal Photo Order',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'First impressions happen in 2 seconds. Place your photos strategically:',
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 12),
                      ...state.result!.photoAdvice.map((advice) => _buildPhotoAdviceRow(context, advice)),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
    );
  }

  Widget _buildScoreHeader(BuildContext context, ProfileCoachResult result) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: CircularProgressIndicator(
                      value: result.overallScore / 100,
                      strokeWidth: 7,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.amberAccent),
                    ),
                  ),
                  Text(
                    '${result.overallScore}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Profile Strength',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      result.overallScore >= 75
                          ? 'Excellent! Your profile stands out in search results.'
                          : 'A few quick tweaks will double your match requests.',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMiniScore('Bio Clarity', '${result.bioClarityScore}%'),
              _buildMiniScore('Photos', '${result.photoQualityScore}%'),
              _buildMiniScore('Trust', '${result.trustPotentialScore}%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniScore(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildTipCard(BuildContext context, ProfileCoachingTip tip) {
    final isCritical = tip.priority == TipPriority.critical;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isCritical ? Colors.amber.shade400 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: isCritical ? Colors.amber.shade100 : Colors.teal.shade50,
              child: Icon(
                isCritical ? Icons.star : Icons.lightbulb_outline,
                size: 20,
                color: isCritical ? Colors.orange.shade800 : Colors.teal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tip.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(tip.description, style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToneChips(BuildContext context, ProfileCoachState state) {
    final tones = [
      {'tone': BioTone.warmFriendly, 'label': 'Warm & Friendly'},
      {'tone': BioTone.professional, 'label': 'Professional'},
      {'tone': BioTone.chillCasual, 'label': 'Chill & Casual'},
      {'tone': BioTone.crispConcise, 'label': 'Crisp & Bulleted'},
    ];

    return Wrap(
      spacing: 8,
      children: tones.map((item) {
        final tone = item['tone'] as BioTone;
        final label = item['label'] as String;
        final isSelected = state.selectedTone == tone;

        return ChoiceChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (_) => ref.read(profileCoachProvider.notifier).selectTone(tone),
          selectedColor: const Color(0xFF0D9488),
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRewritePreview(BuildContext context, ProfileCoachState state) {
    final generatedBio = state.result?.bioRewrites[state.selectedTone] ?? '';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.auto_awesome, color: Color(0xFF0D9488), size: 18),
                  SizedBox(width: 6),
                  Text('AI Generated Bio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              TextButton.icon(
                icon: const Icon(Icons.copy, size: 14),
                label: const Text('Copy', style: TextStyle(fontSize: 12)),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: generatedBio));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bio copied to clipboard!')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            generatedBio,
            style: const TextStyle(fontSize: 13, height: 1.45, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoAdviceRow(BuildContext context, PhotoOrderAdvice advice) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: advice.isSatisfied ? Colors.green.shade50 : Colors.grey.shade100,
              shape: BoxShape.circle,
              border: Border.all(
                color: advice.isSatisfied ? Colors.green : Colors.grey.shade400,
              ),
            ),
            child: Text(
              '${advice.slotIndex}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: advice.isSatisfied ? Colors.green.shade800 : Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  advice.suggestedContentType,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                Text(
                  advice.rationale,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                ),
              ],
            ),
          ),
          if (advice.isSatisfied)
            const Icon(Icons.check_circle, color: Colors.green, size: 18)
          else
            const Icon(Icons.add_circle_outline, color: Colors.teal, size: 18),
        ],
      ),
    );
  }
}
