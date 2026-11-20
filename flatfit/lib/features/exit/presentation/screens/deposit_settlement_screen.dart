import 'package:flutter/material.dart';
import '../../domain/models/exit_models.dart';
import '../../domain/services/deposit_calculator.dart';
import '../widgets/settlement_summary_card.dart';

/// Screen calculating the exact security deposit return settlement with transparent deductions.
class DepositSettlementScreen extends StatefulWidget {
  final ExitRequest exitRequest;
  final String currentUserId;

  const DepositSettlementScreen({
    super.key,
    required this.exitRequest,
    required this.currentUserId,
  });

  @override
  State<DepositSettlementScreen> createState() => _DepositSettlementScreenState();
}

class _DepositSettlementScreenState extends State<DepositSettlementScreen> {
  late double _originalDeposit;
  final _rentDeductionController = TextEditingController(text: '0');
  final _utilityDeductionController = TextEditingController(text: '1240'); // electricity/wifi share
  final _damageDeductionController = TextEditingController(text: '1650');
  final _cleaningController = TextEditingController(text: '800'); // deep cleaning share
  final _vpaController = TextEditingController();

  late DepositSettlement _settlement;

  @override
  void initState() {
    super.initState();
    _originalDeposit = widget.exitRequest.securityDepositHeld;
    _vpaController.text = widget.exitRequest.refundVpa ?? 'kabir.mehta@paytm';
    _recalculateSettlement();
  }

  @override
  void dispose() {
    _rentDeductionController.dispose();
    _utilityDeductionController.dispose();
    _damageDeductionController.dispose();
    _cleaningController.dispose();
    _vpaController.dispose();
    super.dispose();
  }

  void _recalculateSettlement() {
    final unpaidRent = double.tryParse(_rentDeductionController.text) ?? 0.0;
    final unpaidBills = double.tryParse(_utilityDeductionController.text) ?? 0.0;
    final damage = double.tryParse(_damageDeductionController.text) ?? 0.0;
    final cleaning = double.tryParse(_cleaningController.text) ?? 0.0;

    final mockDamageItem = DamageInspectionItem(
      id: 'dmg_agreed',
      area: 'Agreed Repairs',
      itemDescription: 'Agreed tenant repairs',
      estimatedRepairCost: damage,
      isNormalWearAndTear: false,
      isDeducted: true,
    );

    final res = DepositCalculator.calculateDepositRefund(
      exitRequestId: widget.exitRequest.id,
      originalDeposit: _originalDeposit,
      unpaidRentDeduction: unpaidRent,
      unpaidUtilityBillsDeduction: unpaidBills,
      inspectionItems: [mockDamageItem],
      deepCleaningFee: cleaning,
      recipientVpa: _vpaController.text.trim(),
    );

    setState(() {
      _settlement = res.settlement;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deposit Return Calculator'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          SettlementSummaryCard(
            settlement: _settlement,
            onRefundViaUpi: () {
              setState(() {
                _settlement = _settlement.copyWith(
                  isRefunded: true,
                  transactionRef: 'UPI_REF_${DateTime.now().millisecondsSinceEpoch}',
                );
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Transferred ₹${_settlement.netRefundAmount.toStringAsFixed(0)} via UPI to ${_settlement.recipientVpa}!'),
                  backgroundColor: Colors.green.shade700,
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text(
              'Adjust Deductions & Dues',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _utilityDeductionController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Unpaid Utility Bills Share (Electricity, Cook, WiFi)',
                        prefixText: '₹ ',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: (_) => _recalculateSettlement(),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _damageDeductionController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Damage Repair Deductions (From Inspection)',
                        prefixText: '₹ ',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: (_) => _recalculateSettlement(),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _cleaningController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Deep Cleaning Share',
                        prefixText: '₹ ',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: (_) => _recalculateSettlement(),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _rentDeductionController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Unpaid Rent Days (if exiting mid-month)',
                        prefixText: '₹ ',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: (_) => _recalculateSettlement(),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _vpaController,
                      decoration: const InputDecoration(
                        labelText: 'Exiting Flatmate UPI ID (VPA)',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: (_) => _recalculateSettlement(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
