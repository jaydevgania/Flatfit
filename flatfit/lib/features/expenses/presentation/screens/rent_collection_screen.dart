import 'package:flutter/material.dart';
import '../../domain/models/expense_models.dart';
import '../../domain/services/rent_collector_service.dart';
import '../widgets/upi_pay_button.dart';

/// Screen managing the monthly rent collection flow from flatmates to landlord.
class RentCollectionScreen extends StatefulWidget {
  final String flatId;
  final String currentUserId;
  final String currentUserName;

  const RentCollectionScreen({
    super.key,
    required this.flatId,
    required this.currentUserId,
    this.currentUserName = 'Rohan Verma',
  });

  @override
  State<RentCollectionScreen> createState() => _RentCollectionScreenState();
}

class _RentCollectionScreenState extends State<RentCollectionScreen> {
  final double _totalFlatRent = 45000;
  final String _landlordName = 'Gopal Krishna Iyer';
  final String _landlordVpa = 'gopal.iyer@icici';
  final int _dueDayOfMonth = 5;
  final String _currentMonth = 'November 2026';

  late List<FlatmateRentStatus> _flatmates;

  @override
  void initState() {
    super.initState();
    _flatmates = [
      FlatmateRentStatus(
        userId: widget.currentUserId,
        userName: widget.currentUserName,
        shareAmount: 15000,
        isPaid: true,
        paidAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      const FlatmateRentStatus(
        userId: 'user_ananya',
        userName: 'Ananya Sharma',
        shareAmount: 15000,
        isPaid: true,
      ),
      const FlatmateRentStatus(
        userId: 'user_kabir',
        userName: 'Kabir Mehta',
        shareAmount: 15000,
        isPaid: false,
      ),
    ];
  }

  void _sendReminder(FlatmateRentStatus flatmate) {
    final msg = RentCollectorService.generateRentReminderMessage(
      flatmateName: flatmate.userName,
      shareAmount: flatmate.shareAmount,
      month: _currentMonth,
      dueDayOfMonth: _dueDayOfMonth,
      collectorName: widget.currentUserName,
      collectorVpa: 'rohan.verma@okhdfcbank',
      ownerName: _landlordName,
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('WhatsApp Rent Reminder (${flatmate.userName})'),
        content: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: BorderSide(color: Colors.green.shade200),
            ),
            child: SelectableText(msg, style: const TextStyle(fontSize: 12.5, height: 1.4)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white),
            icon: const Icon(Icons.share, size: 16),
            label: const Text('Copy & Open WhatsApp'),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Copied rent reminder for ${flatmate.userName}!')),
              );
            },
          ),
        ],
      ),
    );
  }

  void _markPaid(FlatmateRentStatus flatmate) {
    setState(() {
      final idx = _flatmates.indexWhere((f) => f.userId == flatmate.userId);
      if (idx != -1) {
        _flatmates[idx] = _flatmates[idx].copyWith(isPaid: true, paidAt: DateTime.now());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = RentCollectorService.calculateProgress(
      totalRent: _totalFlatRent,
      shares: _flatmates,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Rent Collection'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildLandlordCard(),
          const SizedBox(height: 16),
          _buildProgressCard(progress),
          const SizedBox(height: 16),
          const Text(
            'Flatmate Contributions',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ..._flatmates.map((f) => _buildFlatmateTile(f)),
          const SizedBox(height: 24),
          _buildOwnerPayAction(progress),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLandlordCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.indigo.shade50,
                  child: Icon(Icons.account_balance, color: Colors.indigo.shade700),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _landlordName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        'Landlord • UPI: $_landlordVpa',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Due ${_dueDayOfMonth}th',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: Colors.indigo.shade900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Flat Rent ($_currentMonth):',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                ),
                Text(
                  '₹${_totalFlatRent.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(dynamic progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(14),
        border: BorderSide(color: Colors.teal.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Collection Status',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.teal.shade900,
                ),
              ),
              Text(
                '₹${progress.collectedAmount.toStringAsFixed(0)} / ₹${_totalFlatRent.toStringAsFixed(0)} (${(progress.percentage * 100).toStringAsFixed(0)}%)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.teal.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress.percentage,
              minHeight: 10,
              backgroundColor: Colors.teal.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress.isFullyCollected ? Colors.green.shade600 : Colors.teal.shade700,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            progress.isFullyCollected
                ? '🎉 100% Collected! Ready to transfer full rent to landlord.'
                : 'Pending ₹${progress.pendingAmount.toStringAsFixed(0)} from flatmates before landlord due date.',
            style: TextStyle(fontSize: 11.5, color: Colors.teal.shade800),
          ),
        ],
      ),
    );
  }

  Widget _buildFlatmateTile(FlatmateRentStatus flatmate) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: flatmate.isPaid ? Colors.green.shade50 : Colors.red.shade50,
          child: Icon(
            flatmate.isPaid ? Icons.check : Icons.access_time,
            color: flatmate.isPaid ? Colors.green.shade700 : Colors.red.shade700,
            size: 20,
          ),
        ),
        title: Text(flatmate.userName, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          flatmate.isPaid
              ? 'Paid share on ${flatmate.paidAt?.toLocal().toString().split(' ')[0] ?? "time"}'
              : 'Payment pending',
          style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '₹${flatmate.shareAmount.toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(width: 8),
            if (!flatmate.isPaid) ...[
              IconButton(
                icon: const Icon(Icons.send_to_mobile, color: Colors.green, size: 20),
                tooltip: 'Send WhatsApp Reminder',
                onPressed: () => _sendReminder(flatmate),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  minimumSize: const Size(0, 28),
                ),
                onPressed: () => _markPaid(flatmate),
                child: const Text('Mark Paid', style: TextStyle(fontSize: 10.5)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOwnerPayAction(dynamic progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: BorderSide(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Remit Rent to Landlord',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                '₹${_totalFlatRent.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Transfer full co-living rent directly to $_landlordName ($_landlordVpa) via UPI/Netbanking.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: UpiPayButton(
              vpa: _landlordVpa,
              payeeName: _landlordName,
              amount: _totalFlatRent,
              note: 'Flat 402 Palm Breeze Rent - $_currentMonth',
              onPaymentTriggered: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Landlord payment initiated! Receipt saved in FlatFit.')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
