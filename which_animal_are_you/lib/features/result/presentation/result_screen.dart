import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/animal_constants.dart';
import '../../../../core/providers/category_provider.dart';
import '../providers/result_provider.dart';
import '../../home/presentation/home_screen.dart';

class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key});

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isSharing = false;

  Future<void> _shareAsStoryImage(BuildContext context, AnimalData animal,
      int percentage, String brandTitle) async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    try {
      final bytes = await _screenshotController.captureFromWidget(
        _StoryCard(
            animal: animal, percentage: percentage, brandTitle: brandTitle),
        pixelRatio: 2.0,
        delay: const Duration(milliseconds: 100),
        targetSize: const Size(540, 960),
      );
      final file = XFile.fromData(
        bytes,
        name: 'animal-story.png',
        mimeType: 'image/png',
      );
      await Share.shareXFiles(
        [file],
        text:
            'I am $percentage% ${animal.name}! Find out which one you are with "Which One Are You?"!',
      );
    } catch (_) {
      if (context.mounted) {
        // Fallback to text share so the button never looks broken.
        await Share.share(
          'I am $percentage% ${animal.name}! ${animal.emoji}\n${animal.description}\nFind out which one you are with "Which One Are You?"!',
        );
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(resultProvider);
    final animal = state.matchedAnimal;
    final category = ref.watch(selectedCategoryDataProvider);

    if (state.isLoading || animal == null) {
      return const Scaffold(
        backgroundColor: AppColors.deepCharcoal,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.vibrantAmber),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.deepCharcoal
          : AppColors.softCream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _Header(
                  animal: animal,
                  percentage: state.matchPercentage,
                  noun: category.noun),
              const SizedBox(height: 24),
              _AnimalCard(animal: animal, percentage: state.matchPercentage),
              const SizedBox(height: 24),
              _ShareCard(
                animal: animal,
                percentage: state.matchPercentage,
                brandTitle: category.title,
                isSharing: _isSharing,
                onShare: () => _shareAsStoryImage(
                    context, animal, state.matchPercentage, category.title),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(resultProvider.notifier).reset();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warmCoral,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    elevation: 6,
                    shadowColor: AppColors.warmCoral.withOpacity(0.4),
                    textStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  child: const Text('Try Again'),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Results are generated for entertainment purposes.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.textDarkSecondary
                      : AppColors.textLightSecondary,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final AnimalData animal;
  final int percentage;
  final String noun;

  const _Header(
      {required this.animal, required this.percentage, required this.noun});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Your $noun Match',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            letterSpacing: 1.5,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textDarkSecondary
                : AppColors.textLightSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$percentage% ${animal.name}',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w800,
            fontSize: 36,
            letterSpacing: -2,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textDarkPrimary
                : AppColors.textLightPrimary,
          ),
        ),
      ],
    );
  }
}

class _AnimalCard extends StatelessWidget {
  final AnimalData animal;
  final int percentage;

  const _AnimalCard({required this.animal, required this.percentage});

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse('0xFF${animal.colorCode.substring(1)}'));
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 30,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.4)
                : Colors.black.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.2),
                  color.withOpacity(0.05),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.35),
                  blurRadius: 20,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: Center(
              child: Text(
                animal.emoji,
                style: const TextStyle(fontSize: 72),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            animal.description,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              height: 1.7,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textDarkSecondary
                  : AppColors.textLightSecondary,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: animal.traits.map((trait) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withOpacity(0.3), width: 1),
                ),
                child: Text(
                  trait,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: color,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _ShareCard extends StatelessWidget {
  final AnimalData animal;
  final int percentage;
  final String brandTitle;
  final bool isSharing;
  final VoidCallback onShare;

  const _ShareCard({
    required this.animal,
    required this.percentage,
    required this.brandTitle,
    required this.isSharing,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse('0xFF${animal.colorCode.substring(1)}'));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1A1A2E)
                : const Color(0xFFFFF5F0),
            Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF121212)
                : const Color(0xFFF8F0F5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: color.withOpacity(0.15),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child:
                    Text(animal.emoji, style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Share Your Wild Side',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color:
                            Theme.of(context).brightness == Brightness.dark
                                ? AppColors.textDarkPrimary
                                : AppColors.textLightPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Story-ready 9:16 image for Instagram / WhatsApp!',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color:
                            Theme.of(context).brightness == Brightness.dark
                                ? AppColors.textDarkSecondary
                                : AppColors.textLightSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 9:16 story preview (scaled down).
          Center(
            child: Container(
              width: 150,
              height: 266,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: color.withOpacity(0.4), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _StoryCard(
                    animal: animal,
                    percentage: percentage,
                    brandTitle: brandTitle),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isSharing ? null : onShare,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 4,
                shadowColor: color.withOpacity(0.4),
                textStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              child: isSharing
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text('Share Result'),
            ),
          ),
        ],
      ),
    );
  }
}

/// 9:16 Instagram Story card (540 x 960 logical).
/// Rendered both as an on-screen preview and as the captured share image.
class _StoryCard extends StatelessWidget {
  final AnimalData animal;
  final int percentage;
  final String brandTitle;

  const _StoryCard(
      {required this.animal,
      required this.percentage,
      required this.brandTitle});

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse('0xFF${animal.colorCode.substring(1)}'));
    return Material(
      child: Container(
        width: 540,
        height: 960,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF121212),
              Color.lerp(const Color(0xFF121212), color, 0.35) ??
                  const Color(0xFF1E1E1E),
              color,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Decorative circles.
            Positioned(
              top: -70,
              right: -70,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.15),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 44),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🐾', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 8),
                      Text(
                        'WHICH ONE ARE YOU?',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    brandTitle.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      letterSpacing: 1.5,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    width: 210,
                    height: 210,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.15),
                      border:
                          Border.all(color: Colors.white, width: 5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 30,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(animal.emoji,
                          style: const TextStyle(fontSize: 110)),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text(
                    '$percentage%',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w800,
                      fontSize: 84,
                      height: 1,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    animal.name.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w800,
                      fontSize: 34,
                      letterSpacing: 1,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: animal.traits
                        .take(3)
                        .map(
                          (t) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.5)),
                            ),
                            child: Text(
                              t,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Discover your inner wild!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
