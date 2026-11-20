import '../domain/subscription.dart';
import '../domain/verified_listing_fee.dart';
import '../domain/concierge_service.dart';

abstract class MonetizationRepository {
  Future<UserSubscription> getUserSubscription(String userId);
  Future<UserSubscription> upgradeToPlus(String userId, BillingPeriod period, String paymentId);
  Future<VerifiedListingPurchase> purchaseVerifiedListingBadge(String listingId, String ownerId, String paymentId);
  Future<ConciergeRequest> submitConciergeRequest(ConciergeRequest request);
  Future<List<ConciergeRequest>> getUserConciergeRequests(String userId);
}

class MonetizationRepositoryImpl implements MonetizationRepository {
  UserSubscription _currentSub = const UserSubscription(
    userId: 'current_user_1',
    tier: SubscriptionTier.free,
    dailyRequestsUsed: 2,
    dailyRequestsLimit: 5,
  );

  final List<ConciergeRequest> _conciergeRequests = [];
  final List<VerifiedListingPurchase> _verifiedPurchases = [];

  @override
  Future<UserSubscription> getUserSubscription(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _currentSub;
  }

  @override
  Future<UserSubscription> upgradeToPlus(String userId, BillingPeriod period, String paymentId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final durationDays = period == BillingPeriod.monthly ? 30 : (period == BillingPeriod.quarterly ? 90 : 365);
    _currentSub = UserSubscription(
      userId: userId,
      tier: SubscriptionTier.plus,
      activePeriod: period,
      startsAt: DateTime.now(),
      expiresAt: DateTime.now().add(Duration(days: durationDays)),
      autoRenew: true,
      dailyRequestsUsed: 0,
      dailyRequestsLimit: 9999,
    );
    return _currentSub;
  }

  @override
  Future<VerifiedListingPurchase> purchaseVerifiedListingBadge(String listingId, String ownerId, String paymentId) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final purchase = VerifiedListingPurchase(
      id: 'vp_${DateTime.now().millisecondsSinceEpoch}',
      listingId: listingId,
      ownerId: ownerId,
      amountPaid: 299.0,
      paymentId: paymentId,
      purchasedAt: DateTime.now(),
    );
    _verifiedPurchases.add(purchase);
    return purchase;
  }

  @override
  Future<ConciergeRequest> submitConciergeRequest(ConciergeRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _conciergeRequests.insert(0, request);
    return request;
  }

  @override
  Future<List<ConciergeRequest>> getUserConciergeRequests(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _conciergeRequests.where((r) => r.userId == userId).toList();
  }
}
