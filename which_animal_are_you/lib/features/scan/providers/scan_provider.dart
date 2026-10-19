import 'package:flutter_riverpod/flutter_riverpod.dart';

final scanMessageProvider =
    StateNotifierProvider<ScanMessageNotifier, String>((ref) {
  return ScanMessageNotifier(loadingMessages);
});

final rootsMessageProvider =
    StateNotifierProvider<ScanMessageNotifier, String>((ref) {
  return ScanMessageNotifier(rootsLoadingMessages);
});

final loadingMessages = [
  'Scanning facial structure...',
  'Analyzing wild instincts...',
  'Calculating animal aura...',
  'Finding your animal match...',
  'Reading instinct patterns...',
  'Matching primal energy...',
];

final rootsLoadingMessages = [
  'Scanning facial structure...',
  'Analyzing heritage markers...',
  'Tracing ancient migration routes...',
  'Calculating origin blend...',
  'Reading ancestry patterns...',
  'Drawing your roots map...',
];

class ScanMessageNotifier extends StateNotifier<String> {
  final List<String> messages;

  ScanMessageNotifier(this.messages) : super(messages[0]);

  void cycleMessages() {
    final currentIndex = messages.indexOf(state);
    final nextIndex = (currentIndex + 1) % messages.length;
    state = messages[nextIndex];
  }
}
