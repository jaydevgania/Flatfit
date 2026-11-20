import 'package:intl/intl.dart';

/// Formatting utilities for Indian currency, dates, and geographic distances.
class Formatters {
  const Formatters._();

  static final NumberFormat _inrCurrencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final DateFormat _shortDateFormat = DateFormat('dd MMM yyyy');
  static final DateFormat _monthYearFormat = DateFormat('MMM yyyy');
  static final DateFormat _timeFormat = DateFormat('hh:mm a');

  /// Formats amount in Indian Rupee format, e.g. ₹15,000 or ₹1.2 L
  static String formatINR(num amount, {bool compact = false}) {
    if (!compact || amount < 100000) {
      return _inrCurrencyFormat.format(amount);
    }

    if (amount >= 10000000) {
      final cr = amount / 10000000;
      return '₹${cr.toStringAsFixed(cr.truncateToDouble() == cr ? 0 : 1)} Cr';
    }

    final lakh = amount / 100000;
    return '₹${lakh.toStringAsFixed(lakh.truncateToDouble() == lakh ? 0 : 1)} L';
  }

  /// Formats date to '15 Aug 2024'
  static String formatDate(DateTime? date) {
    if (date == null) return '';
    return _shortDateFormat.format(date);
  }

  /// Formats date to 'Aug 2024'
  static String formatMonthYear(DateTime? date) {
    if (date == null) return '';
    return _monthYearFormat.format(date);
  }

  /// Formats time to '04:30 PM'
  static String formatTime(DateTime? date) {
    if (date == null) return '';
    return _timeFormat.format(date);
  }

  /// Formats relative distance in km/meters
  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m away';
    }
    final km = meters / 1000;
    return '${km.toStringAsFixed(1)} km away';
  }

  /// Formats relative time (e.g. 5m ago, 2h ago, Yesterday)
  static String timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return _shortDateFormat.format(dateTime);
    }
  }
}
