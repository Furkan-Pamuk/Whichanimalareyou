import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../scan/presentation/scan_screen.dart';
import '../../../../core/theme/app_colors.dart';

class CameraCaptureScreen extends ConsumerStatefulWidget {
  final Widget Function(String imagePath)? nextScreen;

  const CameraCaptureScreen({super.key, this.nextScreen});

  @override
  ConsumerState<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends ConsumerState<CameraCaptureScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isReady = false;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initCamera());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No camera found', style: GoogleFonts.inter()),
              backgroundColor: AppColors.warmCoral,
            ),
          );
          Navigator.pop(context);
        }
        return;
      }
      final front = _cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      );
      _controller = CameraController(
        front,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      await _controller!.initialize();
      if (!mounted) return;
      setState(() => _isReady = true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Camera initialization failed', style: GoogleFonts.inter()),
            backgroundColor: AppColors.warmCoral,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  Future<void> _takePicture() async {
    if (!_isReady || _isCapturing || _controller == null) return;
    setState(() => _isCapturing = true);
    try {
      final image = await _controller!.takePicture();
      if (!mounted) return;
      final filePath = image.path;
      final next = widget.nextScreen?.call(filePath);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => next ?? ScanScreen(imagePath: filePath)),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to capture photo', style: GoogleFonts.inter()),
            backgroundColor: AppColors.warmCoral,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_isReady && _controller != null)
            SizedBox.expand(
              child: CameraPreview(_controller!),
            )
          else
            Container(
              color: const Color(0xFF0D0D14),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: AppColors.vibrantAmber),
                    const SizedBox(height: 16),
                    Text(
                      'Starting camera...',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Top safe area with back/close
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black54,
                    radius: 20,
                    child: IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                      iconSize: 20,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.black54,
                    radius: 20,
                    child: IconButton(
                      icon: const Icon(Icons.flip_camera_android_rounded, color: Colors.white),
                      iconSize: 20,
                      onPressed: () async {
                        if (_controller == null || _cameras.length < 2) return;
                        final current = _controller!.description;
                        final other = _cameras.firstWhere(
                          (c) => c != current,
                          orElse: () => current,
                        );
                        await _controller?.dispose();
                        _controller = CameraController(
                          other,
                          ResolutionPreset.high,
                          enableAudio: false,
                        );
                        await _controller!.initialize();
                        if (!mounted) return;
                        setState(() => _isReady = true);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Capture button
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _isReady && !_isCapturing ? _takePicture : null,
                child: AnimatedScale(
                  scale: _isCapturing ? 0.8 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      color: _isCapturing ? Colors.grey : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.warmCoral.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: _isCapturing
                        ? const CircularProgressIndicator(
                            color: AppColors.warmCoral,
                            strokeWidth: 3,
                          )
                        : Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.warmCoral,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
