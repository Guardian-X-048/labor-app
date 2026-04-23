import 'package:flutter/material.dart';

import '../services/api_service.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  late Future<List<Map<String, dynamic>>> _jobsFuture;

  @override
  void initState() {
    super.initState();
    _jobsFuture = ApiService.fetchJobs();
  }

  Future<void> _refreshJobs() async {
    setState(() {
      _jobsFuture = ApiService.fetchJobs();
    });
  }

  static const Map<String, String> _jobEmojis = {
    'Mason': '🧱',
    'Plumber': '🔧',
    'Painter': '🎨',
    'Electrician Helper': '💡',
    'Tiles Installer': '🟫',
    'Carpenter': '🪚',
    'Welder': '🔥',
    'Site Cleaner': '🧹',
    'Scaffolding Worker': '🏗️',
    'Driver (Material Supply)': '🚚',
    'Concrete Mixer Operator': '⚙️',
    'Steel Fixer': '🔩',
  };

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final userData = args is Map<String, dynamic> ? args : <String, dynamic>{};
    final role = userData['role']?.toString() ?? 'worker';
    final isEmployer = role == 'employer';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Jobs'),
        actions: [
          if (isEmployer)
            IconButton(
              icon: const Icon(Icons.add_business_outlined),
              tooltip: 'Post Job',
              onPressed: () async {
                final posted = await Navigator.pushNamed(
                  context,
                  '/job-post',
                  arguments: userData,
                );

                if (posted == true) {
                  _refreshJobs();
                }
              },
            ),
          if (isEmployer)
            IconButton(
              icon: const Icon(Icons.dashboard_outlined),
              tooltip: 'Employer Dashboard',
              onPressed: () => Navigator.pushNamed(
                context,
                '/employer-dashboard',
                arguments: userData,
              ),
            ),
          if (!isEmployer)
            IconButton(
              icon: const Icon(Icons.assignment_outlined),
              tooltip: 'My Applications',
              onPressed: () => Navigator.pushNamed(
                context,
                '/my-applications',
                arguments: userData,
              ),
            ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile', arguments: userData),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F2FE), Color(0xFFFFF8ED)],
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
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
                      Text(
                        snapshot.error.toString().replaceFirst('Exception: ', ''),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _refreshJobs,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final jobs = snapshot.data ?? [];
            if (jobs.isEmpty) {
              return const Center(
                child: Text('No jobs available right now.'),
              );
            }

            return RefreshIndicator(
              onRefresh: _refreshJobs,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  final job = jobs[index];
                  final title = job['title']?.toString() ?? '';
                  final emoji = _jobEmojis[title] ?? '💼';
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x140F172A),
                          blurRadius: 16,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        '$emoji $title',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${job['location']} • ${job['wage']}',
                          style: const TextStyle(color: Color(0xFF475569)),
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/job-detail',
                        arguments: {
                          'job': job,
                          'user': userData,
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
