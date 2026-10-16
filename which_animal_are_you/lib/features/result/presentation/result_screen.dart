import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/animal_constants.dart';
import '../providers/result_provider.dart';
import '../../home/presentation/home_screen.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resultProvider);
    final animal = state.matchedAnimal;

    if (state.isLoading || animal == null) {
      return const Scaffold(
        backgroundColor: AppColors.deepCharcoal,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.vibrantAmber),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.deepCharcoal : AppColors.softCream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _Header(animal: animal, percentage: state.matchPercentage),
              const SizedBox(height: 24),
              _AnimalCard(animal: animal, percentage: state.matchPercentage),
              const SizedBox(height: 24),
              _ShareCard(animal: animal, percentage: state.matchPercentage),
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
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
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

  const _Header({required this.animal, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Your Animal Match',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            letterSpacing: 1.5,
            color: Theme.of(context).brightness == Brightness.dark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$percentage% ${animal.name}',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w800,
            fontSize: 36,
            letterSpacing: -2,
            color: Theme.of(context).brightness == Brightness.dark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
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
            color: Theme.of(context).brightness == Brightness.dark ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.05),
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
              color: Theme.of(context).brightness == Brightness.dark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: animal.traits.map((trait) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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

  const _ShareCard({required this.animal, required this.percentage});

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse('0xFF${animal.colorCode.substring(1)}'));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1A1A2E) : const Color(0xFFFFF5F0),
            Theme.of(context).brightness == Brightness.dark ? const Color(0xFF121212) : const Color(0xFFF8F0F5),
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
                child: Text(animal.emoji, style: const TextStyle(fontSize: 24)),
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
                        color: Theme.of(context).brightness == Brightness.dark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Post to Instagram or WhatsApp!',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: Theme.of(context).brightness == Brightness.dark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.08),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'I am $percentage% ${animal.name}!',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Theme.of(context).brightness == Brightness.dark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Find out which animal you are with "Which Animal Are You?"!',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Theme.of(context).brightness == Brightness.dark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.share_rounded, color: color, size: 28),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Share.share(
                  'I am $percentage% ${animal.name}! 🐾 ${animal.emoji}\n${animal.description}\nFind out which animal you are with "Which Animal Are You?"!',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 4,
                shadowColor: color.withOpacity(0.4),
                textStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              child: const Text('Share Result'),
            ),
          ),
        ],
      ),
    );
  }
}
