import 'package:flutter/material.dart';

/// A polished, full-screen widget displayed when the app has expired.
///
/// Shows an animated lock icon, an expiration message, and the date
/// on which the app expired. This is the default screen used by
/// [ExpiryApp] when no custom `expiredWidget` is provided.
///
/// ```dart
/// DefaultExpiredScreen(
///   expiryDate: DateTime(2026, 6, 1),
/// )
/// ```
class DefaultExpiredScreen extends StatefulWidget {
  /// The date when the app expired.
  final DateTime expiryDate;

  /// Optional title text. Defaults to `'App Expired'`.
  final String? title;

  /// Optional message text. Defaults to a standard expiration message.
  final String? message;

  /// Optional contact information displayed below the message.
  final String? contactInfo;

  /// Creates a [DefaultExpiredScreen].
  const DefaultExpiredScreen({
    super.key,
    required this.expiryDate,
    this.title,
    this.message,
    this.contactInfo,
  });

  @override
  State<DefaultExpiredScreen> createState() => _DefaultExpiredScreenState();
}

class _DefaultExpiredScreenState extends State<DefaultExpiredScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.title ?? 'App Expired';
    final message = widget.message ??
        'This application expired on ${_formatDate(widget.expiryDate)}.\n'
            'Please contact the developer for a renewed license.';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A1A2E),
                Color(0xFF16213E),
                Color(0xFF0F3460),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated lock icon
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.1),
                            border: Border.all(
                              color: const Color(0xFFE94560),
                              width: 3,
                            ),
                          ),
                          child: const Icon(
                            Icons.lock_outline_rounded,
                            size: 56,
                            color: Color(0xFFE94560),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Title
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // Divider accent
                      Container(
                        width: 60,
                        height: 3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFE94560),
                              Color(0xFFFF6B6B),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Message
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.8),
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      // Contact info
                      if (widget.contactInfo != null) ...[
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.email_outlined,
                                color: Colors.white.withValues(alpha: 0.6),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Text(
                                  widget.contactInfo!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 48),

                      // Expiry date badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE94560).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFE94560).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          'Expired on ${_formatDate(widget.expiryDate)}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFFFF6B6B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
