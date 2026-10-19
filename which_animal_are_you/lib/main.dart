import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';
import 'features/home/presentation/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: WhichAnimalApp()));
}

class WhichAnimalApp extends ConsumerWidget {
  const WhichAnimalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'Which One Are You?',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}
