import '../models/agreement_models.dart';

/// Configuration options used by the AgreementBuilder to generate customized house rules.
class HouseRulesConfig {
  final double monthlyRent;
  final double securityDeposit;
  final String quietHoursStart; // e.g. "11:00 PM"
  final String quietHoursEnd; // e.g. "07:30 AM"
  final String guestPolicy; // e.g. "Day guests welcome; overnight guests require 24h prior WhatsApp notice"
  final String chorePolicy; // e.g. "Weekly rotation via FlatFit chore planner; common area dishes cleaned within 2 hours"
  final String billSplitPolicy; // e.g. "Equal split for electricity, cook, maid, WiFi via FlatFit UPI splitter"
  final int noticePeriodDays; // e.g. 30
  final String exitAndDepositPolicy; // e.g. "Full deposit refund within 7 days of exit post inspection minus shared utility dues"
  final String smokingDrinkingPolicy; // e.g. "Smoking strictly restricted to balcony; social drinking permitted"
  final String foodDietPolicy; // e.g. "Non-veg cooking allowed / Veg-only utensils separated"
  final List<String> flatmateNames;

  const HouseRulesConfig({
    required this.monthlyRent,
    required this.securityDeposit,
    this.quietHoursStart = '11:00 PM',
    this.quietHoursEnd = '07:30 AM',
    this.guestPolicy = 'Day visitors permitted; overnight guests require 24 hours prior notice in House Hub chat.',
    this.chorePolicy = 'Rotated weekly via FlatFit Chores. Shared kitchen cleaning and trash disposal are shared equally.',
    this.billSplitPolicy = 'Equal split among all active flatmates for electricity, maid, cook, and high-speed WiFi.',
    this.noticePeriodDays = 30,
    this.exitAndDepositPolicy = '30 days written notice required. Security deposit refunded within 7 working days post room inspection.',
    this.smokingDrinkingPolicy = 'Smoking allowed in designated balcony only. Social drinking permitted responsibly.',
    this.foodDietPolicy = 'Both veg and non-veg cooking permitted. Separate cookware provided if required.',
    this.flatmateNames = const [],
  });
}

/// Domain service to construct structured Flatmate Agreements, trial agreements, and house rule clauses.
class AgreementBuilder {
  /// Generates a standard set of plain-language clauses from configuration.
  static List<AgreementClause> buildPlainLanguageClauses(HouseRulesConfig config) {
    return [
      AgreementClause(
        id: 'clause_rent',
        title: 'Rent & Security Deposit Split',
        description: 'Total monthly flat rent is ₹${config.monthlyRent.toStringAsFixed(0)}. '
            'Refundable security deposit is ₹${config.securityDeposit.toStringAsFixed(0)}. '
            'Each flatmate commits to transfer their portion before the 5th of each calendar month.',
        category: ClauseCategory.rentAndDeposit,
        amount: config.monthlyRent,
        isMandatory: true,
      ),
      AgreementClause(
        id: 'clause_quiet_hours',
        title: 'Quiet Hours & Work-From-Home Etiquette',
        description: 'House quiet hours are observed between ${config.quietHoursStart} and ${config.quietHoursEnd} daily. '
            'Music, TV, and loud phone calls should use headphones during these hours to respect sleep schedules.',
        category: ClauseCategory.quietHours,
        isMandatory: true,
      ),
      AgreementClause(
        id: 'clause_guests',
        title: 'Visitors & Overnight Guests',
        description: config.guestPolicy,
        category: ClauseCategory.guestsAndVisitors,
        isMandatory: true,
      ),
      AgreementClause(
        id: 'clause_chores',
        title: 'Daily Chores & Common Cleanliness',
        description: config.chorePolicy,
        category: ClauseCategory.choresAndCleanliness,
        isMandatory: true,
      ),
      AgreementClause(
        id: 'clause_bills',
        title: 'Utility Bills & Domestic Staff Split',
        description: config.billSplitPolicy,
        category: ClauseCategory.utilityBills,
        isMandatory: true,
      ),
      AgreementClause(
        id: 'clause_notice',
        title: 'Notice Period & Early Exit',
        description: 'A minimum of ${config.noticePeriodDays} days advance notice must be submitted in the app before vacating. '
            'Exiting flatmate assists in posting the vacancy on FlatFit to find a compatible replacement.',
        category: ClauseCategory.noticePeriod,
        isMandatory: true,
      ),
      AgreementClause(
        id: 'clause_deposit_return',
        title: 'Exit Inspection & Deposit Refund',
        description: config.exitAndDepositPolicy,
        category: ClauseCategory.exitAndDepositReturn,
        isMandatory: true,
      ),
      AgreementClause(
        id: 'clause_habits',
        title: 'Smoking & Alcohol Etiquette',
        description: config.smokingDrinkingPolicy,
        category: ClauseCategory.petsAndSmoking,
        isMandatory: false,
      ),
      AgreementClause(
        id: 'clause_food',
        title: 'Kitchen & Dietary Preferences',
        description: config.foodDietPolicy,
        category: ClauseCategory.foodAndKitchen,
        isMandatory: false,
      ),
      const AgreementClause(
        id: 'clause_dispute',
        title: 'Constructive Dispute Resolution',
        description: 'In the event of a disagreement, flatmates agree to hold a friendly 15-minute in-person discussion '
            'or use the FlatFit AI Conflict Mediator before escalating or making unilateral decisions.',
        category: ClauseCategory.disputeResolution,
        isMandatory: false,
      ),
    ];
  }

