import 'package:flutter/material.dart';

import '../services/api_service.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _jobsFuture;
  String _selectedCategory = 'All';

  static const List<String> _serviceCategories = [
    'All',
    'Plumbing',
    'Electrician',
    'Cleaning',
    'Painting',
    'Carpentry',
    'Masonry',
    'Delivery',
    'Urgent',
  ];

  static const List<_QuickAction> _quickActions = [
    _QuickAction(Icons.bolt_outlined, 'Urgent Fix', 'Urgent'),
    _QuickAction(Icons.cleaning_services_outlined, 'Cleaning', 'Cleaning'),
    _QuickAction(Icons.plumbing_outlined, 'Plumbing', 'Plumbing'),
    _QuickAction(Icons.electrical_services_outlined, 'Electrician', 'Electrician'),
    _QuickAction(Icons.format_paint_outlined, 'Painting', 'Painting'),
    _QuickAction(Icons.handyman_outlined, 'Carpentry', 'Carpentry'),
  ];

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
  void initState() {
    super.initState();
    _jobsFuture = ApiService.fetchJobs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshJobs() async {
    setState(() {
      _jobsFuture = ApiService.fetchJobs();
    });
  }

  String _jobCategory(Map<String, dynamic> job) {
    final title = job['title']?.toString().toLowerCase() ?? '';
    final location = job['location']?.toString().toLowerCase() ?? '';
    final description = job['description']?.toString().toLowerCase() ?? '';
    final source = '$title $location $description';

    if (source.contains('urgent') || source.contains('emergency')) {
      return 'Urgent';
    }
    if (source.contains('plumb')) {
      return 'Plumbing';
    }
    if (source.contains('electric') || source.contains('light')) {
      return 'Electrician';
    }
    if (source.contains('clean') || source.contains('sweep') || source.contains('helper')) {
      return 'Cleaning';
    }
    if (source.contains('paint')) {
      return 'Painting';
    }
    if (source.contains('carp')) {
      return 'Carpentry';
    }
    if (source.contains('mason') || source.contains('tile') || source.contains('steel') || source.contains('concrete')) {
      return 'Masonry';
    }
    if (source.contains('driver') || source.contains('supply') || source.contains('delivery')) {
      return 'Delivery';
    }
    return 'All';
  }

  List<Map<String, dynamic>> _filterJobs(List<Map<String, dynamic>> jobs) {
    final query = _searchController.text.trim().toLowerCase();

    return jobs.where((job) {
      final title = job['title']?.toString().toLowerCase() ?? '';
      final location = job['location']?.toString().toLowerCase() ?? '';
      final wage = job['wage']?.toString().toLowerCase() ?? '';
      final category = _jobCategory(job);

      final matchesQuery = query.isEmpty ||
          title.contains(query) ||
          location.contains(query) ||
          wage.contains(query) ||
          category.toLowerCase().contains(query);
      final matchesCategory = _selectedCategory == 'All' || category == _selectedCategory;

      return matchesQuery && matchesCategory;
    }).toList();
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final userData = args is Map<String, dynamic> ? args : <String, dynamic>{};
    final role = userData['role']?.toString() ?? 'worker';
    final isEmployer = role == 'employer';

    return Scaffold(
      appBar: AppBar(
        title: const Text('LaborLinks'),
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

            final jobs = _filterJobs(snapshot.data ?? []);

            return RefreshIndicator(
              onRefresh: _refreshJobs,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                children: [
                  _buildHeroSection(isEmployer),
                  const SizedBox(height: 14),
                  _buildQuickActionGrid(),
                  const SizedBox(height: 14),
                  _buildSearchBar(),
                  const SizedBox(height: 12),
                  _buildCategoryFilters(),
                  const SizedBox(height: 16),
                  _buildFeatureStrip(),
                  const SizedBox(height: 18),
                  _buildSectionHeader(
                    isEmployer ? 'Jobs with applicants' : 'Available services',
                    'Verified workers, transparent pricing, and quick response times.',
                  ),
                  const SizedBox(height: 12),
                  if (jobs.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: Text('No matching jobs available right now.'),
                      ),
                    )
                  else
                    ...jobs.map((job) => _buildJobCard(context, job, userData)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isEmployer) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F766E), Color(0xFF0B3A37)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x330F172A),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEmployer ? 'Hire trusted workers fast' : 'Book trusted help in minutes',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isEmployer
                ? 'LaborLinks now blends the speed of Pronto with the trust-first service model of Urban Company.'
                : 'LaborLinks now brings verified pros, upfront service options, and quick booking flows inspired by Urban Company and Pronto.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _FeatureChip(label: 'Verified experts', icon: Icons.verified_outlined),
              _FeatureChip(label: 'Live tracking', icon: Icons.navigation_outlined),
              _FeatureChip(label: 'Fast slots', icon: Icons.timer_outlined),
              _FeatureChip(label: '24/7 support', icon: Icons.support_agent_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _quickActions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (context, index) {
        final action = _quickActions[index];
        return InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _selectCategory(action.filter),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x140F172A),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFFE0F2FE),
                    child: Icon(action.icon, color: const Color(0xFF0F766E)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    action.label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      decoration: const InputDecoration(
        labelText: 'Search services, locations, or wages',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _serviceCategories.map((category) {
          final selected = category == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(category),
              selected: selected,
              onSelected: (_) => _selectCategory(category),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeatureStrip() {
    return Row(
      children: [
        Expanded(
          child: _FeatureMetricCard(
            label: 'Avg response',
            value: 'Under 60 min',
            icon: Icons.speed_outlined,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _FeatureMetricCard(
            label: 'Trust score',
            value: '4.8 / 5',
            icon: Icons.star_outline,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildJobCard(
    BuildContext context,
    Map<String, dynamic> job,
    Map<String, dynamic> userData,
  ) {
    final title = job['title']?.toString() ?? '';
    final emoji = _jobEmojis[title] ?? '💼';
    final category = _jobCategory(job);

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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        title: Row(
          children: [
            Expanded(
              child: Text(
                '$emoji $title',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            _CategoryBadge(label: category),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '${job['location'] ?? 'Location not set'} • ${job['wage'] ?? 'Price on request'}',
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
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final String filter;

  const _QuickAction(this.icon, this.label, this.filter);
}

class _FeatureChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _FeatureChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: Colors.white.withOpacity(0.14),
      side: BorderSide(color: Colors.white.withOpacity(0.2)),
      labelPadding: const EdgeInsets.symmetric(horizontal: 6),
      avatar: Icon(icon, color: Colors.white, size: 18),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _FeatureMetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _FeatureMetricCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFE0F2FE),
            child: Icon(icon, size: 18, color: const Color(0xFF0F766E)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String label;

  const _CategoryBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2FE),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0F766E),
        ),
      ),
    );
  }
}
