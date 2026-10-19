import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../result/providers/result_provider.dart';
import '../../../core/providers/category_provider.dart';
import '../providers/scan_provider.dart';
import '../../result/presentation/result_screen.dart';

class ScanScreen extends ConsumerStatefulWidget {
  final String imagePath;
  final bool rootsMode;
  final void Function(WidgetRef ref)? onStart;
  final Future<void> Function(WidgetRef ref)? onAnalyze;
  final Widget resultScreen;

  const ScanScreen({
    super.key,
    required this.imagePath,
    this.rootsMode = false,
    this.onStart,
    this.onAnalyze,
    this.resultScreen = const ResultScreen(),
  });

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scanController;
  Timer? _messageTimer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.onStart != null) {
        widget.onStart!(ref);
      } else {
        ref.read(resultProvider.notifier).startAnalysis(widget.imagePath);
      }
      _startScan();
    });

    // Cycle loading messages every 2 seconds (outside build, safe).
    _messageTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;
      if (widget.rootsMode) {
        ref.read(rootsMessageProvider.notifier).cycleMessages();
      } else {
        ref.read(scanMessageProvider.notifier).cycleMessages();
      }
    });
  }

  Future<void> _startScan() async {
    if (widget.onAnalyze != null) {
      await widget.onAnalyze!(ref);
    } else {
      final pool = ref.read(selectedCategoryDataProvider).items;
      await ref.read(resultProvider.notifier).completeAnalysis(pool: pool);
    }
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => widget.resultScreen,
        ),
      );
    }
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _pulseController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final message = widget.rootsMode
        ? ref.watch(rootsMessageProvider)
        : ref.watch(scanMessageProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D14),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _BackgroundGrid(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white10,
                        radius: 20,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_rounded,
                              color: Colors.white, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Scanning your photo',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Captured photo, clearly visible during analysis.
                  _PhotoCard(
                    imagePath: widget.imagePath,
                    pulseController: _pulseController,
                    scanController: _scanController,
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
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                          opacity: animation, child: child);
                    },
                    child: Text(
                      message,
                      key: ValueKey(message),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ProgressBar(pulseController: _pulseController),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoCard extends StatelessWidget {
  final String imagePath;
  final AnimationController pulseController;
  final AnimationController scanController;

  const _PhotoCard({
    required this.imagePath,
    required this.pulseController,
    required this.scanController,
  });

  @override
  Widget build(BuildContext context) {
    final double cardWidth =
        (MediaQuery.of(context).size.width * 0.85).clamp(260.0, 360.0);
    const double cardHeight = 420;

    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        return Container(
          width: cardWidth,
          height: cardHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: const Color(0xFFFFA000)
                  .withOpacity(0.35 + pulseController.value * 0.4),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFA000)
                    .withOpacity(0.18 + pulseController.value * 0.25),
                blurRadius: 24 + pulseController.value * 20,
                spreadRadius: 4,
              ),
              const BoxShadow(
                color: Colors.black54,
                blurRadius: 24,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _CapturedImage(imagePath: imagePath),
                // Subtle dark gradient top/bottom so overlay UI reads well.
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.25),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.35),
                      ],
                      stops: const [0.0, 0.25, 0.7, 1.0],
                    ),
                  ),
                ),
                // Moving scan line.
                AnimatedBuilder(
                  animation: scanController,
                  builder: (context, _) {
                    final double top =
                        scanController.value * (cardHeight - 8);
                    return Positioned(
                      top: top,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Colors.transparent,
                              Color(0xFFFFA000),
                              Color(0xFFFF6F61),
                              Colors.transparent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFA000)
                                  .withOpacity(0.8),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                // Corner brackets for a camera-scan feel.
                const _CornerBracket(alignment: Alignment.topLeft),
                const _CornerBracket(alignment: Alignment.topRight),
                const _CornerBracket(alignment: Alignment.bottomLeft),
                const _CornerBracket(alignment: Alignment.bottomRight),
                // Center face guide.
                Center(
                  child: Container(
                    width: 190,
                    height: 230,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(110),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.55),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                // Live badge.
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.25)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF6F61),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'YOUR PHOTO',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                            letterSpacing: 1.2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CapturedImage extends StatelessWidget {
  final String imagePath;
  const _CapturedImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) {
      return Container(
        color: const Color(0xFF1E1E1E),
        child: const Center(
          child: Icon(Icons.person_rounded,
              size: 90, color: Colors.white24),
        ),
      );
    }
    if (kIsWeb) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2A2A3A), Color(0xFF121212)],
            ),
          ),
          child: const Center(
            child: Icon(Icons.image_not_supported_rounded,
                size: 64, color: Colors.white30),
          ),
        ),
      );
    }
    return Image.file(
      File(imagePath),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2A2A3A), Color(0xFF121212)],
          ),
        ),
        child: const Center(
          child: Icon(Icons.image_not_supported_rounded,
              size: 64, color: Colors.white30),
        ),
      ),
    );
  }
}

class _CornerBracket extends StatelessWidget {
  final Alignment alignment;
  const _CornerBracket({required this.alignment});

  @override
  Widget build(BuildContext context) {
    final bool isTop =
        alignment == Alignment.topLeft || alignment == Alignment.topRight;
    final bool isLeft =
        alignment == Alignment.topLeft || alignment == Alignment.bottomLeft;
    return Align(
      alignment: alignment,
      child: Container(
        width: 44,
        height: 44,
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border(
            top: isTop
                ? const BorderSide(color: Color(0xFFFFA000), width: 4)
                : BorderSide.none,
            bottom: !isTop
                ? const BorderSide(color: Color(0xFFFFA000), width: 4)
                : BorderSide.none,
            left: isLeft
                ? const BorderSide(color: Color(0xFFFFA000), width: 4)
                : BorderSide.none,
            right: !isLeft
                ? const BorderSide(color: Color(0xFFFFA000), width: 4)
                : BorderSide.none,
          ),
          borderRadius: BorderRadius.only(
            topLeft: alignment == Alignment.topLeft
                ? const Radius.circular(16)
                : Radius.zero,
            topRight: alignment == Alignment.topRight
                ? const Radius.circular(16)
                : Radius.zero,
            bottomLeft: alignment == Alignment.bottomLeft
                ? const Radius.circular(16)
                : Radius.zero,
            bottomRight: alignment == Alignment.bottomRight
                ? const Radius.circular(16)
                : Radius.zero,
          ),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final AnimationController pulseController;
  const _ProgressBar({required this.pulseController});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
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
                  width: constraints.maxWidth *
                      (0.3 + pulseController.value * 0.6),
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFF6F61),
                        Color(0xFFFFA000),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
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
    const step = 40.0;
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
      canvas.drawCircle(
          Offset(size.width / 2, size.height / 3), r, pulsePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
