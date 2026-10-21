import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_categories.dart';
import '../../../core/providers/category_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_navigator.dart';
import '../../roots/presentation/roots_flow.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedCategoryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Drawer(
      backgroundColor:
          isDark ? AppColors.midnightGray : AppColors.surfaceLight,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.warmCoral,
                    AppColors.vibrantAmber,
                    AppColors.jungleGreen,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🐾🌸', style: TextStyle(fontSize: 36)),
                  const SizedBox(height: 8),
                  Text(
                    'Which One Are You?',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pick your vibe',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'CATEGORIES',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 1.5,
                  color: isDark
                      ? AppColors.textDarkSecondary
                      : AppColors.textLightSecondary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ...AppCategories.all.map((category) {
              final isSelected = category.id == selectedId;
              final color = Color(
                  int.parse('0xFF${category.colorCode.substring(1)}'));
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                child: ListTile(
                  selected: isSelected,
                  selectedTileColor: color.withOpacity(0.12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      category.logoEmoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  title: Text(
                    category.title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: isDark
                          ? AppColors.textDarkPrimary
                          : AppColors.textLightPrimary,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle_rounded,
                          color: color, size: 24)
                      : null,
                  onTap: () {
                    ref
                        .read(selectedCategoryProvider.notifier)
                        .select(category.id);
                    Navigator.pop(context);
                  },
                ),
              );
            }),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.vibrantAmber.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text('🧬',
                      style: TextStyle(fontSize: 24)),
                ),
                title: Text(
                  'DNA Roots Map',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: isDark
                        ? AppColors.textDarkPrimary
                        : AppColors.textLightPrimary,
                  ),
                ),
                trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18),
                onTap: () {
                  Navigator.pop(context);
                  final rootContext = appNavigatorKey.currentContext;
                  if (rootContext != null && rootContext.mounted) {
                    startRootsFlow(rootContext);
                  }
                },
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'More vibes coming soon...',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: isDark
                      ? AppColors.textDarkSecondary
                      : AppColors.textLightSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
