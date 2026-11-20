import 'package:flutter/foundation.dart';

/// Supported states for detailed rental law guidance in India.
enum StateCode {
  maharashtra,
  karnataka,
  delhi,
  other,
}

/// Information model for State Rent Control Acts, Stamp Duty and e-Registration.
@immutable
class StateRentRule {
  final StateCode stateCode;
  final String stateName;
  final String governingAct;
  final String agreementName; // e.g. "Leave & License Agreement" vs "Rent Agreement"
  final String stampDutyFormula;
  final String registrationRequirements;
  final String eStampingPortal;
  final bool isERegistrationMandatory;
  final int standardDurationMonths;
  final double typicalNoticePeriodDays;
  final String policeVerificationProcess;
  final List<String> requiredDocuments;
  final List<String> commonPitfalls;

  const StateRentRule({
    required this.stateCode,
    required this.stateName,
    required this.governingAct,
    required this.agreementName,
    required this.stampDutyFormula,
    required this.registrationRequirements,
    required this.eStampingPortal,
    required this.isERegistrationMandatory,
    this.standardDurationMonths = 11,
    this.typicalNoticePeriodDays = 30,
    required this.policeVerificationProcess,
    required this.requiredDocuments,
    required this.commonPitfalls,
  });

  /// Stamp duty estimation helper for Indian states
  double estimateStampDuty({
    required double monthlyRent,
    required double deposit,
    required int durationMonths,
  }) {
    switch (stateCode) {
      case StateCode.maharashtra:
        // Maharashtra Leave & License: 0.25% of total rent for duration + 10% refundable deposit interest for duration
        final totalRent = monthlyRent * durationMonths;
        final depositInterest = deposit * 0.10 * (durationMonths / 12);
        final baseAmount = totalRent + depositInterest;
        final duty = baseAmount * 0.0025;
        return (duty < 100) ? 100.0 : (duty.roundToDouble());

      case StateCode.karnataka:
        // Karnataka Article 30: 0.5% - 1% of annual rent + deposit depending on duration
        if (durationMonths <= 11) {
          final totalRent = monthlyRent * durationMonths;
          final taxable = totalRent + (deposit * 0.05);
          final duty = taxable * 0.005; // 0.5%
          return (duty < 200) ? 200.0 : (duty.roundToDouble());
        } else {
          final annualRent = monthlyRent * 12;
          return (annualRent * 0.01).roundToDouble();
        }

      case StateCode.delhi:
        // Delhi: 2% of annual rent for lease under 5 years, plus fixed e-stamp minimum (usually ₹100 or ₹500 for notarized)
        if (durationMonths <= 11) {
          // Typically ₹100 or ₹500 non-judicial e-stamp paper if notarized
          return 500.0;
        } else {
          final totalRent = monthlyRent * (durationMonths / 12);
          return (totalRent * 0.02).roundToDouble();
        }

      case StateCode.other:
        return 500.0;
    }
  }

