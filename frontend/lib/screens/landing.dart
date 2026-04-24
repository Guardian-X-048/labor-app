import 'dart:math' as math;

import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _heroController;

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..forward();
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFFF9EF);
    const primary = Color(0xFF0B6E6B);
    const accent = Color(0xFFF06B1A);

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          const Positioned(
            top: -180,
            right: -120,
            child: _GlowOrb(color: Color(0xFFFFC58F), size: 420),
          ),
          const Positioned(
            bottom: -220,
            left: -140,
            child: _GlowOrb(color: Color(0xFFBFE7D2), size: 460),
          ),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: bg.withValues(alpha: 0.92),
                surfaceTintColor: Colors.transparent,
                title: const Text(
                  'LaborLinks',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Poppins',
                    letterSpacing: -0.8,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: const Text('Sign in'),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: FilledButton(
                      onPressed: () => Navigator.pushNamed(context, '/signup'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF0B6E6B),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      child: const Text('Create account'),
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 26, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeTransition(
                        opacity: CurvedAnimation(
                          parent: _heroController,
                          curve: const Interval(0, 0.4, curve: Curves.easeOut),
                        ),
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.06),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: _heroController,
                              curve: const Interval(0, 0.45, curve: Curves.easeOutCubic),
                            ),
                          ),
                          child: _HeroCard(
                            primary: primary,
                            accent: accent,
                            onDownload: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('App download link coming next.')),
                              );
                            },
                            onExplore: () => Navigator.pushNamed(context, '/jobs'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const _Reveal(delay: 120, child: _StatsStrip()),
                      const SizedBox(height: 34),
                      const _Reveal(
                        delay: 220,
                        child: _SectionTitle(
                          title: 'Smooth hiring flow',
                          subtitle: 'Exactly what users need: quick discovery, trust, and instant action.',
                        ),
                      ),
                      const SizedBox(height: 18),
                      const _Reveal(delay: 320, child: _FlowCards()),
                      const SizedBox(height: 30),
                      const _Reveal(
                        delay: 380,
                        child: _SectionTitle(
                          title: 'Why teams choose LaborLinks',
                          subtitle: 'Modern experience inspired by premium consumer apps with clear CTA and motion.',
                        ),
                      ),
                      const SizedBox(height: 18),
                      const _Reveal(delay: 440, child: _FeatureGrid()),
                      const SizedBox(height: 44),
                      _Reveal(
                        delay: 520,
                        child: _BottomCta(
                          primary: primary,
                          onCreate: () => Navigator.pushNamed(context, '/signup'),
                        ),
                      ),
                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.primary,
    required this.accent,
    required this.onDownload,
    required this.onExplore,
  });

  final Color primary;
  final Color accent;
  final VoidCallback onDownload;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFFFFF), Color(0xFFFFF4E5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: const Color(0xFFFFE2BD)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1F000000),
                blurRadius: 32,
                offset: Offset(0, 16),
              ),
            ],
          ),
          child: Flex(
            direction: isWide ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE4CC),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'LaborLinks App Download',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF9D3C07),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Hire skilled workers in minutes with a fast, premium mobile-like experience.',
                      style: TextStyle(
                        height: 1.2,
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0A1A1B),
                        fontFamily: 'Poppins',
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Top pe sign in and create account ready hai. Neeche smooth transitions ke saath trusted labor marketplace ka full preview milta hai.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF475569),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        FilledButton.icon(
                          onPressed: onDownload,
                          icon: const Icon(Icons.download_rounded),
                          style: FilledButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          label: const Text('Download app'),
                        ),
                        OutlinedButton(
                          onPressed: onExplore,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: accent),
                            foregroundColor: const Color(0xFF9D3C07),
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text('Explore services'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18, height: 18),
              const Expanded(child: _PhoneMockup()),
            ],
          ),
        );
      },
    );
  }
}

class _PhoneMockup extends StatefulWidget {
  const _PhoneMockup();

  @override
  State<_PhoneMockup> createState() => _PhoneMockupState();
}

