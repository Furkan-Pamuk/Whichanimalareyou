class AnimalArchetypes {
  static const List<AnimalData> animals = [
    AnimalData(
      name: 'Lone Wolf',
      emoji: '🐺',
      description: 'You are independent, fiercely loyal, and thrive when leading the pack. Your instincts are sharp, and you navigate life with confident solitude.',
      traits: ['Leader', 'Independent', 'Loyal', 'Intuitive'],
      colorCode: '#5C6BC0',
    ),
    AnimalData(
      name: 'Wise Owl',
      emoji: '🦉',
      description: 'Observant and contemplative, you see what others miss. Your calm wisdom shines in the quiet hours, guiding others with gentle insight.',
      traits: ['Wise', 'Calm', 'Analytical', 'Nocturnal'],
      colorCode: '#78909C',
    ),
    AnimalData(
      name: 'Playful Fox',
      emoji: '🦊',
      description: 'Quick-witted and charming, you navigate challenges with playful agility. Your adaptability makes you a natural at turning obstacles into adventures.',
      traits: ['Agile', 'Clever', 'Social', 'Adaptable'],
      colorCode: '#EF5350',
    ),
    AnimalData(
      name: 'Lazy Cat',
      emoji: '🐱',
      description: 'Graceful and selective, you value comfort and independence. Your calm presence brings warmth, and you choose your company wisely.',
      traits: ['Graceful', 'Selective', 'Calm', 'Affectionate'],
      colorCode: '#AB47BC',
    ),
    AnimalData(
      name: 'Sleepy Sloth',
      emoji: '🦥',
      description: 'Unhurried and deeply present, you remind the world to slow down. Your peaceful energy is a rare gift in a fast-moving world.',
      traits: ['Calm', 'Deep', 'Unhurried', 'Warm'],
      colorCode: '#8D6E63',
    ),
    AnimalData(
      name: 'Bold Eagle',
      emoji: '🦅',
      description: 'Visionary and ambitious, you soar above the ordinary with clarity. Your focus is unmatched, and you always aim for the highest peak.',
      traits: ['Visionary', 'Focused', 'Ambitious', 'Bold'],
      colorCode: '#FFB300',
    ),
    AnimalData(
      name: 'Social Dolphin',
      emoji: '🐬',
      description: 'Joyful and empathetic, you bring light wherever you swim. Your emotional intelligence connects you effortlessly with the hearts around you.',
      traits: ['Joyful', 'Empathetic', 'Social', 'Intuitive'],
      colorCode: '#26C6DA',
    ),
  ];
}

class AnimalData {
  final String name;
  final String emoji;
  final String description;
  final List<String> traits;
  final String colorCode;

  const AnimalData({
    required this.name,
    required this.emoji,
    required this.description,
    required this.traits,
    required this.colorCode,
  });
}
