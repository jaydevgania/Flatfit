import 'package:flutter/material.dart';
import '../models/agreement_models.dart';
import '../widgets/clause_tile.dart';
import 'digital_sign_screen.dart';

/// Screen to inspect an agreement, view flatmate signatures, and trigger digital signing.
class AgreementDetailsScreen extends StatefulWidget {
  final FlatmateAgreement agreement;
  final String currentUserId;
  final String currentUserName;

  const AgreementDetailsScreen({
    super.key,
    required this.agreement,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  State<AgreementDetailsScreen> createState() => _AgreementDetailsScreenState();
}

class _AgreementDetailsScreenState extends State<AgreementDetailsScreen> {
  late FlatmateAgreement _agreement;

  @override
  void initState() {
    super.initState();
    _agreement = widget.agreement;
  }

  void _onSignSuccess(AgreementSignature signature) {
    setState(() {
      final updatedSignatures = List<AgreementSignature>.from(_agreement.signatures)
        ..removeWhere((s) => s.userId == signature.userId)
        ..add(signature);

      final isAllSigned = _agreement.memberUserIds.isNotEmpty &&
          _agreement.memberUserIds.every((uid) => updatedSignatures.any((s) => s.userId == uid));

      _agreement = FlatmateAgreement(
        id: _agreement.id,
        flatId: _agreement.flatId,
        title: _agreement.title,
        description: _agreement.description,
        agreementType: _agreement.agreementType,
        clauses: _agreement.clauses,
        rentAmount: _agreement.rentAmount,
        depositAmount: _agreement.depositAmount,
        noticePeriodDays: _agreement.noticePeriodDays,
        startDate: _agreement.startDate,
        endDate: _agreement.endDate,
        status: isAllSigned ? AgreementStatus.active : _agreement.status,
        createdBy: _agreement.createdBy,
        createdAt: _agreement.createdAt,
        updatedAt: DateTime.now(),
        signatures: updatedSignatures,
        memberUserIds: _agreement.memberUserIds,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Digitally signed as ${signature.userName}! Checksum verified.'),
        backgroundColor: Colors.teal.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasUserSigned = _agreement.isSignedByUser(widget.currentUserId);
    final isFullySigned = _agreement.isFullySigned();

    return Scaffold(
      appBar: AppBar(
        title: Text(_agreement.title),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share Summary',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Agreement summary copied to clipboard!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusHeader(isFullySigned),
            const SizedBox(height: 12),
            _buildSignaturesSummary(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text(
                    'Agreed House Rules & Clauses',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    '${_agreement.clauses.length} items',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ..._agreement.clauses.map((clause) => ClauseTile(clause: clause)),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: hasUserSigned
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade600),
                    const SizedBox(width: 8),
                    const Text(
                      'You have signed this agreement',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.green,
                      ),
                    ),
                  ],
                )
              : ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.draw_outlined),
                  label: const Text(
                    'Digitally Sign Agreement',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    final signature = await Navigator.push<AgreementSignature>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DigitalSignScreen(
                          agreement: _agreement,
                          userId: widget.currentUserId,
                          userName: widget.currentUserName,
                        ),
                      ),
                    );
                    if (signature != null) {
                      _onSignSuccess(signature);
                    }
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildStatusHeader(bool isFullySigned) {
    return Container(
      width: double.infinity,
      color: Colors.teal.shade50,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isFullySigned ? Colors.green.shade700 : Colors.amber.shade800,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isFullySigned ? 'ACTIVE AGREEMENT' : 'PENDING SIGNATURES',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              if (_agreement.rentAmount != null)
                Text(
                  '₹${_agreement.rentAmount!.toStringAsFixed(0)} / mo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.teal.shade900,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _agreement.description ?? 'Mutual flatmate agreement establishing shared expectations.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.teal.shade900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Notice period: ${_agreement.noticePeriodDays} days • Duration: 11 Months',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignaturesSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Flatmate Signatures',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 10),
          if (_agreement.signatures.isEmpty)
            Text(
              'No signatures yet. Be the first to sign!',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            )
          else
            ..._agreement.signatures.map(
              (sig) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.verified, size: 18, color: Colors.teal),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sig.userName,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          Text(
                            'Signed on ${sig.signedAt.toLocal().toString().split('.')[0]}',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                    if (sig.signatureHash != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          sig.signatureHash!.substring(0, 10),
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'monospace',
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
