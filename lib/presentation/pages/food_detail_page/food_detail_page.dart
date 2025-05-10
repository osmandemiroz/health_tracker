import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:calory_tool/core/providers/favorite_provider.dart';
import 'package:calory_tool/data/models/foods/food_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@RoutePage()
class FoodDetailPage extends StatefulWidget {
  const FoodDetailPage({required this.foodModel, super.key});

  final FoodModel foodModel;

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => context.router.popForced(),
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    Text(
                      widget.foodModel.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<FavoritesProvider>().toogleFavoriteFood(
                          widget.foodModel,
                        );
                      },
                      icon: Icon(
                        context.watch<FavoritesProvider>().foods.any(
                              (e) => e.id == widget.foodModel.id,
                            )
                            ? Icons.favorite
                            : Icons.favorite_outline,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Yemek Resmi
                if (widget.foodModel.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: widget.foodModel.imageUrl!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget:
                          (context, error, stackTrace) => Container(
                            height: 200,
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.restaurant,
                              size: 64,
                              color: Colors.grey[600],
                            ),
                          ),
                    ),
                  ),

                const SizedBox(height: 24),

                // Kategori
                Text(
                  'Kategori: ${widget.foodModel.category}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 16),

                // Besin Değerleri
                const Text(
                  'Besin Değerleri',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildNutritionRow(
                  'Kalori',
                  '${widget.foodModel.calories.toInt()} kcal',
                ),
                _buildNutritionRow(
                  'Protein',
                  '${widget.foodModel.protein.toStringAsFixed(1)} g',
                ),
                _buildNutritionRow(
                  'Karbonhidrat',
                  '${widget.foodModel.carbohydrates.toStringAsFixed(1)} g',
                ),
                _buildNutritionRow(
                  'Yağ',
                  '${widget.foodModel.fat.toStringAsFixed(1)} g',
                ),
                if (widget.foodModel.dietaryFiber != null)
                  _buildNutritionRow(
                    'Lif',
                    '${widget.foodModel.dietaryFiber!.toStringAsFixed(1)} g',
                  ),

                const SizedBox(height: 24),

                // Hazırlama Bilgileri
                if (widget.foodModel.prepTime != null ||
                    widget.foodModel.cookTime != null ||
                    widget.foodModel.totalTime != null) ...[
                  const Text(
                    'Hazırlama Bilgileri',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (widget.foodModel.prepTime != null)
                    _buildTimeRow(
                      'Hazırlama Süresi',
                      '${widget.foodModel.prepTime} dk',
                    ),
                  if (widget.foodModel.cookTime != null)
                    _buildTimeRow(
                      'Pişirme Süresi',
                      '${widget.foodModel.cookTime} dk',
                    ),
                  if (widget.foodModel.totalTime != null)
                    _buildTimeRow(
                      'Toplam Süre',
                      '${widget.foodModel.totalTime} dk',
                    ),
                ],

                if (widget.foodModel.servingSize != null) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Porsiyon Bilgisi',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.foodModel.servingSize!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.timer_outlined, size: 20),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
