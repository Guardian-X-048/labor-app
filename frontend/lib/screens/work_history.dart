import 'package:flutter/material.dart';

class WorkHistoryScreen extends StatelessWidget {
  const WorkHistoryScreen({super.key});

  static const List<Map<String, String>> _workHistory = [
    {
      'role': 'Mason',
      'company': 'Skyline Builders',
      'duration': 'Jan 2026 - Apr 2026',
      'location': 'Noida',
    },
    {
      'role': 'Painter',
      'company': 'Urban Homes',
      'duration': 'Sep 2025 - Dec 2025',
      'location': 'Delhi',
    },
    {
      'role': 'Welder',
      'company': 'Metro Infra Works',
      'duration': 'Mar 2025 - Aug 2025',
      'location': 'Ghaziabad',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Work History Details')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEFF6FF), Color(0xFFFFF8ED)],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          itemCount: _workHistory.length,
          itemBuilder: (context, index) {
            final item = _workHistory[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
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
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE0F2FE),
                  child: Icon(Icons.work_outline, color: Color(0xFF0369A1)),
                ),
                title: Text(
                  item['role'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '${item['company']}\n${item['duration']} • ${item['location']}',
                    style: const TextStyle(color: Color(0xFF475569), height: 1.4),
                  ),
                ),
                isThreeLine: true,
              ),
            );
          },
        ),
      ),
    );
  }
}
