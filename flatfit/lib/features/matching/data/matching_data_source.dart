import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/match_outcome.dart';
import '../domain/match_result.dart';
import '../domain/profile.dart';
import '../domain/user_answer.dart';

/// Data source handling low-level Supabase queries for matching.
class MatchingDataSource {
  final SupabaseClient _client;

  MatchingDataSource(this._client);

  /// Fetches precomputed matches for a given user from `precomputed_matches`
  /// with profile details of the matched flatmate.
  Future<List<Map<String, dynamic>>> getPrecomputedMatches({
    required String currentUserId,
    int limit = 50,
    int offset = 0,
    double minScore = 0.0,
  }) async {
    final response = await _client
        .from('precomputed_matches')
        .select('''
          id,
          user_a,
          user_b,
          score,
          compatible_topics,
          watch_out_topics,
          computed_at
        ''')
        .or('user_a.eq.$currentUserId,user_b.eq.$currentUserId')
        .gte('score', minScore.toInt())
        .order('score', ascending: false)
        .range(offset, offset + limit - 1);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Fetches single match record between two specific users.
  Future<Map<String, dynamic>?> getMatchBetween({
    required String userA,
    required String userB,
  }) async {
    // Canonical ordering: user_a < user_b
    final first = userA.compareTo(userB) < 0 ? userA : userB;
    final second = userA.compareTo(userB) < 0 ? userB : userA;

    final response = await _client
        .from('precomputed_matches')
        .select()
        .eq('user_a', first)
        .eq('user_b', second)
        .maybeSingle();

    return response;
  }

  /// Upserts precomputed match result into `precomputed_matches`.
  Future<void> upsertMatchRecord({
    required String userA,
    required String userB,
    required int score,
    required List<String> compatibleTopics,
    required List<String> watchOutTopics,
  }) async {
    final first = userA.compareTo(userB) < 0 ? userA : userB;
    final second = userA.compareTo(userB) < 0 ? userB : userA;

    await _client.from('precomputed_matches').upsert(
      {
        'user_a': first,
        'user_b': second,
        'score': score,
        'compatible_topics': compatibleTopics,
        'watch_out_topics': watchOutTopics,
        'computed_at': DateTime.now().toIso8601String(),
      },
      onConflict: 'user_a,user_b',
    );
  }

  /// Logs match outcome progression into `match_outcomes` table for ML feedback.
  Future<void> recordMatchOutcome({
    required String userA,
    required String userB,
    required MatchOutcome outcome,
    Map<String, dynamic>? metadata,
  }) async {
    final first = userA.compareTo(userB) < 0 ? userA : userB;
    final second = userA.compareTo(userB) < 0 ? userB : userA;

    await _client.from('match_outcomes').insert({
      'user_a': first,
      'user_b': second,
      'outcome': outcome.name,
      'metadata': metadata ?? {},
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// Fetches user questionnaire answers for dynamic on-the-fly score computation.
  Future<List<UserAnswer>> getUserAnswers(String userId) async {
    final response = await _client
        .from('user_answers')
        .select('''
          id,
          user_id,
          question_id,
          answer,
          importance,
          questions(topic)
        ''')
        .eq('user_id', userId);

    final list = response as List<dynamic>;
    return list.map((item) {
      final map = Map<String, dynamic>.from(item as Map);
      String topic = '';
      if (map['questions'] != null && map['questions'] is Map) {
        topic = (map['questions'] as Map)['topic']?.toString() ?? '';
      }
      return UserAnswer(
        id: map['id']?.toString() ?? '',
        userId: map['user_id']?.toString() ?? '',
        questionId: map['question_id']?.toString() ?? '',
        topic: topic,
        answer: map['answer']?.toString() ?? '',
        importance: AnswerImportance.fromString(
          map['importance']?.toString() ?? 'nice_to_have',
        ),
      );
    }).toList();
  }

  /// Fetches a profile by ID along with primary photo.
  Future<Profile?> getProfileById(String profileId) async {
    final response = await _client
        .from('profiles')
        .select('''
          *,
          profile_photos(url, is_primary, position)
        ''')
        .eq('id', profileId)
        .maybeSingle();

    if (response == null) return null;

    final map = Map<String, dynamic>.from(response);
    final photosList = <String>[];
    String? primaryPhoto;

    if (map['profile_photos'] != null && map['profile_photos'] is List) {
      final photos = List<Map<String, dynamic>>.from(map['profile_photos'] as List);
      photos.sort((a, b) => ((a['position'] as int?) ?? 1).compareTo((b['position'] as int?) ?? 1));
      for (final p in photos) {
        final url = p['url']?.toString();
        if (url != null && url.isNotEmpty) {
          photosList.add(url);
          if (p['is_primary'] == true && primaryPhoto == null) {
            primaryPhoto = url;
          }
        }
      }
    }
    map['photos'] = photosList;
    if (primaryPhoto != null) {
      map['primary_photo_url'] = primaryPhoto;
    }

    return Profile.fromJson(map);
  }
}
