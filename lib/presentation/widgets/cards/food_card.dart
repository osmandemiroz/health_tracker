import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:calory_tool/core/configs/theme/i_app_theme.dart';
import 'package:calory_tool/core/providers/favorite_provider.dart';
import 'package:calory_tool/core/providers/food_provider.dart';
import 'package:calory_tool/core/router/app_router.dart';
import 'package:calory_tool/data/models/foods/food_model.dart';
import 'package:calory_tool/enum/planned_meals_enum.dart';
import 'package:flutter/material.dart';
import 'package:penta_core/penta_core.dart';
import 'package:provider/provider.dart';

class FoodCard extends StatelessWidget {
  const FoodCard({required this.foodModel, super.key});

  final FoodModel foodModel;

  @override
  Widget build(BuildContext context) {
    final theme = context.ext.theme;
    final colors = context.appThemeExt.appColors;
    final isFavorite = context.watch<FavoritesProvider>().foods.any(
      (e) => e.id == foodModel.id,
    );

    return GestureDetector(
      onTap: () {
        context.router.push(FoodDetailRoute(foodModel: foodModel));
      },
      child: Card(
        color: theme.isDark ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            spacing: 12,
            children: [
              // Yemek Resmi
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                    foodModel.imageUrl != null
                        ? CachedNetworkImage(
                          imageUrl: foodModel.imageUrl!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorWidget:
                              (context, error, stackTrace) =>
                                  _buildPlaceholder(),
                        )
                        : _buildPlaceholder(),
              ),

              // Yemek Bilgileri
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      foodModel.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.isDark ? Colors.white : Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      foodModel.category,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          size: 16,
                          color: Colors.orange[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${foodModel.calories.toInt()} kcal',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.orange[700],
                          ),
                        ),
                        if (foodModel.prepTime != null) ...[
                          const SizedBox(width: 12),
                          Icon(
                            Icons.timer_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${foodModel.prepTime} dk',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Aksiyon Butonları
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.read<FavoritesProvider>().toogleFavoriteFood(
                        foodModel,
                      );
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey.withValues(alpha: 0.1),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_outline,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final mealType = await showModalBottomSheet<
                        PlannedMealsEnum
                      >(
                        context: context,
                        builder: (context) {
                          return SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children:
                                  PlannedMealsEnum.values
                                      .map(
                                        (e) => ListTile(
                                          title: Text(
                                            e.displayName,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          trailing: const Icon(
                                            Icons.chevron_right,
                                          ),
                                          onTap:
                                              () => context.router.popForced(e),
                                        ),
                                      )
                                      .toList(),
                            ),
                          );
                        },
                      );

                      if (mealType != null && context.mounted) {
                        await context.read<FoodProvider>().addSevenDaysFood(
                          foodModel,
                          mealType,
                        );
                      }
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: colors.primary,
                      child: Icon(
                        Icons.add,
                        color: colors.primary.onColor,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      color: Colors.grey[300],
      child: Icon(Icons.restaurant, size: 32, color: Colors.grey[600]),
    );
  }
}
