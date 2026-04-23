import 'package:flutter/material.dart';

import '../services/api_service.dart';

class JobDetailScreen extends StatefulWidget {
  const JobDetailScreen({super.key});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  bool _isApplying = false;

  Future<void> _applyToJob(Map<String, dynamic> userData, Map<String, dynamic> job) async {
    final token = userData['token']?.toString() ?? '';
    final role = userData['role']?.toString() ?? 'worker';
    final jobId = job['_id']?.toString() ?? '';

    if (role != 'worker') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Only worker accounts can apply.')),
      );
      return;
    }

    if (token.isEmpty || jobId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing session or job details.')),
      );
      return;
    }

    setState(() {
      _isApplying = true;
    });

    try {
      await ApiService.applyToJob(token: token, jobId: jobId);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Applied successfully.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isApplying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final payload = args is Map<String, dynamic> ? args : <String, dynamic>{};
    final job = payload['job'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(payload['job'] as Map)
        : payload;
    final userData = payload['user'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(payload['user'] as Map)
        : <String, dynamic>{};
    final role = userData['role']?.toString() ?? 'worker';

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
                    if ((job['description']?.toString().isNotEmpty ?? false)) ...[
                      const Text(
                        'Description',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        job['description'].toString(),
                        style: const TextStyle(color: Color(0xFF475569)),
                      ),
                      const SizedBox(height: 22),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isApplying
                            ? null
                            : () {
                                if (role != 'worker') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Employer account cannot apply to jobs.'),
                                    ),
                                  );
                                  return;
                                }
                                _applyToJob(userData, job);
                              },
                        icon: const Icon(Icons.send_rounded),
                        label: Text(_isApplying ? 'Applying...' : 'Apply Now'),
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
