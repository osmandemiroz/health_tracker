import 'package:auto_route/auto_route.dart';
import 'package:calory_tool/core/providers/food_provider.dart';
import 'package:calory_tool/presentation/widgets/cards/food_card.dart';
import 'package:calory_tool/presentation/widgets/fields/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:penta_core/penta_core.dart';
import 'package:provider/provider.dart';

@RoutePage()
class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  late final PentaDebounceable<void, String> _fetchSuggestions =
      PentaDebouncer.debounce(
        debounceDuration: const Duration(milliseconds: 1000),
        function: (query) async {
          if (_searchText == query) return;
          _searchText = query;

          context.read<FoodProvider>().clearFoods();
          if (query.isEmpty) {
            return;
          }

          await context.read<FoodProvider>().fetchsearchfoods(query);
        },
      );

  @override
  Widget build(BuildContext context) {
    final items =
        context
            .watch<FoodProvider>()
            .foods
            ?.foods
            .where((e) => e.imageUrl != null)
            .toList();

    final isLoading = context.watch<FoodProvider>().isLoading;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search Bar Container with shadow
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: CustomTextField(
                controller: _searchController,
                hintText: 'Yemek ara...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                onChanged: _fetchSuggestions,
              ),
            ),

            // Loading Indicator or Results
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : items == null || items.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchText.isEmpty
                                  ? 'Yemek aramak için yukarıdaki arama çubuğunu kullanın'
                                  : 'Aradığınız yemek bulunamadı',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                      : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        itemCount: items.length,
                        separatorBuilder:
                            (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final food = items[index];
                          return FoodCard(foodModel: food);
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
