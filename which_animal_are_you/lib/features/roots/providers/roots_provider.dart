import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rootsProvider =
    StateNotifierProvider<RootsNotifier, RootsState>((ref) {
  return RootsNotifier();
});

class RegionShare {
  final String name;
  final String emoji;
  final String description;
  final String colorCode;
  final int percent;

  const RegionShare({
    required this.name,
    required this.emoji,
    required this.description,
    required this.colorCode,
    this.percent = 0,
  });

  RegionShare withPercent(int value) {
    return RegionShare(
      name: name,
      emoji: emoji,
      description: description,
      colorCode: colorCode,
      percent: value,
    );
  }
}

class RootsState {
  final bool isLoading;
  final String imagePath;
  final List<RegionShare> breakdown;
  final RegionShare? topRegion;

  RootsState({
    this.isLoading = false,
    this.imagePath = '',
    this.breakdown = const [],
    this.topRegion,
  });
}

class RootsNotifier extends StateNotifier<RootsState> {
  RootsNotifier() : super(RootsState());

  static const List<RegionShare> regions = [
    RegionShare(
      name: 'Mediterranean',
      emoji: '🇮🇹',
      description:
          'Sun-kissed and passionate, your roots carry olive groves, ancient ruins and endless seaside dinners.',
      colorCode: '#FB8C00',
    ),
    RegionShare(
      name: 'Nordic',
      emoji: '🇸🇪',
      description:
          'Calm and resilient, your blood remembers fjords, northern lights and quiet strength in long winters.',
      colorCode: '#42A5F5',
    ),
    RegionShare(
      name: 'Middle Eastern',
      emoji: '🇹🇷',
      description:
          'Warm and hospitable, your heritage blends bazaars, spices and stories told over sweet tea.',
      colorCode: '#E53935',
    ),
    RegionShare(
      name: 'East Asian',
      emoji: '🇯🇵',
      description:
          'Graceful and disciplined, your roots honor cherry blossoms, ancient wisdom and quiet precision.',
      colorCode: '#EC407A',
    ),
    RegionShare(
      name: 'Latin American',
      emoji: '🇧🇷',
      description:
          'Rhythmic and joyful, your ancestry dances to samba drums with carnival colors in its veins.',
      colorCode: '#00C853',
    ),
    RegionShare(
      name: 'African',
      emoji: '🌍',
      description:
          'Deep and powerful, your roots drum with the heartbeat of humanity itself. Rhythm is your first language.',
      colorCode: '#F9A825',
    ),
    RegionShare(
      name: 'Eastern European',
      emoji: '🏰',
      description:
          'Soulful and enduring, your heritage carries folk songs, snowy castles and unbreakable spirit.',
      colorCode: '#7E57C2',
    ),
    RegionShare(
      name: 'Celtic',
      emoji: '☘️',
      description:
          'Mystical and poetic, your blood remembers green hills, ancient legends and a touch of magic.',
      colorCode: '#2E7D32',
    ),
  ];

  void startAnalysis(String imagePath) {
    state = RootsState(isLoading: true, imagePath: imagePath);
  }

  Future<void> completeAnalysis() async {
    await Future.delayed(const Duration(seconds: 3));
    // Seeded by photo so the same selfie always gives the same map.
    final random = Random(state.imagePath.hashCode);
    final weights =
        regions.map((_) => 0.3 + random.nextDouble() * 2.2).toList();
    final total = weights.fold<double>(0, (sum, w) => sum + w);

    var assigned = 0;
    final shares = <RegionShare>[];
    for (var i = 0; i < regions.length; i++) {
      var percent = ((weights[i] / total) * 100).round();
      if (i == regions.length - 1) {
        percent = 100 - assigned;
      }
      assigned += percent;
      shares.add(regions[i].withPercent(percent));
    }
    shares.sort((a, b) => b.percent.compareTo(a.percent));

    state = RootsState(
      isLoading: false,
      imagePath: state.imagePath,
      breakdown: shares,
      topRegion: shares.first,
    );
  }

  void reset() {
    state = RootsState();
  }
}