  /// Preset legal guidance for major Indian tech hubs
  static const List<StateRentRule> presets = [
    StateRentRule(
      stateCode: StateCode.maharashtra,
      stateName: 'Maharashtra (Mumbai / Pune)',
      governingAct: 'Maharashtra Rent Control Act, 1999 & Registration Act, 1908',
      agreementName: 'Leave and License Agreement',
      stampDutyFormula: '0.25% of (Total rent for tenure + 10% interest per annum on refundable deposit)',
      registrationRequirements: 'Mandatory online e-Registration with biometric (Aadhaar thumbprint) verification at Sub-Registrar or authorized service provider.',
      eStampingPortal: 'https://efilingigr.maharashtra.gov.in (IGR Maharashtra)',
      isERegistrationMandatory: true,
      standardDurationMonths: 11,
      typicalNoticePeriodDays: 30,
      policeVerificationProcess: 'Mandatory online tenant verification via Mumbai Police / Pune Police Citizen portal (no physical police station visit needed).',
      requiredDocuments: [
        'Aadhaar Card of Licensor (Owner) and Licensees (All Flatmates)',
        'PAN Card of Owner and at least one Licensee',
        'Electricity Bill / Property Tax Receipt of Flat',
        'Two Witnesses with valid Aadhaar numbers',
      ],
      commonPitfalls: [
        'Do not sign a simple ₹100 notary stamp agreement; Section 55 makes registration strictly mandatory in Maharashtra.',
        'Ensure all co-living flatmates are named as co-licensees to protect individual security deposit returns.',
        'Clarify society move-in/move-out charges and who bears them upfront.',
      ],
    ),
    StateRentRule(
      stateCode: StateCode.karnataka,
      stateName: 'Karnataka (Bengaluru)',
      governingAct: 'Karnataka Rent Act, 1999 / Model Tenancy Act principles',
      agreementName: 'Rental & Co-Living Lease Agreement',
      stampDutyFormula: '0.5% to 1.0% on total rent + refundable deposit under Article 30 of Karnataka Stamp Act.',
      registrationRequirements: 'Agreements up to 11 months do not require mandatory sub-registrar registration; notarization on e-stamp paper is standard practice. Agreements of 12+ months must be registered at the Sub-Registrar office.',
      eStampingPortal: 'Stock Holding Corporation of India Ltd (SHCIL) e-Stamp centers / Karnataka Seva Sindhu',
      isERegistrationMandatory: false,
      standardDurationMonths: 11,
      typicalNoticePeriodDays: 30,
      policeVerificationProcess: 'Submit tenant details to local Bangalore City Police jurisdictional station (or via Bengaluru City Police app).',
      requiredDocuments: [
        'Government Photo ID (Aadhaar / Voter ID / Passport) of Owner and Flatmates',
        'Company Offer Letter or Student ID for verification',
        'Recent electricity or water bill of the premises',
        'e-Stamp certificate from authorized SHCIL center',
      ],
      commonPitfalls: [
        'Watch out for 10-month deposit demands in Bangalore. Under the Model Tenancy Act, residential deposits are capped at 2 months rent.',
        'Specify painting deduction clause explicitly: normal wear & tear should not incur automatic 1 month rent deduction.',
        'Mention lock-in period clearly; ensure either party can exit after lock-in with 30 days notice.',
      ],
    ),
    StateRentRule(
      stateCode: StateCode.delhi,
      stateName: 'Delhi-NCR (Delhi / Gurgaon / Noida)',
      governingAct: 'Delhi Rent Control Act / Transfer of Property Act',
      agreementName: 'Residential Rent Agreement',
      stampDutyFormula: '2% of average annual rent for registered deeds; or ₹100 to ₹500 e-stamp for standard 11-month notarized agreements.',
      registrationRequirements: '11-month agreements are notarized on e-stamp paper. 12+ month agreements must be registered at the Sub-Registrar of Assurances.',
      eStampingPortal: 'SHCIL Delhi e-Stamping / Haryana Jamabandi (for Gurgaon)',
      isERegistrationMandatory: false,
      standardDurationMonths: 11,
      typicalNoticePeriodDays: 30,
      policeVerificationProcess: 'Mandatory tenant police verification via Delhi Police portal (delhipolice.gov.in) or Haryana Police HarSamay portal.',
      requiredDocuments: [
        'Aadhaar Card and PAN Card of all flatmates',
        'Proof of ownership (Sale deed or property tax receipt)',
        'Passport-sized photographs of all tenants',
        'Employer ID or college enrollment ID',
      ],
      commonPitfalls: [
        'Ensure electricity sub-meter reading is recorded in the agreement to avoid sharing previous tenant dues.',
        'Clarify power backup (DG) charges and maintenance split between owner and tenants.',
        'Complete police verification within 15 days to avoid notice under Section 188 IPC.',
      ],
    ),
  ];
}
