import 'recipe.dart';

String _l(List<String> lines) => lines.join('\n');

/// Extra built-in recipes for the new meal sections.
final List<Recipe> moreRecipes = [
  // ---------- Breakfast ----------
  Recipe(
    name: 'Poha',
    category: 'Veg',
    mealType: 'Breakfast',
    difficulty: 'Easy',
    cookingTime: 15,
    isPredefined: true,
    ingredients: _l(['2 cups thick poha (flattened rice)', '1 onion, chopped', '1 potato, small cubes', '1 tsp mustard seeds', '1/2 tsp turmeric', 'Curry leaves', '2 tbsp peanuts', '1 tbsp lemon juice', '2 tbsp oil', 'Salt to taste']),
    steps: _l(['Rinse the poha in water and drain well; keep it aside for 5 minutes.', 'Heat oil, add mustard seeds, peanuts and curry leaves.', 'Add the onion and potato and cook until soft.', 'Add turmeric and salt, then mix in the poha gently.', 'Cook for 2 minutes, add lemon juice and serve hot.']),
  ),
  Recipe(
    name: 'Aloo Paratha',
    category: 'Veg',
    mealType: 'Breakfast',
    difficulty: 'Medium',
    cookingTime: 40,
    isPredefined: true,
    ingredients: _l(['2 cups wheat flour', '3 boiled potatoes, mashed', '1 tsp red chilli powder', '1 tsp cumin powder', 'Chopped coriander', 'Oil or ghee for cooking', 'Salt to taste']),
    steps: _l(['Knead the flour with water and salt into a soft dough.', 'Mix the mashed potato with chilli powder, cumin, coriander and salt.', 'Roll a dough ball, place a spoon of filling inside and seal it.', 'Roll it out gently into a round paratha.', 'Cook on a hot pan with ghee until golden on both sides.']),
  ),
  Recipe(
    name: 'Boiled Egg Sandwich',
    category: 'Non-veg',
    mealType: 'Breakfast',
    difficulty: 'Easy',
    cookingTime: 15,
    isPredefined: true,
    ingredients: _l(['2 boiled eggs, sliced', '4 bread slices', '1 tbsp butter', 'Salt and pepper', 'A few cucumber slices']),
    steps: _l(['Boil the eggs for 10 minutes, cool and slice them.', 'Butter the bread slices.', 'Place the egg and cucumber on one slice and sprinkle salt and pepper.', 'Cover with the other slice and toast lightly.', 'Cut and serve.']),
  ),

  // ---------- Lunch / Meals ----------
  Recipe(
    name: 'Curd Rice',
    category: 'Veg',
    mealType: 'Lunch/Meals',
    difficulty: 'Easy',
    cookingTime: 15,
    isPredefined: true,
    ingredients: _l(['2 cups cooked rice (soft)', '1 1/2 cups curd', '1/2 cup milk', '1 tsp mustard seeds', '1 green chilli', 'Curry leaves', '1 tsp oil', 'Salt to taste']),
    steps: _l(['Mash the warm rice lightly with a spoon.', 'Mix in the curd, milk and salt.', 'Heat oil and splutter the mustard seeds with chilli and curry leaves.', 'Pour this over the rice and mix.', 'Serve cool with pickle.']),
  ),
  Recipe(
    name: 'Jeera Rice',
    category: 'Veg',
    mealType: 'Lunch/Meals',
    difficulty: 'Easy',
    cookingTime: 25,
    isPredefined: true,
    ingredients: _l(['1 cup basmati rice', '1 tsp cumin seeds', '1 tbsp ghee', '2 cups water', 'Salt to taste']),
    steps: _l(['Wash the rice and soak it for 15 minutes.', 'Heat ghee and add the cumin seeds.', 'Add the drained rice and fry for a minute.', 'Add the water and salt, cover and cook until done.', 'Fluff with a fork and serve with dal.']),
  ),

  // ---------- Snacks ----------
  Recipe(
    name: 'Onion Pakoda',
    category: 'Veg',
    mealType: 'Snacks',
    difficulty: 'Medium',
    cookingTime: 25,
    isPredefined: true,
    ingredients: _l(['2 onions, thinly sliced', '1/2 cup besan (gram flour)', '2 tbsp rice flour', '1 tsp red chilli powder', '1 green chilli, chopped', 'Curry leaves', 'Oil for frying', 'Salt to taste']),
    steps: _l(['Mix the onions with salt and let them rest for 5 minutes.', 'Add besan, rice flour, chilli powder, green chilli and curry leaves.', 'Sprinkle a little water and mix into a thick, crumbly batter.', 'Heat oil and drop small portions of the batter.', 'Fry on medium heat until golden and crisp, then drain.']),
  ),
  Recipe(
    name: 'Masala Corn',
    category: 'Veg',
    mealType: 'Snacks',
    difficulty: 'Easy',
    cookingTime: 10,
    isPredefined: true,
    ingredients: _l(['1 cup sweet corn kernels', '1 tbsp butter', '1/2 tsp chaat masala', '1/2 tsp red chilli powder', '1 tsp lemon juice', 'Salt to taste']),
    steps: _l(['Boil the corn for 5 minutes and drain.', 'Melt butter in a pan and add the corn.', 'Add chilli powder, chaat masala and salt.', 'Toss for 2 minutes.', 'Add lemon juice and serve hot.']),
  ),
  Recipe(
    name: 'Egg Bhurji',
    category: 'Non-veg',
    mealType: 'Snacks',
    difficulty: 'Easy',
    cookingTime: 15,
    isPredefined: true,
    ingredients: _l(['3 eggs', '1 onion, chopped', '1 tomato, chopped', '1 green chilli, chopped', '1/2 tsp turmeric', '1/2 tsp red chilli powder', '1 tbsp oil', 'Salt to taste']),
    steps: _l(['Heat oil and fry the onion and green chilli until soft.', 'Add the tomato, turmeric, chilli powder and salt; cook for 2 minutes.', 'Break the eggs into the pan.', 'Stir continuously until the eggs are scrambled and cooked.', 'Serve with bread or roti.']),
  ),

  // ---------- Drinks & Juices ----------
  Recipe(
    name: 'Mango Lassi',
    category: 'Veg',
    mealType: 'Drinks & Juices',
    difficulty: 'Easy',
    cookingTime: 5,
    isPredefined: true,
    ingredients: _l(['1 ripe mango, chopped', '1 cup curd', '2 tbsp sugar', '1/2 cup cold milk', 'A few ice cubes']),
    steps: _l(['Add the mango, curd, sugar and milk to a blender.', 'Blend until smooth.', 'Add ice cubes and blend for a few seconds.', 'Pour into a glass and serve chilled.']),
  ),
  Recipe(
    name: 'Banana Milkshake',
    category: 'Veg',
    mealType: 'Drinks & Juices',
    difficulty: 'Easy',
    cookingTime: 5,
    isPredefined: true,
    ingredients: _l(['2 ripe bananas', '2 cups cold milk', '2 tbsp sugar', 'A few ice cubes']),
    steps: _l(['Peel and slice the bananas.', 'Add the bananas, milk and sugar to a blender.', 'Blend until smooth and creamy.', 'Serve chilled with ice.']),
  ),
  Recipe(
    name: 'Cold Coffee',
    category: 'Veg',
    mealType: 'Drinks & Juices',
    difficulty: 'Easy',
    cookingTime: 5,
    isPredefined: true,
    ingredients: _l(['1 tbsp instant coffee powder', '2 tbsp sugar', '2 cups cold milk', 'A few ice cubes', '1 scoop vanilla ice cream (optional)']),
    steps: _l(['Add the coffee powder, sugar and a little milk to a blender and blend.', 'Add the remaining milk and ice cubes.', 'Blend until frothy.', 'Pour into a glass and top with ice cream if you like.']),
  ),
  Recipe(
    name: 'Lemon Mint Cooler',
    category: 'Veg',
    mealType: 'Drinks & Juices',
    difficulty: 'Easy',
    cookingTime: 5,
    isPredefined: true,
    ingredients: _l(['2 lemons, juiced', '10 mint leaves', '3 tbsp sugar', '2 glasses cold water', 'A pinch of salt', 'Ice cubes']),
    steps: _l(['Crush the mint leaves with the sugar in a jug.', 'Add the lemon juice, salt and cold water.', 'Stir until the sugar dissolves.', 'Add ice cubes and serve.']),
  ),

  // ---------- Dessert ----------
  Recipe(
    name: 'Rice Kheer',
    category: 'Veg',
    mealType: 'Dessert',
    difficulty: 'Medium',
    cookingTime: 45,
    isPredefined: true,
    ingredients: _l(['1/4 cup rice', '1 litre milk', '1/2 cup sugar', '2 cardamom pods, crushed', 'Cashews and raisins', '1 tsp ghee']),
    steps: _l(['Wash the rice and soak it for 20 minutes.', 'Boil the milk in a heavy pan.', 'Add the rice and cook on low heat, stirring often, until soft.', 'Add the sugar and cardamom and simmer for 5 minutes.', 'Fry cashews and raisins in ghee, add them to the kheer and serve warm or chilled.']),
  ),
];