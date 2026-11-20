import '../domain/compatibility_engine.dart';
import '../domain/match_outcome.dart';
import '../domain/match_result.dart';
import '../domain/profile.dart';
import 'matching_data_source.dart';

/// Combined entity pairing a target flatmate's profile with their MatchResult.
class MatchedProfile {
  final Profile profile;
  final MatchResult matchResult;

  const MatchedProfile({
    required this.profile,
    required this.matchResult,
  });

  double get score => matchResult.score;
  List<String> get compatibleTopics => matchResult.compatibleTopics;
  List<String> get watchOutTopics => matchResult.watchOutTopics;
  CompatibilityLabel get label => matchResult.label;
}

/// Repository managing match calculations, precomputed matches, and ML outcome logging.
class MatchingRepository {
  final MatchingDataSource _dataSource;

  MatchingRepository(this._dataSource);

  /// Retrieves list of matched profiles for the current user.
  Future<List<MatchedProfile>> getMatches({
    required String currentUserId,
    int limit = 50,
    int offset = 0,
    double minScore = 0.0,
  }) async {
    try {
      final records = await _dataSource.getPrecomputedMatches(
        currentUserId: currentUserId,
        limit: limit,
        offset: offset,
        minScore: minScore,
      );

      final results = <MatchedProfile>[];

      for (final row in records) {
        final userA = row['user_a'] as String;
        final userB = row['user_b'] as String;
        final targetId = userA == currentUserId ? userB : userA;

        final targetProfile = await _dataSource.getProfileById(targetId);
        if (targetProfile == null) continue;

        final matchResult = MatchResult(
          targetUserId: targetId,
          score: (row['score'] as num).toDouble(),
          compatibleTopics: (row['compatible_topics'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              const [],
          watchOutTopics: (row['watch_out_topics'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              const [],
          label: CompatibilityLabel.fromScore((row['score'] as num).toDouble()),
          computedAt: row['computed_at'] != null
              ? DateTime.tryParse(row['computed_at'].toString()) ?? DateTime.now()
              : DateTime.now(),
        );

        results.add(MatchedProfile(
          profile: targetProfile,
          matchResult: matchResult,
        ));
      }

      if (results.isEmpty) {
        return _getDemoMatches(currentUserId);
      }

      return results;
    } catch (_) {
      // Fallback to rich demo matches for development / offline preview
      return _getDemoMatches(currentUserId);
    }
  }

  /// Runs dynamic compatibility computation in real time using the pure CompatibilityEngine.
  Future<MatchResult?> computeLiveCompatibility({
    required Profile currentUser,
    required Profile targetUser,
    HardFilters filters = HardFilters.defaults,
    CompatibilityWeights weights = CompatibilityWeights.defaults,
  }) async {
    try {
      final answersA = await _dataSource.getUserAnswers(currentUser.id);
      final answersB = await _dataSource.getUserAnswers(targetUser.id);

      return CompatibilityEngine.computeCompatibility(
        userA: currentUser,
        userB: targetUser,
        answersA: answersA,
        answersB: answersB,
        filters: filters,
        weights: weights,
      );
    } catch (_) {
      // Fallback computation
      return CompatibilityEngine.computeCompatibility(
        userA: currentUser,
        userB: targetUser,
        answersA: const [],
        answersB: const [],
        filters: filters,
        weights: weights,
      );
    }
  }

  /// Persists precomputed match record to Supabase.
  Future<void> saveMatch({
    required String userA,
    required String userB,
    required MatchResult result,
  }) async {
    try {
      await _dataSource.upsertMatchRecord(
        userA: userA,
        userB: userB,
        score: result.score.toInt(),
        compatibleTopics: result.compatibleTopics,
        watchOutTopics: result.watchOutTopics,
      );
    } catch (_) {
      // Ignore if offline
    }
  }

  /// Logs match progression (matched -> met -> movedIn -> stayed) for ML feedback loops.
  Future<void> logOutcome({
    required String userA,
    required String userB,
    required MatchOutcome outcome,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _dataSource.recordMatchOutcome(
        userA: userA,
        userB: userB,
        outcome: outcome,
        metadata: metadata,
      );
    } catch (_) {
      // Ignore if offline
    }
  }

  /// Sample demo data for Mumbai flatmates.
  List<MatchedProfile> _getDemoMatches(String currentUserId) {
    return [
      MatchedProfile(
        profile: Profile(
          id: 'p_rohan',
          fullName: 'Rohan Sharma',
          age: 26,
          gender: 'male',
          occupation: 'working',
          companyOrCollege: 'Razorpay, Product Designer',
          city: 'Mumbai',
          locality: 'Bandra West',
          bio: 'UI designer at fintech startup. Early riser, love pour-over coffee, gym 4x/week, and quiet evenings.',
          housingGoal: 'need_room',
          budgetMin: 20000,
          budgetMax: 30000,
          preferredLocalities: const ['Bandra West', 'Khar West', 'Pali Hill'],
          location: const GeoLocation(latitude: 19.0596, longitude: 72.8295),
          moveInDate: DateTime.now().add(const Duration(days: 14)),
          stayDuration: '1 year',
          profileCompletion: 95,
          isVerified: true,
          photos: const [
            'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=800&q=80',
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=800&q=80',
          ],
          primaryPhotoUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=800&q=80',
          keyTraits: const ['Non-Smoker', 'Early Bird', 'Pure Veg friendly', 'WFH 2 days'],
        ),
        matchResult: MatchResult(
          targetUserId: 'p_rohan',
          score: 94.0,
          compatibleTopics: const ['Sleep Schedule', 'Cleanliness', 'Smoking', 'Rent Punctuality'],
          watchOutTopics: const [],
          label: CompatibilityLabel.greatMatch,
          topicScores: const {
            'Sleep Schedule': 10.0,
            'Cleanliness': 10.0,
            'Smoking': 10.0,
            'Drinking': 10.0,
            'Guests': 8.0,
            'WFH': 9.0,
          },
          computedAt: DateTime.now(),
        ),
      ),
      MatchedProfile(
        profile: Profile(
          id: 'p_priya',
          fullName: 'Priya Iyer',
          age: 24,
          gender: 'female',
          occupation: 'working',
          companyOrCollege: 'Zomato, Frontend Dev',
          city: 'Mumbai',
          locality: 'Andheri West',
          bio: 'Frontend engineer who loves cooking South Indian food on weekends. Clean, organized, pet lover.',
          housingGoal: 'need_room',
          budgetMin: 18000,
          budgetMax: 26000,
          preferredLocalities: const ['Andheri West', 'Lokhandwala', 'Versova'],
          location: const GeoLocation(latitude: 19.1363, longitude: 72.8277),
          moveInDate: DateTime.now().add(const Duration(days: 20)),
          stayDuration: '6 months+',
          profileCompletion: 90,
          isVerified: true,
          photos: const [
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=800&q=80',
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=800&q=80',
          ],
          primaryPhotoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=800&q=80',
          keyTraits: const ['Pet Friendly', 'Veg/Egg', 'Moderate Sleep', 'Occasional Drinks'],
        ),
        matchResult: MatchResult(
          targetUserId: 'p_priya',
          score: 88.0,
          compatibleTopics: const ['Cooking', 'Pets', 'Bills Sharing'],
          watchOutTopics: const ['Noise Tolerance'],
          label: CompatibilityLabel.greatMatch,
          topicScores: const {
            'Cooking': 10.0,
            'Pets': 10.0,
            'Bills Sharing': 9.0,
            'Noise Tolerance': 3.0,
          },
          computedAt: DateTime.now(),
        ),
      ),
      MatchedProfile(
        profile: Profile(
          id: 'p_aarav',
          fullName: 'Aarav Mehta',
          age: 27,
          gender: 'male',
          occupation: 'freelancer',
          companyOrCollege: 'Freelance Filmmaker & Editor',
          city: 'Mumbai',
          locality: 'Versova',
          bio: 'Filmmaker and colorist. Mostly editing with headphones. Chill vibe, love weekend indie movie screenings.',
          housingGoal: 'have_room',
          budgetMin: 22000,
          budgetMax: 32000,
          preferredLocalities: const ['Versova', 'Juhu'],
          location: const GeoLocation(latitude: 19.1319, longitude: 72.8158),
          moveInDate: DateTime.now().add(const Duration(days: 7)),
          stayDuration: '1 year',
          profileCompletion: 85,
          isVerified: false,
          photos: const [
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=800&q=80',
          ],
          primaryPhotoUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=800&q=80',
          keyTraits: const ['Night Owl', 'Social Drinker', 'Movie Buff', 'Have 2BHK Room'],
        ),
        matchResult: MatchResult(
          targetUserId: 'p_aarav',
          score: 72.0,
          compatibleTopics: const ['Creativity', 'Guest Policy'],
          watchOutTopics: const ['Sleep Schedule'],
          label: CompatibilityLabel.goodMatch,
          topicScores: const {
            'Creativity': 10.0,
            'Guest Policy': 8.0,
            'Sleep Schedule': 2.0,
          },
          computedAt: DateTime.now(),
        ),
      ),
      MatchedProfile(
        profile: Profile(
          id: 'p_tanvi',
          fullName: 'Tanvi Kulkarni',
          age: 25,
          gender: 'female',
          occupation: 'working',
          companyOrCollege: 'Deloitte, Consultant',
          city: 'Mumbai',
          locality: 'Powai',
          bio: 'Management consultant near Hiranandani Powai. Very punctual with bills and rent, neat and quiet.',
          housingGoal: 'need_room',
          budgetMin: 25000,
          budgetMax: 35000,
          preferredLocalities: const ['Powai', 'Kanjurmarg West'],
          location: const GeoLocation(latitude: 19.1176, longitude: 72.9060),
          moveInDate: DateTime.now().add(const Duration(days: 10)),
          stayDuration: '1 year',
          profileCompletion: 92,
          isVerified: true,
          photos: const [
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=800&q=80',
          ],
          primaryPhotoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=800&q=80',
          keyTraits: const ['Punctual', 'Cleanliness Geek', 'Quiet Study', 'Non-Smoker'],
        ),
        matchResult: MatchResult(
          targetUserId: 'p_tanvi',
          score: 84.0,
          compatibleTopics: const ['Cleanliness', 'Rent Punctuality', 'Smoking Policy'],
          watchOutTopics: const ['Weekend Socializing'],
          label: CompatibilityLabel.greatMatch,
          topicScores: const {
            'Cleanliness': 10.0,
            'Rent Punctuality': 10.0,
            'Smoking Policy': 10.0,
            'Weekend Socializing': 3.0,
          },
          computedAt: DateTime.now(),
        ),
      ),
    ];
  }
}
