import 'dart:async';
import '../domain/service_partner.dart';
import '../domain/service_bundle.dart';
import '../domain/service_booking.dart';
import 'mock_services_data.dart';

abstract class MarketplaceRepository {
  Future<List<ServicePartner>> getPartners({ServiceCategory? category, String? query});
  Future<ServicePartner?> getPartnerById(String id);
  Future<List<ServiceBundle>> getBundles();
  Future<List<ServiceBooking>> getUserBookings(String userId);
  Future<ServiceBooking> createBooking(ServiceBooking booking);
}

class MarketplaceRepositoryImpl implements MarketplaceRepository {
  final List<ServiceBooking> _activeBookings = [];

  @override
  Future<List<ServicePartner>> getPartners({ServiceCategory? category, String? query}) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    var list = MockServicesData.partners;

    if (category != null) {
      list = list.where((p) => p.category == category).toList();
    }

    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      list = list.where((p) {
        return p.name.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q) ||
            p.localities.any((loc) => loc.toLowerCase().contains(q));
      }).toList();
    }

    return list;
  }

  @override
  Future<ServicePartner?> getPartnerById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    try {
      return MockServicesData.partners.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<ServiceBundle>> getBundles() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return DefaultServiceBundles.all;
  }

  @override
  Future<List<ServiceBooking>> getUserBookings(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _activeBookings.where((b) => b.userId == userId).toList();
  }

  @override
  Future<ServiceBooking> createBooking(ServiceBooking booking) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _activeBookings.insert(0, booking);
    return booking;
  }
}
