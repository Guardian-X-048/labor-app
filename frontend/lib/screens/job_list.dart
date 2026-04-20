import 'package:flutter/material.dart';

class JobListScreen extends StatelessWidget {
  const JobListScreen({super.key});

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

  static const List<Map<String, String>> _jobs = [
    {'title': 'Mason', 'location': 'Noida', 'wage': 'Rs. 700/day'},
    {'title': 'Plumber', 'location': 'Ghaziabad', 'wage': 'Rs. 650/day'},
    {'title': 'Painter', 'location': 'Delhi', 'wage': 'Rs. 600/day'},
    {'title': 'Electrician Helper', 'location': 'Faridabad', 'wage': 'Rs. 750/day'},
    {'title': 'Tiles Installer', 'location': 'Gurugram', 'wage': 'Rs. 800/day'},
    {'title': 'Carpenter', 'location': 'Noida', 'wage': 'Rs. 780/day'},
    {'title': 'Welder', 'location': 'Ghaziabad', 'wage': 'Rs. 850/day'},
    {'title': 'Site Cleaner', 'location': 'Delhi', 'wage': 'Rs. 500/day'},
    {'title': 'Scaffolding Worker', 'location': 'Gurugram', 'wage': 'Rs. 900/day'},
    {'title': 'Driver (Material Supply)', 'location': 'Noida', 'wage': 'Rs. 950/day'},
    {'title': 'Concrete Mixer Operator', 'location': 'Faridabad', 'wage': 'Rs. 880/day'},
    {'title': 'Steel Fixer', 'location': 'Delhi', 'wage': 'Rs. 920/day'},
  ];

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final userData = args is Map<String, String> ? args : <String, String>{};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Jobs'),
        actions: [
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
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          itemCount: _jobs.length,
          itemBuilder: (context, index) {
            final job = _jobs[index];
            final title = job['title'] ?? '';
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
                  arguments: job,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
