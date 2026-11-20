import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/service_partner.dart';
import '../../domain/service_booking.dart';
import '../../domain/checkout_service.dart';
import '../providers/marketplace_provider.dart';

class BookingFlowScreen extends ConsumerStatefulWidget {
  final ServicePartner partner;
  final ServiceTier tier;

  const BookingFlowScreen({
    super.key,
    required this.partner,
    required this.tier,
  });

  @override
  ConsumerState<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends ConsumerState<BookingFlowScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  BookingTimeSlot _selectedSlot = BookingTimeSlot.morning;
  final TextEditingController _addressController =
      TextEditingController(text: 'Flat 402, Sea Green Apartments, Bandra West, Mumbai');
  final TextEditingController _phoneController = TextEditingController(text: '+91 98200 99999');
  final TextEditingController _notesController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handlePayment(String method) async {
    setState(() => _isProcessing = true);

    // Calculate pricing breakdown
    final pricing = CheckoutService.calculatePricing(
      basePrice: widget.tier.price,
      platformCommissionPct: widget.partner.commissionPct,
    );

    // Process payment
    await CheckoutService.processMockPayment(
      bookingId: 'bk_${DateTime.now().millisecondsSinceEpoch}',
      amount: pricing.totalPayable,
      paymentMethod: method,
    );

    // Book partner
    final success = await ref.read(marketplaceProvider.notifier).bookPartner(
          partner: widget.partner,
          tier: widget.tier,
          date: _selectedDate,
          slot: _selectedSlot,
          address: _addressController.text,
          phone: _phoneController.text,
          notes: _notesController.text,
        );

    setState(() => _isProcessing = false);

    if (mounted) {
      if (success) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 28),
                SizedBox(width: 10),
                Text('Booking Confirmed!'),
              ],
            ),
            content: Text(
              'Your booking with ${widget.partner.name} has been placed for ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} (${_selectedSlot.label}). A service executive will reach out to confirm arrival.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('View Bookings'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to complete booking. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pricing = CheckoutService.calculatePricing(
      basePrice: widget.tier.price,
      platformCommissionPct: widget.partner.commissionPct,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule & Checkout'),
      ),
      body: _isProcessing
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Color(0xFF0D9488)),
                  SizedBox(height: 16),
                  Text('Processing secure payment...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item summary
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.partner.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text(widget.tier.title, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                          ],
                        ),
                        Text(
                          '₹${widget.tier.price.toInt()}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0D9488)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Date Picker
                  const Text('Select Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );
                      if (picked != null) setState(() => _selectedDate = picked);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                          const Icon(Icons.calendar_today, size: 18, color: Color(0xFF0D9488)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Slot selector
                  const Text('Select Preferred Slot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  ...BookingTimeSlot.values.map((slot) {
                    return RadioListTile<BookingTimeSlot>(
                      value: slot,
                      groupValue: _selectedSlot,
                      title: Text(slot.label, style: const TextStyle(fontSize: 13)),
                      activeColor: const Color(0xFF0D9488),
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedSlot = val);
                      },
                    );
                  }),
                  const SizedBox(height: 16),

                  // Address
                  const Text('Flat Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _addressController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Phone
                  const Text('Contact Phone', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Price breakdown
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Payment Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Item Price', style: TextStyle(fontSize: 13)),
                            Text('₹${pricing.basePrice.toInt()}', style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('GST (18%)', style: TextStyle(fontSize: 13)),
                            Text('₹${pricing.gstAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            Text(
                              '₹${pricing.totalPayable.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0D9488)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Payment triggers
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.qr_code_2),
                      label: const Text('Pay via UPI (GPay / PhonePe / Paytm)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D9488),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => _handlePayment('upi'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.credit_card),
                      label: const Text('Pay via Razorpay / Cards / NetBanking'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF4F46E5),
                        side: const BorderSide(color: Color(0xFF4F46E5)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => _handlePayment('razorpay'),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }
}
