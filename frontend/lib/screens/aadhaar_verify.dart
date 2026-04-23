import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/api_service.dart';

class AadhaarVerifyScreen extends StatelessWidget {
  const AadhaarVerifyScreen({super.key});

  Future<void> _verifyAndContinue(BuildContext context, TextEditingController aadhaarController) async {
    final args = ModalRoute.of(context)?.settings.arguments;
    final userData = args is Map<String, dynamic> ? Map<String, dynamic>.from(args) : <String, dynamic>{};
    final token = userData['token'] as String?;
    final aadhaar = aadhaarController.text.trim();

    if (aadhaar.length != 12) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aadhaar number must be exactly 12 digits.')),
      );
      return;
    }

    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session expired. Please login again.')),
      );
      return;
    }

    try {
      await ApiService.verifyAadhaar(token: token, aadhaarNumber: aadhaar);
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
      );
      return;
    }

    userData['aadhaar'] = aadhaar;
    userData['aadhaarStatus'] = 'Verified';

    if (!context.mounted) {
      return;
    }

    Navigator.pushNamed(context, '/jobs', arguments: userData);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController aadhaarController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Aadhaar Verification')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFECFDF5), Color(0xFFFFF8ED)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A0F172A),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Verify your identity',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This helps employers trust your profile and contact you faster.',
                      style: TextStyle(color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: aadhaarController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(12),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Aadhaar Number',
                        hintText: '12 digits',
                        prefixIcon: Icon(Icons.credit_card_outlined),
                        counterText: '',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _verifyAndContinue(context, aadhaarController),
                      child: const Text('Verify (Mock)'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