class _PhoneMockupState extends State<_PhoneMockup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_controller.value);
        final dy = (0.5 - t).abs() * 18;
        final rotation = math.sin(t * math.pi) * 0.03;
        return Transform.translate(
          offset: Offset(0, -dy),
          child: Transform.rotate(
            angle: rotation,
            child: child,
          ),
        );
      },
      child: Container(
        constraints: const BoxConstraints(maxWidth: 330),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(color: Color(0x40000000), blurRadius: 32, offset: Offset(0, 20)),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              colors: [Color(0xFF10324D), Color(0xFF0B6E6B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(14),
            child: Column(
              children: [
                SizedBox(height: 4),
                _PhoneBadge(text: '24/7 available workers'),
                SizedBox(height: 12),
                _PhoneItem(title: 'Plumber within 25 mins', subtitle: '4.9 rating • 250 jobs'),
                SizedBox(height: 10),
                _PhoneItem(title: 'Electrician (Verified)', subtitle: 'Aadhaar checked'),
                SizedBox(height: 10),
                _PhoneItem(title: 'Painter Team', subtitle: 'Bulk project support'),
                Spacer(),
                _PhoneBadge(text: 'Live updates + secure booking'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PhoneBadge extends StatelessWidget {
  const _PhoneBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x33FFFFFF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _PhoneItem extends StatelessWidget {
  const _PhoneItem({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}

class _StatsStrip extends StatelessWidget {
  const _StatsStrip();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 14,
      runSpacing: 12,
      children: [
        _StatTile(label: 'Verified workers', value: '18k+'),
        _StatTile(label: 'Cities covered', value: '120+'),
        _StatTile(label: 'Avg response', value: '8 min'),
        _StatTile(label: 'Repeat customers', value: '89%'),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Color(0xFF64748B))),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 15, color: Color(0xFF64748B), height: 1.4),
        ),
      ],
    );
  }
}

class _FlowCards extends StatelessWidget {
  const _FlowCards();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _FlowCard(number: '01', title: 'Post requirement', desc: 'Describe labor need in 30 seconds.'),
        _FlowCard(number: '02', title: 'Get matched', desc: 'Nearby verified workers start responding.'),
        _FlowCard(number: '03', title: 'Book and track', desc: 'Live status, clear pricing and support.'),
      ],
    );
  }
}

class _FlowCard extends StatelessWidget {
  const _FlowCard({required this.number, required this.title, required this.desc});

  final String number;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFFD6AD)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              number,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF9D3C07),
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(desc, style: const TextStyle(color: Color(0xFF64748B), height: 1.4)),
          ],
        ),
      ),
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _FeatureTile(icon: Icons.shield_rounded, title: 'Verified profiles', desc: 'Aadhaar and trust badges.'),
        _FeatureTile(icon: Icons.bolt_rounded, title: 'Fast dispatch', desc: 'Nearby worker alerts instantly.'),
        _FeatureTile(icon: Icons.payments_rounded, title: 'Clear pricing', desc: 'Rate cards and status updates.'),
        _FeatureTile(icon: Icons.support_agent_rounded, title: 'Live support', desc: 'In-app chat + call help desk.'),
      ],
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({required this.icon, required this.title, required this.desc});

  final IconData icon;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF0B6E6B), size: 28),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(desc, style: const TextStyle(color: Color(0xFF64748B))),
          ],
        ),
      ),
    );
  }
}

class _BottomCta extends StatelessWidget {
  const _BottomCta({required this.primary, required this.onCreate});

  final Color primary;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF092635), Color(0xFF0B6E6B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 14,
        children: [
          const SizedBox(
            width: 560,
            child: Text(
              'Ready to go live? Create your LaborLinks account and start booking trusted workers right now.',
              style: TextStyle(
                fontSize: 24,
                height: 1.3,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ),
          FilledButton(
            onPressed: onCreate,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFF97316),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Create account'),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: 0.55), color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}

class _Reveal extends StatefulWidget {
  const _Reveal({required this.delay, required this.child});

  final int delay;
  final Widget child;

  @override
  State<_Reveal> createState() => _RevealState();
}

class _RevealState extends State<_Reveal> {
  bool _show = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        setState(() => _show = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      offset: _show ? Offset.zero : const Offset(0, 0.04),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOut,
        opacity: _show ? 1 : 0,
        child: widget.child,
      ),
    );
  }
}