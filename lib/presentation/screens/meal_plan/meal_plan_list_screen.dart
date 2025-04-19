import 'package:calory_tool/core/providers/meal_plan_provider.dart';
import 'package:calory_tool/core/providers/user_provider.dart';
import 'package:calory_tool/data/models/meal_plan/meal_plan_model.dart';
import 'package:calory_tool/enum/planned_meals_enum.dart';
import 'package:calory_tool/presentation/screens/meal_plan/meal_plan_creation_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// A screen that displays a list of meal plans
class MealPlanListScreen extends StatefulWidget {
  const MealPlanListScreen({super.key});

  @override
  State<MealPlanListScreen> createState() => _MealPlanListScreenState();
}

class _MealPlanListScreenState extends State<MealPlanListScreen> {
  final _dateFormat = DateFormat('MMMM d, y');
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _refreshMealPlans();
  }

  Future<void> _refreshMealPlans() async {
    final userProvider = context.read<UserProvider>();
    final currentUser = userProvider.currentUser;
    if (currentUser != null) {
      await context.read<MealPlanProvider>().fetchUserMealPlans(
        currentUser.uid,
      );
    }
  }

  void _showDeleteConfirmation(BuildContext context, MealPlanModel mealPlan) {
    showCupertinoDialog(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
            title: const Text('Delete Meal Plan'),
            content: const Text(
              'Are you sure you want to delete this meal plan?',
            ),
            actions: [
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () async {
                  Navigator.of(context).pop();
                  await context.read<MealPlanProvider>().deleteMealPlan(
                    mealPlan.id,
                  );
                },
                child: const Text('Delete'),
              ),
              CupertinoDialogAction(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Meal Plans'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add),
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => const MealPlanCreationScreen(),
              ),
            );
          },
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Date Selector
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.left_chevron),
                    onPressed: () {
                      setState(() {
                        _selectedDate = _selectedDate.subtract(
                          const Duration(days: 1),
                        );
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      _dateFormat.format(_selectedDate),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.right_chevron),
                    onPressed: () {
                      setState(() {
                        _selectedDate = _selectedDate.add(
                          const Duration(days: 1),
                        );
                      });
                    },
                  ),
                ],
              ),
            ),

            // Meal Plans List
            Expanded(
              child: Consumer<MealPlanProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CupertinoActivityIndicator());
                  }

                  if (provider.errorMessage != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error: ${provider.errorMessage}',
                            style: const TextStyle(
                              color: CupertinoColors.destructiveRed,
                            ),
                          ),
                          const SizedBox(height: 16),
                          CupertinoButton(
                            child: const Text('Try Again'),
                            onPressed: _refreshMealPlans,
                          ),
                        ],
                      ),
                    );
                  }

                  final mealPlans =
                      provider.userMealPlans
                          .where(
                            (plan) =>
                                plan.date.year == _selectedDate.year &&
                                plan.date.month == _selectedDate.month &&
                                plan.date.day == _selectedDate.day,
                          )
                          .toList();

                  if (mealPlans.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'No meal plans for this date',
                            style: TextStyle(
                              color: CupertinoColors.secondaryLabel,
                            ),
                          ),
                          const SizedBox(height: 16),
                          CupertinoButton.filled(
                            child: const Text('Create Meal Plan'),
                            onPressed: () {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder:
                                      (context) =>
                                          const MealPlanCreationScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  return CustomScrollView(
                    slivers: [
                      CupertinoSliverRefreshControl(
                        onRefresh: _refreshMealPlans,
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final mealPlan = mealPlans[index];
                          return _buildMealPlanCard(mealPlan);
                        }, childCount: mealPlans.length),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealPlanCard(MealPlanModel mealPlan) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    mealPlan.name ?? 'Meal Plan',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(
                    CupertinoIcons.delete,
                    color: CupertinoColors.destructiveRed,
                  ),
                  onPressed: () => _showDeleteConfirmation(context, mealPlan),
                ),
              ],
            ),
          ),

          // Meal Types
          ...PlannedMealsEnum.values.map((mealType) {
            final recipes = mealPlan.meals[mealType] ?? [];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mealType.displayName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                  if (recipes.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'No recipes added',
                        style: TextStyle(
                          color: CupertinoColors.tertiaryLabel,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(child: Text(recipes[index])),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: const Icon(
                                  CupertinoIcons.minus_circle,
                                  color: CupertinoColors.systemRed,
                                  size: 20,
                                ),
                                onPressed: () {
                                  context
                                      .read<MealPlanProvider>()
                                      .removeRecipeFromMealPlan(
                                        mealPlan.id,
                                        mealType,
                                        recipes[index],
                                      );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            );
          }),

          // Notes
          if (mealPlan.notes?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                mealPlan.notes!,
                style: const TextStyle(
                  color: CupertinoColors.secondaryLabel,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
