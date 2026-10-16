import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppColors.warmCoral,
                AppColors.vibrantAmber,
                AppColors.jungleGreen,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.warmCoral.withOpacity(0.35),
                blurRadius: 20,
                spreadRadius: 4,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '🐾',
              style: TextStyle(fontSize: 56),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Which Animal Are You?',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w800,
            fontSize: 28,
            letterSpacing: -0.5,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Find Your Wild Counterpart',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