  /// Builds a full co-living agreement.
  static FlatmateAgreement createAgreement({
    required String id,
    String? flatId,
    required String title,
    required HouseRulesConfig config,
    required DateTime startDate,
    required DateTime endDate,
    required String creatorUserId,
    required List<String> memberUserIds,
  }) {
    final clauses = buildPlainLanguageClauses(config);

    return FlatmateAgreement(
      id: id,
      flatId: flatId,
      title: title,
      description: 'Mutual co-living compact between flatmates setting clear expectations for harmony and transparency.',
      agreementType: AgreementType.fullStay,
      clauses: clauses,
      rentAmount: config.monthlyRent,
      depositAmount: config.securityDeposit,
      noticePeriodDays: config.noticePeriodDays,
      startDate: startDate,
      endDate: endDate,
      status: AgreementStatus.draft,
      createdBy: creatorUserId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      memberUserIds: memberUserIds,
    );
  }

  /// Sets up a 7-day Trial Week or 1-day Trial agreement.
  /// Trial agreements help potential flatmates experience living together
  /// before signing an 11-month lease.
  static FlatmateAgreement createTrialAgreement({
    required String id,
    String? flatId,
    required AgreementType trialType, // trialWeek or dayTrial
    required double perDayRent,
    required double securityHoldDeposit,
    required DateTime startDate,
    required String creatorUserId,
    required List<String> memberUserIds,
    required String flatAddress,
  }) {
    final isWeek = trialType == AgreementType.trialWeek;
    final durationDays = isWeek ? 7 : 1;
    final endDate = startDate.add(Duration(days: durationDays));
    final totalRent = perDayRent * durationDays;

    final clauses = [
      AgreementClause(
        id: 'trial_clause_overview',
        title: isWeek ? '7-Day Flatmate Compatibility Trial' : '1-Day Day-Long Trial Stay',
        description: 'The prospective flatmate will stay at $flatAddress for $durationDays day(s) from '
            '${startDate.toIso8601String().split('T').first} to ${endDate.toIso8601String().split('T').first} '
            'to assess mutual lifestyle compatibility, work routines, and house harmony.',
        category: ClauseCategory.rentAndDeposit,
        amount: totalRent,
        isMandatory: true,
      ),
      AgreementClause(
        id: 'trial_clause_financials',
        title: 'Trial Contribution & Security Hold',
        description: 'Pro-rata stay contribution of ₹${totalRent.toStringAsFixed(0)} plus a refundable security hold of '
            '₹${securityHoldDeposit.toStringAsFixed(0)} shall be paid prior to check-in.',
        category: ClauseCategory.rentAndDeposit,
        amount: securityHoldDeposit,
        isMandatory: true,
      ),
      const AgreementClause(
        id: 'trial_clause_house_rules',
        title: 'Trial House Conduct',
        description: 'Trial guest agrees to adhere to house quiet hours, respectful kitchen usage, and no unauthorized overnight visitors during the trial period.',
        category: ClauseCategory.quietHours,
        isMandatory: true,
      ),
      AgreementClause(
        id: 'trial_clause_exit',
        title: 'Post-Trial Decision & Deposit Return',
        description: 'At the end of the $durationDays-day period, if either party decides not to proceed, the security hold of '
            '₹${securityHoldDeposit.toStringAsFixed(0)} is refunded in full within 24 hours via UPI without any lock-in penalty.',
        category: ClauseCategory.exitAndDepositReturn,
        isMandatory: true,
      ),
    ];

    return FlatmateAgreement(
      id: id,
      flatId: flatId,
      title: isWeek ? 'FlatFit 7-Day Trial Week Agreement' : 'FlatFit 1-Day Trial Stay Agreement',
      description: 'Low-risk trial stay agreement to verify real-life habits and compatibility before signing an 11-month lease.',
      agreementType: trialType,
      clauses: clauses,
      rentAmount: totalRent,
      depositAmount: securityHoldDeposit,
      noticePeriodDays: 1,
      startDate: startDate,
      endDate: endDate,
      status: AgreementStatus.draft,
      createdBy: creatorUserId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      memberUserIds: memberUserIds,
    );
  }
}
