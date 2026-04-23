import 'package:flutter/material.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  static const List<Map<String, String>> _payments = [
    {
      'job': 'Mason - Sector 62 Site',
      'date': '15 Apr 2026',
      'amount': 'Rs. 700',
      'status': 'Paid',
    },
    {
      'job': 'Painter - Dwarka Apartment',
      'date': '11 Apr 2026',
      'amount': 'Rs. 600',
      'status': 'Paid',
    },
    {
      'job': 'Welder - Industrial Zone',
      'date': '08 Apr 2026',
      'amount': 'Rs. 850',
      'status': 'Paid',
    },
    {
      'job': 'Tiles Installer - Metro Project',
      'date': '04 Apr 2026',
      'amount': 'Rs. 800',
      'status': 'Pending',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment History Details')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF1E8), Color(0xFFFFF8ED)],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          itemCount: _payments.length,
          itemBuilder: (context, index) {
            final payment = _payments[index];
            final isPaid = payment['status'] == 'Paid';
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x140F172A),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    payment['job'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Date: ${payment['date']}  •  Amount: ${payment['amount']}',
                    style: const TextStyle(color: Color(0xFF475569)),
                  ),
                  const SizedBox(height: 10),
                  Chip(
                    backgroundColor: isPaid ? const Color(0xFFDCFCE7) : const Color(0xFFFFEDD5),
                    label: Text(
                      payment['status'] ?? '',
                      style: TextStyle(
                        color: isPaid ? const Color(0xFF166534) : const Color(0xFF9A3412),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
