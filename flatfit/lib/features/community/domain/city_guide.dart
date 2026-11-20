/// Locality guide entity for Indian metro cities.
class LocalityGuide {
  final String id;
  final String city;
  final String localityName;
  final String tagLine;
  final String description;
  final String vibe; // 'Lively & Cosmopolitan', 'Tech & Startup Hub', 'Quiet & Green'
  final String budgetRangeSummary; // e.g. "₹25,000 - ₹45,000 / room"
  final Map<String, String> rentBreakdown; // 1RK, 1BHK, Master Bedroom, Shared Room
  final CommuteDetails commute;
  final int safetyRating; // 1 - 5
  final int womenSafetyIndex; // 1 - 5
  final List<String> topHighlights;
  final List<String> popularHangouts;
  final String? coverImageUrl;

  const LocalityGuide({
    required this.id,
    this.city = 'Mumbai',
    required this.localityName,
    required this.tagLine,
    required this.description,
    required this.vibe,
    required this.budgetRangeSummary,
    required this.rentBreakdown,
    required this.commute,
    required this.safetyRating,
    required this.womenSafetyIndex,
    required this.topHighlights,
    required this.popularHangouts,
    this.coverImageUrl,
  });
}

/// Commute details for a locality.
class CommuteDetails {
  final String localTrainStation;
  final String metroConnectivity;
  final String airportDistance;
  final String bkccDistance;
  final String peakTrafficNotes;

  const CommuteDetails({
    required this.localTrainStation,
    required this.metroConnectivity,
    required this.airportDistance,
    required this.bkccDistance,
    required this.peakTrafficNotes,
  });
}

