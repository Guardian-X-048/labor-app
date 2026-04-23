import 'package:flutter/material.dart';

import '../services/api_service.dart';

class EmployerDashboardScreen extends StatefulWidget {
  const EmployerDashboardScreen({super.key});

  @override
  State<EmployerDashboardScreen> createState() => _EmployerDashboardScreenState();
}

class _EmployerDashboardScreenState extends State<EmployerDashboardScreen> {
  late Future<List<Map<String, dynamic>>> _jobsFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _jobsFuture = _loadJobs();
  }

  Future<List<Map<String, dynamic>>> _loadJobs() async {
    final args = ModalRoute.of(context)?.settings.arguments;
    final userData = args is Map<String, dynamic> ? args : <String, dynamic>{};
    final token = userData['token']?.toString() ?? '';

    if (token.isEmpty) {
      throw Exception('Session expired. Please login again.');
    }

    return ApiService.fetchEmployerJobs(token: token);
  }

  Future<void> _refresh() async {
    setState(() {
      _jobsFuture = _loadJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final userData = args is Map<String, dynamic> ? args : <String, dynamic>{};

    return Scaffold(
      appBar: AppBar(title: const Text('Employer Dashboard')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _jobsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(snapshot.error.toString().replaceFirst('Exception: ', ''), textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(onPressed: _refresh, child: const Text('Retry')),
                  ],
                ),
              ),
            );
          }

          final jobs = snapshot.data ?? [];
          if (jobs.isEmpty) {
            return const Center(child: Text('No jobs posted yet. Use Post Job to create one.'));
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(job['title']?.toString() ?? 'Job'),
                    subtitle: Text('${job['location'] ?? 'N/A'} • ${job['wage'] ?? 'N/A'}'),
                    trailing: const Icon(Icons.people_outline),
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/job-applicants',
                      arguments: {
                        ...userData,
                        'jobId': job['_id'],
                        'jobTitle': job['title'] ?? 'Job',
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
