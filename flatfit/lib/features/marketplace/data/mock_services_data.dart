import '../domain/service_partner.dart';

/// Seed data of verified service providers operating in Mumbai.
class MockServicesData {
  static final List<ServicePartner> partners = [
    // 1. Movers
    ServicePartner(
      id: 'partner_movers_1',
      name: 'SwiftMove Logistics & Packers',
      category: ServiceCategory.movers,
      description: 'Zero-damage intra-city home shifting across Mumbai. Dedicated GPS-tracked mini-trucks, bubble wrapping, and disassembling/reassembling assistance.',
      city: 'Mumbai',
      localities: ['Bandra West', 'Andheri West', 'Powai', 'Lower Parel', 'Goregaon', 'Malad'],
      rating: 4.8,
      totalReviews: 248,
      contactPhone: '+91 98201 12345',
      contactEmail: 'support@swiftmove.in',
      commissionPct: 12.0,
      pricingTiers: [
        const ServiceTier(
          id: 'tier_m_1',
          title: 'Single Room / Few Boxes',
          description: 'Tata Ace mini-truck, 2 helpers, bubble wrap & cartons for up to 10 boxes + suitcase.',
          price: 2499,
          priceUnit: 'one-time',
          inclusions: ['Up to 15 km transit', '2 helpers', 'Cartons provided', 'Same-day delivery'],
        ),
        const ServiceTier(
          id: 'tier_m_2',
          title: '1 BHK Complete Move',
          description: 'Bolero maxi-truck, 3 professional packers, multi-layer bubble wrap, bed & AC uninstallation.',
          price: 4999,
          priceUnit: 'one-time',
          inclusions: ['Up to 25 km transit', '3 packers', 'Furniture unmounting', 'Transit insurance cover'],
        ),
      ],
      reviews: [
        PartnerReview(
          id: 'rev_m_1',
          userName: 'Rhea Sen',
          rating: 5.0,
          comment: 'Moved my room from Powai to Bandra in 3 hours flat. Nothing broke and the helpers were polite.',
          createdAt: DateTime.now().subtract(const Duration(days: 4)),
        ),
      ],
    ),

    // 2. Furniture Rental
    ServicePartner(
      id: 'partner_furn_1',
      name: 'NestRentals Furniture & Appliances',
      category: ServiceCategory.furnitureRental,
      description: 'Rent premium beds, ergonomic work desks, refrigerators, washing machines, and smart TVs with free delivery, setup, and annual maintenance.',
      city: 'Mumbai',
      localities: ['All Mumbai Localities'],
      rating: 4.7,
      totalReviews: 412,
      contactPhone: '+91 98190 54321',
      contactEmail: 'care@nestrentals.in',
      commissionPct: 15.0,
      pricingTiers: [
        const ServiceTier(
          id: 'tier_f_1',
          title: 'Queen Bed + Ortho Mattress',
          description: 'Solid Sheesham finish queen size bed with 6-inch orthopedic dual comfort mattress.',
          price: 699,
          priceUnit: 'per month',
          inclusions: ['Free doorstep delivery', 'Free installation', 'Free relocation within Mumbai', 'Zero maintenance deposit'],
        ),
        const ServiceTier(
          id: 'tier_f_2',
          title: 'WFH Executive Study Setup',
          description: 'Spacious study desk with cable organizer and high-back ergonomic mesh chair with lumbar support.',
          price: 449,
          priceUnit: 'per month',
          inclusions: ['Adjustable armrests', 'Free setup', 'Damage protection plan'],
        ),
      ],
      reviews: [
        PartnerReview(
          id: 'rev_f_1',
          userName: 'Kabir Verma',
          rating: 4.5,
          comment: 'Condition of the bed and study chair was like brand new. Saved me 35k on upfront furniture purchase.',
          createdAt: DateTime.now().subtract(const Duration(days: 8)),
        ),
      ],
    ),

    // 3. Deep Cleaning
    ServicePartner(
      id: 'partner_clean_1',
      name: 'SparklePro Deep Cleaners',
      category: ServiceCategory.cleaning,
      description: 'Hospital-grade sanitization, mechanized tile scrubbing, kitchen chimney degreasing, and odor removal before move-in.',
      city: 'Mumbai',
      localities: ['Bandra', 'Khar', 'Santacruz', 'Andheri', 'Juhu', 'Powai', 'Lower Parel'],
      rating: 4.9,
      totalReviews: 530,
      contactPhone: '+91 97690 98765',
      commissionPct: 10.0,
      pricingTiers: [
        const ServiceTier(
          id: 'tier_c_1',
          title: 'Single Bedroom + Attached Bath',
          description: 'Floor scrubbing, wardrobe wipe-down, window & fan cleaning, complete acid-free bathroom descaling.',
          price: 1299,
          priceUnit: 'one-time',
          inclusions: ['Single room + attached washroom', 'Eco-friendly detergents', '2 technicians', '1.5 hours'],
        ),
        const ServiceTier(
          id: 'tier_c_2',
          title: 'Full Flat Deep Cleaning (2 BHK)',
          description: 'Complete apartment deep cleaning: kitchen, 2 bathrooms, balconies, hall, fans, switchboards.',
          price: 3499,
          priceUnit: 'one-time',
          inclusions: ['Kitchen chimney degrease', 'Floor buffing', '3 technicians', '4 hours'],
        ),
      ],
      reviews: [
        PartnerReview(
          id: 'rev_c_1',
          userName: 'Ananya Roy',
          rating: 5.0,
          comment: 'The bathroom was sparkling clean after the previous tenant left it in a mess. Worth every rupee.',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ],
    ),

    // 4. Laundry
    ServicePartner(
      id: 'partner_laundry_1',
      name: 'TidySpin Laundry & Dry Clean',
      category: ServiceCategory.laundry,
      description: 'Scheduled doorstep laundry pickup and 24-hour delivery. Wash, fold, steam press, and sneaker care.',
      city: 'Mumbai',
      localities: ['Bandra West', 'Andheri West', 'Powai', 'Dadar', 'Worli'],
      rating: 4.6,
      totalReviews: 180,
      pricingTiers: [
        const ServiceTier(
          id: 'tier_l_1',
          title: 'Monthly Flatmate Laundry Pass (20 kg)',
          description: '4 scheduled pickups per month. Wash & fold with organic fabric softener + anti-bacterial rinse.',
          price: 1199,
          priceUnit: 'per month',
          inclusions: ['4 pickups (5 kg each)', '24h turnaround', 'Anti-shrink wash', 'Steam press option'],
        ),
      ],
    ),

    // 5. Maid Matching
    ServicePartner(
      id: 'partner_maid_1',
      name: 'Bandra Domestic Connect',
      category: ServiceCategory.maid,
      description: 'Aadhaar & police background-verified house maids for sweeping, mopping, washing dishes, and dusting. Free replacement guarantee.',
      city: 'Mumbai',
      localities: ['Bandra', 'Khar', 'Santacruz', 'Andheri'],
      rating: 4.8,
      totalReviews: 290,
      pricingTiers: [
        const ServiceTier(
          id: 'tier_maid_1',
          title: 'Daily Maid (1 Visit / Day)',
          description: 'Daily sweeping, mopping, dishwashing, and trash disposal for 2 or 3 flatmates.',
          price: 2200,
          priceUnit: 'per month',
          inclusions: ['Police background check', 'Daily 45 min visit', 'Free 7-day replacement', 'Monthly attendance logging'],
        ),
      ],
    ),

    // 6. Cook Matching
    ServicePartner(
      id: 'partner_cook_1',
      name: 'Annapurna Kitchen Masters',
      category: ServiceCategory.cook,
      description: 'Home-style cooks specializing in North Indian, South Indian, Maharashtrian, and Jain healthy food. Trial meal included.',
      city: 'Mumbai',
      localities: ['Bandra West', 'Andheri West', 'Powai', 'Lower Parel'],
      rating: 4.7,
      totalReviews: 320,
      pricingTiers: [
        const ServiceTier(
          id: 'tier_cook_1',
          title: '2 Meals Daily (Lunch + Dinner)',
          description: 'Roti, sabzi, dal, rice + salad prep for flatmates. Weekly customized menu with diet preferences.',
          price: 4500,
          priceUnit: 'per month (split across flatmates)',
          inclusions: ['Trial cooking session', 'Hygienic food handling', 'Low-oil / healthy options', 'Weekend party add-on'],
        ),
      ],
    ),

    // 7. Repairs
    ServicePartner(
      id: 'partner_repair_1',
      name: 'QuickFix Handyman Services',
      category: ServiceCategory.repairs,
      description: 'On-demand certified electricians and plumbers. Fix leaky taps, switchboards, geysers, and curtain rods in 60 minutes.',
      city: 'Mumbai',
      localities: ['All Mumbai Localities'],
      rating: 4.8,
      totalReviews: 610,
      pricingTiers: [
        const ServiceTier(
          id: 'tier_rep_1',
          title: '60-Minute Handyman Visit',
          description: 'Fix up to 3 electrical or plumbing issues in a single visit with warranty.',
          price: 349,
          priceUnit: 'per visit',
          inclusions: ['Verified technician', 'Transparent spare parts cost', '30-day service warranty'],
        ),
      ],
    ),

    // 8. WiFi & Gas
    ServicePartner(
      id: 'partner_wifi_1',
      name: 'ConnectPro Fiber & Piped Gas Setup',
      category: ServiceCategory.wifiSetup,
      description: 'Fast-track broadband installation and Mahanagar Gas (MGL) / Bharat Gas cylinder transfer assistance for tenants.',
      city: 'Mumbai',
      localities: ['Bandra', 'Andheri', 'Powai', 'Goregaon', 'Thane'],
      rating: 4.6,
      totalReviews: 195,
      pricingTiers: [
        const ServiceTier(
          id: 'tier_w_1',
          title: '200 Mbps High-Speed WiFi Setup',
          description: 'Dual-band gigabit router + 3 months unlimited fiber broadband connection.',
          price: 1899,
          priceUnit: 'quarterly plan',
          inclusions: ['Free dual-band router', 'Zero installation fee', 'Guaranteed 24-hr setup', 'No long lock-in'],
        ),
      ],
    ),

    // 9. Renters Insurance
    ServicePartner(
      id: 'partner_ins_1',
      name: 'ShieldNest Renters Protection (Digit)',
      category: ServiceCategory.insurance,
      description: 'Comprehensive tenant insurance covering electronic gadgets, laptops, house fire, burglary, and accidental flat damage.',
      city: 'Mumbai',
      localities: ['Pan-India'],
      rating: 4.9,
      totalReviews: 380,
      pricingTiers: [
        const ServiceTier(
          id: 'tier_ins_1',
          title: 'Flatmate Content Shield (₹2 Lakhs Cover)',
          description: 'Covers laptops, phones, furniture, clothing against theft, fire, water damage, and accidental breakage.',
          price: 199,
          priceUnit: 'per month',
          inclusions: ['₹2,00,000 personal belongings cover', 'Zero paperwork claim via app', 'Tenant liability coverage'],
        ),
      ],
    ),
  ];
}
