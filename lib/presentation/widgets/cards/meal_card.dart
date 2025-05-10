import 'package:cached_network_image/cached_network_image.dart';
import 'package:calory_tool/core/providers/food_provider.dart';
import 'package:calory_tool/data/models/foods/food_model.dart';
import 'package:calory_tool/enum/planned_meals_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MealCard extends StatefulWidget {
  const MealCard({
    required this.plannedMeal,
    required this.foods,
    required this.date,
    this.onAddPressed,
    super.key,
  });

  final PlannedMealsEnum plannedMeal;
  final List<FoodModel> foods;
  final DateTime date;
  final VoidCallback? onAddPressed;

  @override
  State<MealCard> createState() => MealCardState();
}

class MealCardState extends State<MealCard> {
  bool _expandedMeals = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            onTap: () {
              setState(() {
                _expandedMeals = !_expandedMeals;
              });
            },
            title: Text(
              widget.plannedMeal.displayName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Cal: ${widget.foods.map((e) => e.calories * e.amount).fold<double>(0, (a, b) => a + b).toStringAsFixed(0)} kcal',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    _expandedMeals ? Icons.expand_less : Icons.expand_more,
                  ),
                  onPressed: () {
                    setState(() {
                      _expandedMeals = !_expandedMeals;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: widget.onAddPressed,
                ),
              ],
            ),
          ),
          if (_expandedMeals)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.foods.length,
              itemBuilder: (context, index) {
                final food = widget.foods[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child:
                        food.imageUrl != null
                            ? CachedNetworkImage(
                              imageUrl: food.imageUrl!,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorWidget:
                                  (context, error, stackTrace) =>
                                      _buildPlaceholder(),
                            )
                            : _buildPlaceholder(),
                  ),
                  title: Text(
                    food.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kalori: ${(food.calories * food.amount).toStringAsFixed(0)} kcal',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      Text(
                        'Protein: ${(food.protein * food.amount).toStringAsFixed(1)}g • Karb: ${(food.carbohydrates * food.amount).toStringAsFixed(1)}g • Yağ: ${(food.fat * food.amount).toStringAsFixed(1)}g',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      context.read<FoodProvider>().removeSevenDaysFood(
                        food.id,
                        widget.plannedMeal,
                        widget.date,
                      );
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 48,
      height: 48,
      color: Colors.grey[300],
      child: Icon(Icons.restaurant, size: 24, color: Colors.grey[600]),
    );
  }
}
