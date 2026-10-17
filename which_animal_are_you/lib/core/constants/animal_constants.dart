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
    AnimalData(
      name: 'Majestic Lion',
      emoji: '🦁',
      description: 'Bold and magnetic, you walk in like you own the savanna. People follow your energy because you lead with heart and courage.',
      traits: ['Brave', 'Leader', 'Charismatic', 'Protective'],
      colorCode: '#F9A825',
    ),
    AnimalData(
      name: 'Fierce Tiger',
      emoji: '🐯',
      description: 'Powerful and focused, you move in silence and strike with precision. Your determination turns wild dreams into reality.',
      traits: ['Strong', 'Focused', 'Determined', 'Fearless'],
      colorCode: '#FB8C00',
    ),
    AnimalData(
      name: 'Chill Panda',
      emoji: '🐼',
      description: 'Easygoing and lovable, you master the art of relaxing. Your cozy vibe makes everyone feel safe, calm and happy around you.',
      traits: ['Chill', 'Friendly', 'Peaceful', 'Lovable'],
      colorCode: '#616161',
    ),
    AnimalData(
      name: 'Cuddly Koala',
      emoji: '🐨',
      description: 'Sweet and sleepy, you hug life tightly. You are the cozy friend everyone wants, full of warmth, naps and quiet kindness.',
      traits: ['Sweet', 'Calm', 'Cuddly', 'Gentle'],
      colorCode: '#78909C',
    ),
    AnimalData(
      name: 'Swift Rabbit',
      emoji: '🐰',
      description: 'Quick, curious and full of bounce. You hop into new adventures first and your playful energy is simply contagious.',
      traits: ['Quick', 'Curious', 'Playful', 'Energetic'],
      colorCode: '#EC407A',
    ),
    AnimalData(
      name: 'Happy Penguin',
      emoji: '🐧',
      description: 'Charming and loyal, you waddle through life with style. You are social, funny and you always stick with your flock.',
      traits: ['Loyal', 'Funny', 'Social', 'Stylish'],
      colorCode: '#42A5F5',
    ),
    AnimalData(
      name: 'Strong Bear',
      emoji: '🐻',
      description: 'Warm but mighty, you protect the ones you love. Behind your calm look there is huge strength and a giant soft heart.',
      traits: ['Strong', 'Warm', 'Protective', 'Honest'],
      colorCode: '#795548',
    ),
    AnimalData(
      name: 'Clever Monkey',
      emoji: '🐵',
      description: 'Witty, social and a little mischievous. You turn any boring moment into fun and your clever ideas always steal the show.',
      traits: ['Witty', 'Funny', 'Social', 'Creative'],
      colorCode: '#8D6E63',
    ),
    AnimalData(
      name: 'Calm Turtle',
      emoji: '🐢',
      description: 'Patient and wise, you win the race slowly. While others rush, you stay steady, thoughtful and always finish strong.',
      traits: ['Patient', 'Wise', 'Steady', 'Thoughtful'],
      colorCode: '#43A047',
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
