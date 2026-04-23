import 'package:flutter/material.dart';

import 'screens/aadhaar_verify.dart';
import 'screens/employer_dashboard.dart';
import 'screens/job_detail.dart';
import 'screens/job_applicants.dart';
import 'screens/job_list.dart';
import 'screens/job_post.dart';
import 'screens/login.dart';
import 'screens/my_applications.dart';
import 'screens/payment_history.dart';
import 'screens/profile.dart';
import 'screens/signup.dart';
import 'screens/work_history.dart';

void main() {
  runApp(const LaborApp());
}

class LaborApp extends StatelessWidget {
  const LaborApp({super.key});

  @override
  Widget build(BuildContext context) {
    const surfaceTint = Color(0xFFFFF8ED);
    const primary = Color(0xFF0F766E);
    const secondary = Color(0xFFF97316);

    return MaterialApp(
      title: 'Labor App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          secondary: secondary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: surfaceTint,
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE6E8EC)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE6E8EC)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: primary, width: 1.4),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          foregroundColor: Color(0xFF111827),
          titleTextStyle: TextStyle(
            color: Color(0xFF111827),
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/aadhaar-verify': (context) => const AadhaarVerifyScreen(),
        '/jobs': (context) => const JobListScreen(),
        '/job-post': (context) => const JobPostScreen(),
        '/job-detail': (context) => const JobDetailScreen(),
        '/my-applications': (context) => const MyApplicationsScreen(),
        '/employer-dashboard': (context) => const EmployerDashboardScreen(),
        '/job-applicants': (context) => const JobApplicantsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/payment-history': (context) => const PaymentHistoryScreen(),
        '/work-history': (context) => const WorkHistoryScreen(),
      },
    );
  }
}
