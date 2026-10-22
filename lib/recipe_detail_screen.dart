import 'package:flutter/material.dart';

import 'database_helper.dart';
import 'recipe.dart';
import 'recipe_form_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Recipe _recipe;
  bool _changed = false;

  @override
  void initState() {
    super.initState();
    _recipe = widget.recipe;
  }

  Future<void> _toggleFavorite() async {
    final value = !_recipe.isFavorite;
    await DatabaseHelper.instance.setFavorite(_recipe.id!, value);
    setState(() {
      _recipe = _recipe.copyWith(isFavorite: value);
      _changed = true;
    });
  }

  Future<void> _edit() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => RecipeFormScreen(recipe: _recipe)),
    );
    if (result == null) return;
    final fresh = await DatabaseHelper.instance.getRecipes();
    final updated = fresh.firstWhere((r) => r.id == _recipe.id);
    setState(() {
      _recipe = updated;
      _changed = true;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Recipe updated')));
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete recipe?'),
        content: Text('"${_recipe.name}" will be removed permanently.'),
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
    if (ok != true) return;
    await DatabaseHelper.instance.deleteRecipe(_recipe.id!);
    if (!mounted) return;
    Navigator.pop(context, 'deleted');
  }

  List<String> _lines(String text) => text
      .split('\n')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  @override
  Widget build(BuildContext context) {
    final color = categoryColor(_recipe.category);
    final ingredients = _lines(_recipe.ingredients);
    final steps = _lines(_recipe.steps);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.pop(context, _changed ? 'changed' : null);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_recipe.name),
          actions: [
            IconButton(
              tooltip: 'Favorite',
              icon: Icon(
                _recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _recipe.isFavorite ? Colors.redAccent : null,
              ),
              onPressed: _toggleFavorite,
            ),
            IconButton(
                tooltip: 'Edit',
                icon: const Icon(Icons.edit),
                onPressed: _edit),
                       if (!_recipe.isPredefined)
              IconButton(
                  tooltip: 'Delete',
                  icon: const Icon(Icons.delete),
                  onPressed: _delete),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  avatar: Icon(categoryIcon(_recipe.category),
                      size: 18, color: color),
                  label: Text(_recipe.category),
                  backgroundColor: color.withAlpha(40),
                ),
                                Chip(
                  avatar: Icon(mealIcon(_recipe.mealType), size: 18),
                  label: Text(_recipe.mealType),
                ),
                Chip(
                  avatar: const Icon(Icons.timer, size: 18),
                  label: Text('${_recipe.cookingTime} min'),
                ),
                Chip(
                  avatar: const Icon(Icons.speed, size: 18),
                  label: Text(_recipe.difficulty),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Ingredients',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            for (final i in ingredients)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('•  '),
                    Expanded(child: Text(i)),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Text('Steps', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            for (var n = 0; n < steps.length; n++)
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 14,
                    backgroundColor: color,
                    child: Text('${n + 1}',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 13)),
                  ),
                  title: Text(steps[n]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
