import 'package:flutter/material.dart';

import 'database_helper.dart';
import 'recipe.dart';

class RecipeFormScreen extends StatefulWidget {
  final Recipe? recipe; // null = add, not null = edit
  const RecipeFormScreen({super.key, this.recipe});

  @override
  State<RecipeFormScreen> createState() => _RecipeFormScreenState();
}

class _RecipeFormScreenState extends State<RecipeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _time;
  late final TextEditingController _ingredients;
  late final TextEditingController _steps;
  late String _category;
  late String _meal;
  late String _difficulty;

  bool get _isEdit => widget.recipe != null;

  @override
  void initState() {
    super.initState();
    final r = widget.recipe;
    _name = TextEditingController(text: r?.name ?? '');
    _time = TextEditingController(text: r?.cookingTime.toString() ?? '');
    _ingredients = TextEditingController(text: r?.ingredients ?? '');
    _steps = TextEditingController(text: r?.steps ?? '');
    _category = r?.category ?? kCategories.first;
    _meal = r?.mealType ?? kMeals.first;
    _difficulty = r?.difficulty ?? kDifficulties.first;
  }

  @override
  void dispose() {
    _name.dispose();
    _time.dispose();
    _ingredients.dispose();
    _steps.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final recipe = Recipe(
      id: widget.recipe?.id,
      name: _name.text.trim(),
      ingredients: _ingredients.text.trim(),
      cookingTime: int.parse(_time.text.trim()),
      category: _category,
      mealType: _meal,
      difficulty: _difficulty,
      steps: _steps.text.trim(),
      isFavorite: widget.recipe?.isFavorite ?? false,
      isPredefined: widget.recipe?.isPredefined ?? false,
    );

    if (_isEdit) {
      await DatabaseHelper.instance.updateRecipe(recipe);
    } else {
      await DatabaseHelper.instance.insertRecipe(recipe);
    }
    if (!mounted) return;
    Navigator.pop(context, _isEdit ? 'updated' : 'added');
  }

  String? _required(String? v, String label) =>
      (v == null || v.trim().isEmpty) ? 'Please enter $label' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Recipe' : 'Add Recipe')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Recipe name',
                prefixIcon: Icon(Icons.restaurant_menu),
                border: OutlineInputBorder(),
              ),
              validator: (v) => _required(v, 'a recipe name'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _time,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cooking time (minutes)',
                prefixIcon: Icon(Icons.timer),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final n = int.tryParse((v ?? '').trim());
                if (n == null || n <= 0) return 'Enter a valid time in minutes';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(
                labelText: 'Veg / Non-veg',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: kCategories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _meal,
              decoration: const InputDecoration(
                labelText: 'Meal type',
                prefixIcon: Icon(Icons.restaurant),
                border: OutlineInputBorder(),
              ),
              items: kMeals
                  .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                  .toList(),
              onChanged: (v) => setState(() => _meal = v!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _difficulty,
              decoration: const InputDecoration(
                labelText: 'Difficulty',
                prefixIcon: Icon(Icons.speed),
                border: OutlineInputBorder(),
              ),
              items: kDifficulties
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (v) => setState(() => _difficulty = v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ingredients,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Ingredients (one per line)',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              validator: (v) => _required(v, 'the ingredients'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _steps,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Steps (one per line)',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              validator: (v) => _required(v, 'the cooking steps'),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: Text(_isEdit ? 'Update Recipe' : 'Save Recipe'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
