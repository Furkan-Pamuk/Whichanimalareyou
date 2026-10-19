import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/presentation/home_screen.dart';
import '../providers/roots_provider.dart';

class RootsResultScreen extends ConsumerWidget {
  const RootsResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(rootsProvider);
    final top = state.topRegion;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (state.isLoading || top == null) {
      return const Scaffold(
        backgroundColor: AppColors.deepCharcoal,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.vibrantAmber),
        ),
      );
    }

    final topColor = Color(int.parse('0xFF${top.colorCode.substring(1)}'));

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.deepCharcoal : AppColors.softCream,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            ref.read(rootsProvider.notifier).reset();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'YOUR ROOTS MAP',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: 1.5,
                  color: isDark
                      ? AppColors.textDarkSecondary
                      : AppColors.textLightSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${top.percent}% ${top.name}',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w800,
                  fontSize: 36,
                  letterSpacing: -1,
                  color: isDark
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: topColor.withOpacity(0.18),
                      blurRadius: 30,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(top.emoji,
                        style: const TextStyle(fontSize: 72)),
                    const SizedBox(height: 12),
                    Text(
                      top.description,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        height: 1.7,
                        color: isDark
                            ? AppColors.textDarkSecondary
                            : AppColors.textLightSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Full Breakdown',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: isDark
                            ? AppColors.textDarkPrimary
                            : AppColors.textLightPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...state.breakdown.map((region) {
                      final color = Color(int.parse(
                          '0xFF${region.colorCode.substring(1)}'));
                      return Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: 7),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(region.emoji,
                                    style:
                                        const TextStyle(fontSize: 20)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    region.name,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: isDark
                                          ? AppColors.textDarkPrimary
                                          : AppColors
                                              .textLightPrimary,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${region.percent}%',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: color,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: TweenAnimationBuilder<double>(
                                tween: Tween(
                                    begin: 0,
                                    end: region.percent / 100),
                                duration: const Duration(
                                    milliseconds: 900),
                                builder: (context, value, _) {
                                  return LinearProgressIndicator(
                                    value: value,
                                    minHeight: 8,
                                    backgroundColor: isDark
                                        ? Colors.white10
                                        : Colors.black12,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(
                                            color),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.vibrantAmber.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color:
                          AppColors.vibrantAmber.withOpacity(0.35)),
                ),
                child: Text(
                  'Just for fun! This is not a real DNA test. Your photo never leaves your device.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    height: 1.5,
                    color: isDark
                        ? AppColors.textDarkSecondary
                        : AppColors.textLightSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final lines = state.breakdown
                        .map((r) =>
                            '${r.emoji} ${r.name}: ${r.percent}%')
                        .join('\n');
                    Share.share(
                      'My Roots Map! 🧬\n$lines\nFind your roots with "Which One Are You?"!',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: topColor,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    textStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  child: const Text('Share Roots Map'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(rootsProvider.notifier).reset();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const HomeScreen()),
                      (route) => false,
                    );
                  },
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
