import '../domain/city_guide.dart';
import '../domain/event.dart';
import '../domain/referral.dart';
import '../domain/ambassador.dart';

abstract class CommunityRepository {
  Future<List<LocalityGuide>> getCityGuides();
  Future<LocalityGuide?> getGuideById(String id);
  Future<List<CommunityEvent>> getEvents();
  Future<void> toggleRsvp(String eventId, RsvpStatus status);
  Future<UserReferralSummary> getReferralSummary(String userId, String userName);
  Future<List<AmbassadorProfile>> getAmbassadors();
  Future<bool> applyForAmbassador({
    required String name,
    required AmbassadorType type,
    required String institution,
    required String email,
  });
}

class CommunityRepositoryImpl implements CommunityRepository {
  final List<CommunityEvent> _events = List.from(MockCommunityEvents.list);

  @override
  Future<List<LocalityGuide>> getCityGuides() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return MumbaiLocalityGuides.all;
  }

  @override
  Future<LocalityGuide?> getGuideById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    try {
      return MumbaiLocalityGuides.all.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<CommunityEvent>> getEvents() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _events;
  }

  @override
  Future<void> toggleRsvp(String eventId, RsvpStatus status) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final idx = _events.indexWhere((e) => e.id == eventId);
    if (idx != -1) {
      final current = _events[idx];
      final change = (status == RsvpStatus.going) ? 1 : (current.userRsvp == RsvpStatus.going ? -1 : 0);
      _events[idx] = current.copyWith(
        userRsvp: status,
        currentAttendees: current.currentAttendees + change,
      );
    }
  }

  @override
  Future<UserReferralSummary> getReferralSummary(String userId, String userName) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return ReferralEngine.getDefaultSummary(userId, userName);
  }

  @override
  Future<List<AmbassadorProfile>> getAmbassadors() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return MockAmbassadorData.leaderboard;
  }

  @override
  Future<bool> applyForAmbassador({
    required String name,
    required AmbassadorType type,
    required String institution,
    required String email,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return true;
  }
}
