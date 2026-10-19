import 'animal_constants.dart';
import 'flower_constants.dart';

class CategoryData {
  final String id;
  final String title;
  final String headline;
  final String subtitle;
  final String logoEmoji;
  final String noun;
  final String colorCode;
  final List<AnimalData> items;

  const CategoryData({
    required this.id,
    required this.title,
    required this.headline,
    required this.subtitle,
    required this.logoEmoji,
    required this.noun,
    required this.colorCode,
    required this.items,
  });
}

class AppCategories {
  static const List<CategoryData> all = [
    CategoryData(
      id: 'animal',
      title: 'Which Animal Are You?',
      headline: 'Discover Your Inner Wild!',
      subtitle:
          'Capture a selfie or upload your photo to reveal your animal counterpart with a fun personality score.',
      logoEmoji: '🐾',
      noun: 'Animal',
      colorCode: '#2E7D32',
      items: AnimalArchetypes.animals,
    ),
    CategoryData(
      id: 'flower',
      title: 'Which Flower Are You?',
      headline: 'Discover Your Inner Bloom!',
      subtitle:
          'Capture a selfie or upload your photo to reveal your flower counterpart with a fun personality score.',
      logoEmoji: '🌸',
      noun: 'Flower',
      colorCode: '#EC407A',
      items: FlowerArchetypes.flowers,
    ),
  ];

  static CategoryData byId(String id) {
    return all.firstWhere(
      (c) => c.id == id,
      orElse: () => all.first,
    );
  }
}
