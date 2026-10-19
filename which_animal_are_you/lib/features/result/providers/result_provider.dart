import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/animal_constants.dart';

final resultProvider = StateNotifierProvider<ResultNotifier, ResultState>((ref) {
  return ResultNotifier();
});

class ResultState {
  final bool isLoading;
  final AnimalData? matchedAnimal;
  final int matchPercentage;
  final String selectedImagePath;

  ResultState({
    this.isLoading = false,
    this.matchedAnimal,
    this.matchPercentage = 0,
    this.selectedImagePath = '',
  });

  ResultState copyWith({
    bool? isLoading,
    AnimalData? matchedAnimal,
    int? matchPercentage,
    String? selectedImagePath,
  }) {
    return ResultState(
      isLoading: isLoading ?? this.isLoading,
      matchedAnimal: matchedAnimal ?? this.matchedAnimal,
      matchPercentage: matchPercentage ?? this.matchPercentage,
      selectedImagePath: selectedImagePath ?? this.selectedImagePath,
    );
  }
}

class ResultNotifier extends StateNotifier<ResultState> {
  ResultNotifier() : super(ResultState());

  void startAnalysis(String imagePath) {
    state = ResultState(
      isLoading: true,
      selectedImagePath: imagePath,
    );
  }

  Future<void> completeAnalysis({List<AnimalData>? pool}) async {
    await Future.delayed(const Duration(seconds: 3));
    final list =
        (pool != null && pool.isNotEmpty) ? pool : AnimalArchetypes.animals;
    final animal = _generateMatch(list);
    final score = Random().nextInt(35) + 65; // 65 - 99%
    state = ResultState(
      isLoading: false,
      matchedAnimal: animal,
      matchPercentage: score,
      selectedImagePath: state.selectedImagePath,
    );
  }

  AnimalData _generateMatch(List<AnimalData> animals) {
    final random = Random();
    return animals[random.nextInt(animals.length)];
  }

  void reset() {
    state = ResultState();
  }
}
