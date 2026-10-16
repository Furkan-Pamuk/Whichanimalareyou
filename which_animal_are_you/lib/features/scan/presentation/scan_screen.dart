import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../result/providers/result_provider.dart';
import '../providers/scan_provider.dart';
import '../../result/presentation/result_screen.dart';

class ScanScreen extends ConsumerStatefulWidget {
  final String imagePath;

  const ScanScreen({super.key, required this.imagePath});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _messageController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _messageController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(resultProvider.notifier).startAnalysis(widget.imagePath);
      _startScan();
    });

    _messageController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(scanMessageProvider.notifier).cycleMessages();
        });
      }
    });
  }

  Future<void> _startScan() async {
    await ref.read(resultProvider.notifier).completeAnalysis();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ResultScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final message = ref.watch(scanMessageProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D14),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _BackgroundGrid(),
          _ImageOverlay(imagePath: widget.imagePath),
          _ScanOverlay(pulseController: _pulseController),
          _LoadingOverlay(message: message, pulseController: _pulseController),
        ],
      ),
    );
  }
}

class _BackgroundGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GridPainter(),
      size: Size.infinite,
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2E7D32).withOpacity(0.15)
      ..strokeWidth = 1;
    final step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    final pulsePaint = Paint()
      ..color = const Color(0xFFFF6F61).withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (double r = 60; r < 300; r += 60) {
      canvas.drawCircle(Offset(size.width / 2, size.height / 3), r, pulsePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ImageOverlay extends StatelessWidget {
  final String imagePath;
  const _ImageOverlay({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.25,
        child: Image.file(
          File(imagePath),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFF6F61).withOpacity(0.2),
                  const Color(0xFFFFA000).withOpacity(0.15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScanOverlay extends StatelessWidget {
  final AnimationController pulseController;
  const _ScanOverlay({required this.pulseController});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: pulseController,
        builder: (context, child) {
          final value = pulseController.value;
          return Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: ScanRingPainter(progress: value),
                ),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: PulseWavePainter(progress: value),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ScanRingPainter extends CustomPainter {
  final double progress;
  ScanRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2.2);
    final rect = Rect.fromCircle(center: center, radius: 100 + progress * 20);
    final gradient = SweepGradient(
      center: Alignment.center,
      colors: [
        const Color(0xFFFFA000).withOpacity(0.3),
        const Color(0xFFFFA000).withOpacity(0.8),
        const Color(0xFFFF6F61).withOpacity(0.8),
        const Color(0xFFFFA000).withOpacity(0.3),
      ],
      stops: const [0.0, 0.3, 0.7, 1.0],
      transform: GradientRotation(progress * 4),
    );
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PulseWavePainter extends CustomPainter {
  final double progress;
  PulseWavePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2.2);
    for (int i = 1; i <= 3; i++) {
      final radius = 140 + (progress * 30) + (i * 25);
      final alpha = (1.0 - (i / 4)).clamp(0.1, 0.6);
      final paint = Paint()
        ..color = const Color(0xFFFFA000).withOpacity(alpha * 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _LoadingOverlay extends StatelessWidget {
  final String message;
  final AnimationController pulseController;

  const _LoadingOverlay({required this.message, required this.pulseController});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          AnimatedBuilder(
            animation: pulseController,
            builder: (context, child) {
              return Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFFA000).withOpacity(0.3 + pulseController.value * 0.4),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFA000).withOpacity(0.2 + pulseController.value * 0.3),
                      blurRadius: 20 + pulseController.value * 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.pets_rounded,
                    size: 48,
                    color: const Color(0xFFFFA000),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Analyzing...',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Text(
              message,
              key: ValueKey(message),
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 200,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.white12,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return AnimatedBuilder(
                  animation: pulseController,
                  builder: (context, child) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: constraints.maxWidth * (0.3 + pulseController.value * 0.5),
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFFF6F61),
                              const Color(0xFFFFA000),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
