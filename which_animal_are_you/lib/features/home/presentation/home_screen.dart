import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/providers/category_provider.dart';
import 'app_drawer.dart';
import 'camera_screen.dart';
import '../../scan/presentation/scan_screen.dart';
import 'brand_logo.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (file != null) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ScanScreen(imagePath: file.path),
            ),
          );
        }
      }
    } catch (e) {
      _showError('Failed to access image. Please check permissions.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
        backgroundColor: AppColors.warmCoral,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeModeProvider);
    final category = ref.watch(selectedCategoryDataProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Icon(
                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  color: Theme.of(context).appBarTheme.iconTheme?.color,
                ),
                const SizedBox(width: 4),
                Switch(
                  value: isDark,
                  onChanged: (_) => ref.read(themeModeProvider.notifier).toggleTheme(),
                  activeColor: AppColors.vibrantAmber,
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              BrandLogo(emoji: category.logoEmoji, title: category.title),
              const SizedBox(height: 48),
              Text(
                category.headline,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w800,
                  fontSize: 32,
                  letterSpacing: -1,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                category.subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  height: 1.6,
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.75),
                ),
              ),
              const SizedBox(height: 48),
              _ActionButton(
                label: 'Take a Selfie',
                icon: Icons.camera_alt_rounded,
                color: AppColors.warmCoral,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CameraCaptureScreen()),
                ),
              ),
              const SizedBox(height: 16),
              _ActionButton(
                label: 'Upload Photo',
                icon: Icons.photo_library_rounded,
                color: AppColors.jungleGreen,
                onTap: () => _pickImage(ImageSource.gallery),
              ),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.06),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'How It Works',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _StepItem(number: '1', text: 'Snap a selfie or upload a photo'),
                    _StepItem(number: '2', text: 'Our AI analyzes your traits'),
                    _StepItem(
                        number: '3',
                        text: 'Discover your ${category.noun.toLowerCase()} match!'),
                  ],
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

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 24),
        label: Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 6,
          shadowColor: color.withOpacity(0.35),
        ),
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String number;
  final String text;

  const _StepItem({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.vibrantAmber.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppColors.vibrantAmber,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.85),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
