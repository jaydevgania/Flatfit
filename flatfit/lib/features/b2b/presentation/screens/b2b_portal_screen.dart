import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/corporate_client.dart';
import '../../domain/college_partner.dart';
import '../../domain/operator_portal.dart';
import '../providers/b2b_provider.dart';

class B2bPortalScreen extends ConsumerStatefulWidget {
  const B2bPortalScreen({super.key});

  @override
  ConsumerState<B2bPortalScreen> createState() => _B2bPortalScreenState();
}

class _B2bPortalScreenState extends ConsumerState<B2bPortalScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showInquiryDialog(String partnerCategory) {
    final orgController = TextEditingController();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Partner with FlatFit ($partnerCategory)'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: orgController,
                decoration: const InputDecoration(labelText: 'Organization / Company Name *'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Contact Person Name *'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Work Email *'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone Number *'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: messageController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Estimated monthly volume / requirements'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D9488),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (orgController.text.trim().isEmpty || emailController.text.trim().isEmpty) {
                return;
              }
              await ref.read(b2bProvider.notifier).sendInquiry(
                    type: partnerCategory.toLowerCase(),
                    orgName: orgController.text,
                    contactName: nameController.text,
                    email: emailController.text,
                    phone: phoneController.text,
                    message: messageController.text,
                  );
              if (ctx.mounted) {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Inquiry sent! Our Enterprise team will contact you within 24 hours.')),
                );
              }
            },
            child: const Text('Submit Inquiry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(b2bProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FlatFit for Business & Institutions'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF0D9488),
          labelColor: const Color(0xFF0D9488),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.business), text: 'Corporate'),
            Tab(icon: Icon(Icons.school), text: 'Colleges'),
            Tab(icon: Icon(Icons.apartment), text: 'PG Operators'),
          ],
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildCorporateTab(context, state.corporateAccounts),
                _buildCollegeTab(context, state.collegeAccounts),
                _buildOperatorTab(context, state.operatorAccounts),
              ],
            ),
    );
  }

  Widget _buildCorporateTab(BuildContext context, List<CorporateAccount> accounts) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF3730A3)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Corporate Relocation Platform',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Streamline employee relocation across Mumbai. Automatically verify corporate email domains, match new hires with trusted colleagues, and administer relocation housing allowances directly.',
                  style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.35),
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  icon: const Icon(Icons.mail_outline, size: 16),
                  label: const Text('Partner with Corporate HR'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4F46E5),
                  ),
                  onPressed: () => _showInquiryDialog('Corporate'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Active Corporate Partners', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ...accounts.map((c) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFEEF2FF),
                    child: Icon(Icons.domain, color: Color(0xFF4F46E5)),
                  ),
                  title: Text(c.companyName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text('${c.employeeCount} relocated employees • ${c.allowedEmailDomains.join(", ")}'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('Verified', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCollegeTab(BuildContext context, List<CollegeAccount> accounts) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'University & Campus Housing Portal',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Solve student hostel overflows safely. Connect freshers with seniors for verified off-campus apartments, safe flatmates, and fraud-free shared accommodations.',
                  style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.35),
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  icon: const Icon(Icons.school, size: 16),
                  label: const Text('Campus Partnership Inquiry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0D9488),
                  ),
                  onPressed: () => _showInquiryDialog('College'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Campus Partnerships', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ...accounts.map((col) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE6FFFA),
                    child: Icon(Icons.school, color: Color(0xFF0D9488)),
                  ),
                  title: Text(col.institutionName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text('${col.studentCount} active students • ${col.allowedDomains.join(", ")}'),
                  trailing: const Icon(Icons.check_circle, color: Color(0xFF0D9488), size: 18),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildOperatorTab(BuildContext context, List<OperatorAccount> accounts) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD97706), Color(0xFFB45309)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PG & Co-Living Operator Portal',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Automate your occupancy. Sync bed inventory in real-time, receive verified tenant applications, and automate monthly rent settlements with minimal churn.',
                  style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.35),
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  icon: const Icon(Icons.apartment, size: 16),
                  label: const Text('Register as PG / Co-Living Partner'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFB45309),
                  ),
                  onPressed: () => _showInquiryDialog('Operator'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Integrated Operator Networks', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ...accounts.map((op) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFEF3C7),
                    child: Icon(Icons.location_city, color: Color(0xFFD97706)),
                  ),
                  title: Text(op.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text('${op.propertiesCount} properties • Coverage: ${op.cities.join(", ")}'),
                  trailing: const Text('API Synced', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11)),
                ),
              )),
        ],
      ),
    );
  }
}
