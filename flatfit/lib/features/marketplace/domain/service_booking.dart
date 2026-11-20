import 'service_partner.dart';

/// Lifecycle statuses for a service order.
enum BookingStatus {
  pending,
  confirmed,
  scheduled,
  completed,
  cancelled,
}

/// Preferred time window for service fulfillment.
enum BookingTimeSlot {
  morning, // 09:00 AM - 12:00 PM
  afternoon, // 01:00 PM - 04:00 PM
  evening, // 05:00 PM - 08:00 PM
}

extension BookingTimeSlotExtension on BookingTimeSlot {
  String get label {
    switch (this) {
      case BookingTimeSlot.morning:
        return 'Morning (9:00 AM - 12:00 PM)';
      case BookingTimeSlot.afternoon:
        return 'Afternoon (1:00 PM - 4:00 PM)';
      case BookingTimeSlot.evening:
        return 'Evening (5:00 PM - 8:00 PM)';
    }
  }
}

/// Model capturing a customer's booking of a vetted service partner.
class ServiceBooking {
  final String id;
  final String partnerId;
  final String partnerName;
  final ServiceCategory category;
  final String userId;
  final String? flatId;
  final DateTime scheduledDate;
  final BookingTimeSlot slot;
  final String serviceAddress;
  final String contactPhone;
  final double baseAmount;
  final double discountAmount;
  final double gstAmount; // 18% GST standard in India
  final double totalAmount;
  final double flatfitCommissionAmount; // FlatFit take-rate
  final String? notes;
  final BookingStatus status;
  final String? paymentRef;
  final DateTime bookedAt;
  final DateTime? completedAt;

  const ServiceBooking({
    required this.id,
    required this.partnerId,
    required this.partnerName,
    required this.category,
    required this.userId,
    this.flatId,
    required this.scheduledDate,
    required this.slot,
    required this.serviceAddress,
    required this.contactPhone,
    required this.baseAmount,
    this.discountAmount = 0.0,
    required this.gstAmount,
    required this.totalAmount,
    required this.flatfitCommissionAmount,
    this.notes,
    this.status = BookingStatus.pending,
    this.paymentRef,
    required this.bookedAt,
    this.completedAt,
  });

  /// Partner payout after deducting platform commission.
  double get partnerNetPayout => baseAmount - flatfitCommissionAmount;
}
