import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final userData = args is Map<String, String> ? args : <String, String>{};
    final fullName = userData['fullName'] ?? 'Worker Account';
    final countryCode = userData['countryCode'] ?? '+91';
    final phone = userData['phone'] ?? '9999999999';
    final password = userData['password'] ?? '********';
    final aadhaar = userData['aadhaar'] ?? 'Not provided';
    final aadhaarStatus = userData['aadhaarStatus'] ?? 'Pending';

    String maskedAadhaar;
    if (aadhaar.length == 12) {
      maskedAadhaar = 'XXXX-XXXX-${aadhaar.substring(8)}';
    } else {
      maskedAadhaar = aadhaar;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF1F5F9), Color(0xFFFFF8ED)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A0F172A),
                      blurRadius: 22,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 34,
                      backgroundColor: Color(0xFFCCFBF1),
                      child: Icon(Icons.person, size: 36, color: Color(0xFF0F766E)),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      fullName,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    const Text('Active worker profile', style: TextStyle(color: Color(0xFF64748B))),
                    const SizedBox(height: 18),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.phone_outlined),
                      title: const Text('Phone'),
                      subtitle: Text('$countryCode-$phone'),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.lock_outline),
                      title: const Text('Password'),
                      subtitle: Text(password.isEmpty ? 'Not provided' : password),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.verified_user_outlined),
                      title: const Text('Aadhaar'),
                      subtitle: Text(maskedAadhaar),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.fact_check_outlined),
                      title: const Text('Verification Status'),
                      subtitle: Text(aadhaarStatus),
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
