import 'package:flutter/material.dart';
import 'package:flutter_app_expiry/flutter_app_expiry.dart';

void main() {
  // ── Option 1: Local expiry date ──────────────────────────────────────
  runApp(
    ExpiryApp(
      expiryDate: DateTime(2026, 12, 31),
      expiredTitle: 'Trial Ended',
      expiredMessage:
          'Your trial period has ended.\nPlease renew your license to continue using the app.',
      contactInfo: 'support@example.com',
      child: const MyApp(),
    ),
  );

  // ── Option 2: Remote expiry date (uncomment to try) ─────────────────
  // runApp(
  //   ExpiryApp.remote(
  //     remoteUrl: 'https://api.example.com/app/expiry',
  //     fallbackExpiryDate: DateTime(2026, 12, 31),
  //     jsonKey: 'expiryDate',          // key in JSON response
  //     timeout: const Duration(seconds: 10),
  //     expiredTitle: 'Trial Ended',
  //     expiredMessage: 'Your trial has ended. Contact support.',
  //     contactInfo: 'support@example.com',
  //     child: const MyApp(),
  //   ),
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6750A4),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const service = ExpiryService();
    final expiryDate = DateTime(2026, 12, 31);
    final remaining = service.remainingDays(expiryDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            const Text(
              'App is Active! 🎉',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '$remaining days remaining',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
