import 'package:flutter_riverpod/flutter_riverpod.dart';

final scanMessageProvider = StateNotifierProvider<ScanMessageNotifier, String>((ref) {
  return ScanMessageNotifier();
});

final loadingMessages = [
  'Scanning facial structure...',
  'Analyzing wild instincts...',
  'Calculating animal aura...',
  'Finding your animal match...',
  'Reading instinct patterns...',
  'Matching primal energy...',
];

class ScanMessageNotifier extends StateNotifier<String> {
  ScanMessageNotifier() : super(loadingMessages[0]);

  void cycleMessages() {
    final currentIndex = loadingMessages.indexOf(state);
    final nextIndex = (currentIndex + 1) % loadingMessages.length;
    state = loadingMessages[nextIndex];
  }
}
