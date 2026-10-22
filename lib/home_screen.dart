import 'package:flutter/material.dart';

import 'database_helper.dart';
import 'recipe.dart';
import 'recipe_detail_screen.dart';
import 'recipe_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Recipe> _recipes = [];
  bool _loading = true;

  String _query = '';
  String? _category; // null = All (Veg / Non-veg)
  String? _meal; // null = All meals
  String? _difficulty; // null = Any
  bool _favoritesOnly = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await DatabaseHelper.instance.getRecipes(
      query: _query,
      category: _category,
      mealType: _meal,
      difficulty: _difficulty,
      favoritesOnly: _favoritesOnly,
    );
    if (!mounted) return;
    setState(() {
      _recipes = data;
      _loading = false;
    });
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _addRecipe() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const RecipeFormScreen()),
    );
    if (result == 'added') _snack('Recipe added');
    _load();
  }

  Future<void> _openDetail(Recipe r) async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: r)),
    );
    if (result == 'deleted') _snack('Recipe deleted');
    _load();
  }

  Future<void> _toggleFavorite(Recipe r) async {
    await DatabaseHelper.instance.setFavorite(r.id!, !r.isFavorite);
    _load();
  }

  Future<bool> _confirmDelete(Recipe r) async {
    if (r.isPredefined) {
      _snack('Built-in recipes cannot be deleted');
      return false;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete recipe?'),
        content: Text('"${r.name}" will be removed permanently.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return false;
    await DatabaseHelper.instance.deleteRecipe(r.id!);
    _snack('Recipe deleted');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Book'),
        actions: [
          IconButton(
            tooltip: 'Favorites only',
            icon: Icon(
              _favoritesOnly ? Icons.favorite : Icons.favorite_border,
              color: _favoritesOnly ? Colors.redAccent : null,
            ),
            onPressed: () {
              setState(() => _favoritesOnly = !_favoritesOnly);
              _load();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addRecipe,
        icon: const Icon(Icons.add),
        label: const Text('Add Recipe'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by name or ingredient',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) {
                _query = v;
                _load();
              },
            ),
          ),
          // Veg / Non-veg + difficulty
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 0,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: _category == null,
                    onSelected: (_) {
                      setState(() => _category = null);
                      _load();
                    },
                  ),
                  for (final c in kCategories)
                    ChoiceChip(
                      avatar: Icon(categoryIcon(c),
                          size: 16, color: categoryColor(c)),
                      label: Text(c),
                      selected: _category == c,
                      onSelected: (_) {
                        setState(() => _category = c);
                        _load();
                      },
                    ),
                  DropdownButton<String?>(
                    value: _difficulty,
                    hint: const Text('Difficulty'),
                    underline: const SizedBox.shrink(),
                    items: [
                      const DropdownMenuItem<String?>(
                          value: null, child: Text('Any difficulty')),
                      for (final d in kDifficulties)
                        DropdownMenuItem<String?>(value: d, child: Text(d)),
                    ],
                    onChanged: (v) {
                      setState(() => _difficulty = v);
                      _load();
                    },
                  ),
                ],
              ),
            ),
          ),
          // Meal types (all visible, wraps on small screens)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 0,
                children: [
                  ChoiceChip(
                    label: const Text('All meals'),
                    selected: _meal == null,
                    onSelected: (_) {
                      setState(() => _meal = null);
                      _load();
                    },
                  ),
                  for (final m in kMeals)
                    ChoiceChip(
                      avatar: Icon(mealIcon(m), size: 16),
                      label: Text(m),
                      selected: _meal == m,
                      onSelected: (_) {
                        setState(() => _meal = m);
                        _load();
                      },
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Divider(height: 1),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _recipes.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text(
                            'No recipes found.\nTry another filter or add a new recipe.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 90, top: 4),
                        itemCount: _recipes.length,
                        itemBuilder: (context, index) {
                          final r = _recipes[index];
                          final color = categoryColor(r.category);
                          return Dismissible(
                            key: ValueKey(r.id),
                            direction: r.isPredefined
                                ? DismissDirection.none
                                : DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (_) => _confirmDelete(r),
                            onDismissed: (_) => _load(),
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              child: ListTile(
                                onTap: () => _openDetail(r),
                                leading: CircleAvatar(
                                  backgroundColor: color.withAlpha(40),
                                  child: Icon(categoryIcon(r.category),
                                      color: color),
                                ),
                                title: Text(r.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                subtitle: Text(
                                    '${r.category}  •  ${r.mealType}  •  ${r.cookingTime} min  •  ${r.difficulty}'),
                                trailing: IconButton(
                                  icon: Icon(
                                    r.isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: r.isFavorite
                                        ? Colors.redAccent
                                        : null,
                                  ),
                                  onPressed: () => _toggleFavorite(r),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}