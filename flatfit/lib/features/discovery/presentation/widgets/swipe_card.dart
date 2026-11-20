import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flatfit/features/matching/domain/profile.dart';
import 'compatibility_badge.dart';

/// Draggable Tinder-style swipe card displaying a flatmate candidate profile.
///
/// Features:
/// - Full card primary photo with gradient overlay
/// - Compatibility badge (0-100)
/// - Name, age, occupation, verified badge
/// - Key traits chips
/// - Budget range display
/// - Visual swipe overlays for Like (Right), Pass (Left), and Super Interest (Up)
class SwipeCard extends StatefulWidget {
  final Profile profile;
  final double compatibilityScore;
  final VoidCallback? onTap;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeUp;
  final bool isTopCard;

  const SwipeCard({
    super.key,
    required this.profile,
    this.compatibilityScore = 85.0,
    this.onTap,
    this.onSwipeRight,
    this.onSwipeLeft,
    this.onSwipeUp,
    this.isTopCard = true,
  });

  @override
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard>
    with SingleTickerProviderStateMixin {
  Offset _dragOffset = Offset.zero;
  late AnimationController _animController;
  late Animation<Offset> _springAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animController.addListener(() {
      setState(() {
        _dragOffset = _springAnimation.value;
      });
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.isTopCard) return;
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (!widget.isTopCard) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final threshold = screenWidth * 0.35;

    if (_dragOffset.dx > threshold) {
      // Swiped Right (Interest)
      _completeSwipe(const Offset(500, 0), widget.onSwipeRight);
    } else if (_dragOffset.dx < -threshold) {
      // Swiped Left (Pass)
      _completeSwipe(const Offset(-500, 0), widget.onSwipeLeft);
    } else if (_dragOffset.dy < -120) {
      // Swiped Up (Super Interest)
      _completeSwipe(const Offset(0, -600), widget.onSwipeUp);
    } else {
      // Spring back to center
      _springAnimation = Tween<Offset>(
        begin: _dragOffset,
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
      );
      _animController.forward(from: 0.0);
    }
  }

  void _completeSwipe(Offset target, VoidCallback? callback) {
    _springAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: target,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward(from: 0.0).then((_) {
      callback?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final rotationAngle = (_dragOffset.dx / 300) * (math.pi / 18);

    return Transform.translate(
      offset: _dragOffset,
      child: Transform.rotate(
        angle: rotationAngle,
        child: GestureDetector(
          onPanUpdate: widget.isTopCard ? _onPanUpdate : null,
          onPanEnd: widget.isTopCard ? _onPanEnd : null,
          onTap: widget.onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Card background photo
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  widget.profile.displayPhoto,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade800,
                    child: const Center(
                      child: Icon(Icons.person, size: 80, color: Colors.white54),
                    ),
                  ),
                ),
              ),

              // Gradient overlays
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.85),
                        Colors.black.withOpacity(0.95),
                      ],
                      stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                    ),
                  ),
                ),
              ),

              // Top row: Compatibility badge & Housing Goal tag
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CompatibilityBadge(
                      score: widget.compatibilityScore,
                      size: BadgeSize.medium,
                      showLabel: true,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white30),
                      ),
                      child: Text(
                        widget.profile.housingGoal == 'have_room'
                            ? '🏠 Has a Room'
                            : '🔍 Needs Room',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom information sheet
              Positioned(
                bottom: 24,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Name & Age & Verified
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${widget.profile.fullName}, ${widget.profile.age}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.profile.isVerified) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.verified_rounded,
                            color: Color(0xFF38BDF8),
                            size: 22,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Occupation & Locality
                    Row(
                      children: [
                        const Icon(Icons.work_outline_rounded, size: 15, color: Colors.white70),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            widget.profile.companyOrCollege ??
                                widget.profile.occupation.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 15, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(
                          widget.profile.locality ?? widget.profile.city,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.currency_rupee_rounded, size: 15, color: Colors.white70),
                        Text(
                          widget.profile.budgetDisplay,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // 3 Key matching traits chips
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: widget.profile.keyTraits.take(3).map((trait) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            trait,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // Visual Stamp Overlays when dragging
              if (widget.isTopCard && _dragOffset.dx > 40)
                Positioned(
                  top: 90,
                  left: 30,
                  child: Transform.rotate(
                    angle: -0.2,
                    child: _buildStamp(
                      text: 'INTERESTED',
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ),
              if (widget.isTopCard && _dragOffset.dx < -40)
                Positioned(
                  top: 90,
                  right: 30,
                  child: Transform.rotate(
                    angle: 0.2,
                    child: _buildStamp(
                      text: 'PASS',
                      color: const Color(0xFFEF4444),
                    ),
                  ),
                ),
              if (widget.isTopCard && _dragOffset.dy < -60 && _dragOffset.dx.abs() < 50)
                Positioned(
                  top: 140,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _buildStamp(
                      text: 'SUPER INTEREST ⭐',
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStamp({required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 3),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 24,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