/// Curated Mumbai Locality Guides.
class MumbaiLocalityGuides {
  static const List<LocalityGuide> all = [
    LocalityGuide(
      id: 'guide_bandra_west',
      localityName: 'Bandra West & Pali Hill',
      tagLine: 'The Queen of Suburbs: Artisanal cafes, sea breeze, and artistic buzz',
      description: 'Bandra West is Mumbai\'s cultural epicenter. Tree-lined avenues, Portuguese-style cottages, boutique fitness studios, and sea-facing promenades make it the #1 aspirational locality for creative professionals, startup founders, and expats.',
      vibe: 'Chic, Trendy & Cosmopolitan',
      budgetRangeSummary: '₹35,000 – ₹65,000 / room',
      rentBreakdown: {
        'Private Room (in 2/3 BHK)': '₹38,000 - ₹55,000',
        'Master Bedroom': '₹48,000 - ₹70,000',
        '1 BHK Apartment': '₹55,000 - ₹85,000',
        'Shared Room': '₹22,000 - ₹30,000',
      },
      commute: CommuteDetails(
        localTrainStation: 'Bandra Station (Western & Harbour Lines, 7 min)',
        metroConnectivity: 'Metro Line 3 (Aqua Line) connects to BKC in 6 minutes',
        airportDistance: '25 minutes via Western Express Highway',
        bkccDistance: '15 minutes via BKC Connector flyover',
        peakTrafficNotes: 'Heavy traffic on Linking Road & SV Road during 6 - 8:30 PM.',
      ),
      safetyRating: 5,
      womenSafetyIndex: 5,
      topHighlights: [
        'Bandstand & Carter Road seaside promenades',
        'Walking distance to 100+ high-end cafes & bistros',
        'Vibrant nightlife & live music venues',
      ],
      popularHangouts: ['Subko Coffee Roasters', 'Candies Cafe', 'Doolally Taproom', 'Pali Village Cafe'],
    ),

    LocalityGuide(
      id: 'guide_andheri_west',
      localityName: 'Andheri West (Lokhandwala & Versova)',
      tagLine: 'The media capital: Lively streets, versatile dining, and metro convenience',
      description: 'Andheri West is an energetic residential haven for media, entertainment, tech, and marketing folk. Lokhandwala Market offers unmatched street shopping, while Versova provides a laid-back beach village feel with open-air cafes.',
      vibe: 'Vibrant, Fast-Paced & Youthful',
      budgetRangeSummary: '₹20,000 – ₹38,000 / room',
      rentBreakdown: {
        'Private Room (in 2/3 BHK)': '₹22,000 - ₹35,000',
        'Master Bedroom': '₹30,000 - ₹45,000',
        '1 BHK Apartment': '₹35,000 - ₹50,000',
        'Shared Room': '₹14,000 - ₹20,000',
      },
      commute: CommuteDetails(
        localTrainStation: 'Andheri Railway Station (Major hub on Western Line)',
        metroConnectivity: 'Metro Line 1 (Versova-Ghatkopar) + Metro Line 2A',
        airportDistance: '20 minutes to Domestic Terminal',
        bkccDistance: '35 minutes via Western Express Highway',
        peakTrafficNotes: 'Bottlenecks near Infinity Mall and Lokhandwala circle during rush hour.',
      ),
      safetyRating: 4,
      womenSafetyIndex: 5,
      topHighlights: [
        'Versova Beach & Rock Beach sunset walks',
        'Superb East-West connectivity via Metro Line 1',
        '24/7 food delivery and bustling night spots',
      ],
      popularHangouts: ['Versova Social', 'Leaping Windows Comic Cafe', 'Lokhandwala Market', 'Joey\'s Pizza'],
    ),

    LocalityGuide(
      id: 'guide_powai',
      localityName: 'Powai (Hiranandani Gardens)',
      tagLine: 'Neoclassical architecture, lake views, and premier IIT/tech hub',
      description: 'Powai feels like a modern European enclave nestled around Powai Lake. Home to IIT Bombay and prominent MNCs (Nomura, L&T, Deloitte), Hiranandani provides wide tree-lined boulevards, planned pedestrian plazas, and gated high-rises.',
      vibe: 'Modern, Planned & Tech-Centric',
      budgetRangeSummary: '₹22,000 – ₹42,000 / room',
      rentBreakdown: {
        'Private Room (in 2/3 BHK)': '₹24,000 - ₹38,000',
        'Master Bedroom': '₹32,000 - ₹48,000',
        '1 BHK Apartment': '₹36,000 - ₹52,000',
        'Shared Room': '₹15,000 - ₹22,000',
      },
      commute: CommuteDetails(
        localTrainStation: 'Kanjurmarg Station (Central Line, 10 min)',
        metroConnectivity: 'Metro Line 6 (Swami Samarth Nagar – Vikhroli underway)',
        airportDistance: '20 minutes via Saki Vihar Road',
        bkccDistance: '30 minutes via SCLR / Eastern Express Highway',
        peakTrafficNotes: 'JVLR experiences heavy morning peak eastbound congestion.',
      ),
      safetyRating: 5,
      womenSafetyIndex: 5,
      topHighlights: [
        'Gated township security and pedestrian-friendly parks',
        'Powai Lake promenade and cycling tracks',
        'High density of young techies, analysts, and founders',
      ],
      popularHangouts: ['Breeze Lounge', 'Haiko Mall', 'The Finch Brewery', 'Aroma\'s Cafe'],
    ),

    LocalityGuide(
      id: 'guide_lower_parel',
      localityName: 'Lower Parel & Worli',
      tagLine: 'Mill lands reborn: Luxury high-rises and premier corporate headquarters',
      description: 'Lower Parel is South-Central Mumbai\'s premier commercial district. With corporate parks like Peninsula Corporate Park, One World Center, and High Street Phoenix mall, you can literally walk from your flat to your corporate desk.',
      vibe: 'Corporate, Upscale & High-Rise',
      budgetRangeSummary: '₹30,000 – ₹55,000 / room',
      rentBreakdown: {
        'Private Room (in 2/3 BHK)': '₹32,000 - ₹50,000',
        'Master Bedroom': '₹45,000 - ₹65,000',
        '1 BHK Apartment': '₹50,000 - ₹75,000',
        'Shared Room': '₹18,000 - ₹26,000',
      },
      commute: CommuteDetails(
        localTrainStation: 'Lower Parel (Western) & Currey Road (Central)',
        metroConnectivity: 'Metro Line 3 (Worli & Science Centre stations)',
        airportDistance: '40 minutes via Sea Link',
        bkccDistance: '20 minutes via Bandra-Worli Sea Link',
        peakTrafficNotes: 'Senapati Bapat Marg can crawl between 6:30 and 8:30 PM.',
      ),
      safetyRating: 5,
      womenSafetyIndex: 5,
      topHighlights: [
        'Walking distance to top corporate headquarters & banks',
        'Phoenix Palladium mall and luxury dining',
        'Spectacular skyline and sea views from high-rise towers',
      ],
      popularHangouts: ['High Street Phoenix', 'Kamala Mills Compound', 'Toit Brewery', 'The Bombay Canteen'],
    ),
  ];
}
