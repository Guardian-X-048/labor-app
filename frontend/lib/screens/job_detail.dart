import 'package:flutter/material.dart';

class JobDetailScreen extends StatelessWidget {
  const JobDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final job = args is Map<String, String> ? args : <String, String>{};

    return Scaffold(
      appBar: AppBar(title: const Text('Job Details')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEFF6FF), Color(0xFFFFF8ED)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 540),
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'Verified Listing',
                        style: TextStyle(
                          color: Color(0xFF0C4A6E),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      job['title'] ?? 'Unknown Role',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.2,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Location: ${job['location'] ?? 'N/A'}',
                      style: const TextStyle(fontSize: 16, color: Color(0xFF334155)),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Wage: ${job['wage'] ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 17,
                        color: Color(0xFF0F766E),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Applied successfully (mock).')),
                          );
                        },
                        icon: const Icon(Icons.send_rounded),
                        label: const Text('Apply Now'),
                      ),
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
