import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../home/presentation/camera_screen.dart';
import '../../scan/presentation/scan_screen.dart';
import '../providers/roots_provider.dart';
import 'roots_result_screen.dart';

/// Opens the DNA Roots Map flow: pick a photo, scan it,
/// then show the fun ancestry breakdown.
Future<void> startRootsFlow(BuildContext context) async {
  final picker = ImagePicker();
  await showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Find Your Roots',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Take a selfie or upload a photo to reveal your fun roots map.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 14),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CameraCaptureScreen(
                          nextScreen: (path) =>
                              _rootsScanScreen(path),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.camera_alt_rounded),
                  label: const Text('Take a Selfie'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    Navigator.pop(sheetContext);
                    try {
                      final file = await picker.pickImage(
                        source: ImageSource.gallery,
                        maxWidth: 1200,
                        maxHeight: 1200,
                        imageQuality: 85,
                      );
                      if (file != null && context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                _rootsScanScreen(file.path),
                          ),
                        );
                      }
                    } catch (_) {
                      // Permission or picker errors are silently ignored here;
                      // the user simply stays on the current screen.
                    }
                  },
                  icon: const Icon(Icons.photo_library_rounded),
                  label: const Text('Upload Photo'),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    },
  );
}

Widget _rootsScanScreen(String imagePath) {
  return ScanScreen(
    imagePath: imagePath,
    rootsMode: true,
    onStart: (ref) =>
        ref.read(rootsProvider.notifier).startAnalysis(imagePath),
    onAnalyze: (ref) =>
        ref.read(rootsProvider.notifier).completeAnalysis(),
    resultScreen: const RootsResultScreen(),
  );
}
