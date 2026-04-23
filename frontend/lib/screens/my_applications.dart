import 'package:flutter/material.dart';

import '../services/api_service.dart';

class MyApplicationsScreen extends StatefulWidget {
  const MyApplicationsScreen({super.key});

  @override
  State<MyApplicationsScreen> createState() => _MyApplicationsScreenState();
}

class _MyApplicationsScreenState extends State<MyApplicationsScreen> {
  late Future<List<Map<String, dynamic>>> _applicationsFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _applicationsFuture = _loadApplications();
  }

  Future<List<Map<String, dynamic>>> _loadApplications() async {
    final args = ModalRoute.of(context)?.settings.arguments;
    final userData = args is Map<String, dynamic> ? args : <String, dynamic>{};
    final token = userData['token']?.toString() ?? '';

    if (token.isEmpty) {
      throw Exception('Session expired. Please login again.');
    }

    return ApiService.fetchMyApplications(token: token);
  }

  Future<void> _refresh() async {
    setState(() {
      _applicationsFuture = _loadApplications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Applications')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _applicationsFuture,
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

          final applications = snapshot.data ?? [];
          if (applications.isEmpty) {
            return const Center(child: Text('You have not applied to any jobs yet.'));
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: applications.length,
              itemBuilder: (context, index) {
                final application = applications[index];
                final job = Map<String, dynamic>.from(application['job'] as Map? ?? {});
                final status = application['status']?.toString() ?? 'pending';
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(job['title']?.toString() ?? 'Job'),
                    subtitle: Text('${job['location'] ?? 'N/A'} • ${job['wage'] ?? 'N/A'}\nStatus: $status'),
                    isThreeLine: true,
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
