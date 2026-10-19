import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_categories.dart';

final selectedCategoryProvider =
    StateNotifierProvider<CategoryNotifier, String>((ref) {
  return CategoryNotifier();
});

final selectedCategoryDataProvider = Provider<CategoryData>((ref) {
  final id = ref.watch(selectedCategoryProvider);
  return AppCategories.byId(id);
});

class CategoryNotifier extends StateNotifier<String> {
  CategoryNotifier() : super('animal') {
    _load();
  }

  static const String _key = 'selectedCategory';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved != null && AppCategories.all.any((c) => c.id == saved)) {
      state = saved;
    }
  }

  Future<void> select(String id) async {
    if (!AppCategories.all.any((c) => c.id == id)) return;
    state = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, id);
  }
}
