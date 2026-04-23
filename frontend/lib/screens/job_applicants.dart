import 'package:flutter/material.dart';

import '../services/api_service.dart';

class JobApplicantsScreen extends StatefulWidget {
  const JobApplicantsScreen({super.key});

  @override
  State<JobApplicantsScreen> createState() => _JobApplicantsScreenState();
}

class _JobApplicantsScreenState extends State<JobApplicantsScreen> {
  late Future<List<Map<String, dynamic>>> _applicantsFuture;
  final Set<String> _updatingApplicationIds = <String>{};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _applicantsFuture = _loadApplicants();
  }

  Future<List<Map<String, dynamic>>> _loadApplicants() async {
    final args = ModalRoute.of(context)?.settings.arguments;
    final data = args is Map<String, dynamic> ? args : <String, dynamic>{};
    final token = data['token']?.toString() ?? '';
    final jobId = data['jobId']?.toString() ?? '';

    if (token.isEmpty || jobId.isEmpty) {
      throw Exception('Missing required session or job details.');
    }

    return ApiService.fetchApplicantsForJob(token: token, jobId: jobId);
  }

  Future<void> _refresh() async {
    setState(() {
      _applicantsFuture = _loadApplicants();
    });
  }

  Future<void> _updateStatus({
    required String applicationId,
    required String status,
  }) async {
    final args = ModalRoute.of(context)?.settings.arguments;
    final data = args is Map<String, dynamic> ? args : <String, dynamic>{};
    final token = data['token']?.toString() ?? '';

    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session expired. Please login again.')),
      );
      return;
    }

    setState(() {
      _updatingApplicationIds.add(applicationId);
    });

    try {
      await ApiService.updateApplicationStatus(
        token: token,
        applicationId: applicationId,
        status: status,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Application marked as $status.')),
      );
      await _refresh();
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
          _updatingApplicationIds.remove(applicationId);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final data = args is Map<String, dynamic> ? args : <String, dynamic>{};
    final jobTitle = data['jobTitle']?.toString() ?? 'Applicants';

    return Scaffold(
      appBar: AppBar(title: Text('Applicants • $jobTitle')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _applicantsFuture,
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

          final applicants = snapshot.data ?? [];
          if (applicants.isEmpty) {
            return const Center(child: Text('No applications received yet.'));
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: applicants.length,
              itemBuilder: (context, index) {
                final application = applicants[index];
                final applicationId = application['_id']?.toString() ?? '';
                final worker = Map<String, dynamic>.from(application['worker'] as Map? ?? {});
                final verified = worker['aadhaarVerified'] == true;
                final status = application['status']?.toString() ?? 'pending';
                final isUpdating = _updatingApplicationIds.contains(applicationId);
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: verified ? const Color(0xFFDCFCE7) : const Color(0xFFFFEDD5),
                      child: Icon(
                        verified ? Icons.verified_user_outlined : Icons.person_outline,
                        color: verified ? const Color(0xFF166534) : const Color(0xFF9A3412),
                      ),
                    ),
                    title: Text(worker['name']?.toString() ?? 'Worker'),
                    subtitle: Text('${worker['phone'] ?? 'N/A'}\nStatus: $status'),
                    isThreeLine: true,
                    trailing: isUpdating
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Accept',
                                icon: const Icon(Icons.check_circle_outline, color: Color(0xFF166534)),
                                onPressed: status == 'accepted' || applicationId.isEmpty
                                    ? null
                                    : () => _updateStatus(
                                          applicationId: applicationId,
                                          status: 'accepted',
                                        ),
                              ),
                              IconButton(
                                tooltip: 'Reject',
                                icon: const Icon(Icons.cancel_outlined, color: Color(0xFFB91C1C)),
                                onPressed: status == 'rejected' || applicationId.isEmpty
                                    ? null
                                    : () => _updateStatus(
                                          applicationId: applicationId,
                                          status: 'rejected',
                                        ),
                              ),
                            ],
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
