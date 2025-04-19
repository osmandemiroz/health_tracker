import 'package:calory_tool/presentation/screens/goal/goal_creation_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calory_tool/core/providers/goal_provider.dart';
import 'package:calory_tool/core/providers/user_provider.dart';
import 'package:calory_tool/data/models/goal/goal_model.dart';
import 'package:intl/intl.dart';

/// A screen for displaying and managing goals
///
/// Follows Apple's Human Interface Guidelines with a clean, minimalist design,
/// proper spacing, and intuitive controls. Features a segmented control to
/// switch between active and completed goals.
class GoalListScreen extends StatefulWidget {
  const GoalListScreen({Key? key}) : super(key: key);

  @override
  State<GoalListScreen> createState() => _GoalListScreenState();
}

class _GoalListScreenState extends State<GoalListScreen> {
  bool _showingActiveGoals = true;

  @override
  void initState() {
    super.initState();
    _refreshGoals();
  }

  Future<void> _refreshGoals() async {
    final userProvider = context.read<UserProvider>();
    final goalProvider = context.read<GoalProvider>();
    final currentUser = userProvider.currentUser;

    if (currentUser != null) {
      await goalProvider.init(currentUser.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Goals',
          style: TextStyle(
            color: CupertinoColors.label,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          CupertinoButton(
            child: const Icon(
              CupertinoIcons.add,
              color: CupertinoColors.activeBlue,
            ),
            onPressed: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => const GoalCreationScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSegmentedControl(),
          Expanded(
            child: Consumer<GoalProvider>(
              builder: (context, goalProvider, child) {
                if (goalProvider.isLoading) {
                  return const Center(child: CupertinoActivityIndicator());
                }

                if (goalProvider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${goalProvider.errorMessage}',
                          style: const TextStyle(
                            color: CupertinoColors.destructiveRed,
                          ),
                        ),
                        const SizedBox(height: 16),
                        CupertinoButton(
                          child: const Text('Try Again'),
                          onPressed: _refreshGoals,
                        ),
                      ],
                    ),
                  );
                }

                final goals =
                    _showingActiveGoals
                        ? goalProvider.activeGoals
                        : goalProvider.completedGoals;

                if (goals.isEmpty) {
                  return Center(
                    child: Text(
                      _showingActiveGoals
                          ? 'No active goals\nTap + to create a new goal'
                          : 'No completed goals yet',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refreshGoals,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: goals.length,
                    itemBuilder: (context, index) {
                      return _buildGoalCard(goals[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CupertinoSlidingSegmentedControl<bool>(
        backgroundColor: CupertinoColors.systemFill,
        thumbColor: CupertinoColors.systemBackground,
        groupValue: _showingActiveGoals,
        children: const {
          true: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Active'),
          ),
          false: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Completed'),
          ),
        },
        onValueChanged: (value) {
          if (value != null) {
            setState(() {
              _showingActiveGoals = value;
            });
          }
        },
      ),
    );
  }

  Widget _buildGoalCard(GoalModel goal) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final progress = (goal.currentProgress * 100).round();
    final daysLeft = goal.endDate.difference(DateTime.now()).inDays;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CupertinoContextMenu(
        actions: [
          CupertinoContextMenuAction(
            child: const Text('Update Progress'),
            onPressed: () {
              Navigator.pop(context);
              _showProgressUpdateDialog(goal);
            },
          ),
          CupertinoContextMenuAction(
            isDestructiveAction: true,
            child: const Text('Delete'),
            onPressed: () {
              Navigator.pop(context);
              _showDeleteConfirmation(goal);
            },
          ),
        ],
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: CupertinoColors.activeBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      goal.goalType,
                      style: TextStyle(
                        color: CupertinoColors.activeBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$progress%',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: goal.currentProgress,
                backgroundColor: CupertinoColors.systemFill,
                valueColor: AlwaysStoppedAnimation<Color>(
                  CupertinoColors.activeBlue,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Target Calories',
                        style: TextStyle(
                          color: CupertinoColors.secondaryLabel,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${goal.targetCalories} kcal',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  if (!_showingActiveGoals)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Completed',
                          style: TextStyle(
                            color: CupertinoColors.secondaryLabel,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          dateFormat.format(
                            goal.lastUpdatedDate ?? goal.endDate,
                          ),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Days Left',
                          style: TextStyle(
                            color: CupertinoColors.secondaryLabel,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          daysLeft > 0 ? '$daysLeft days' : 'Due today',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                daysLeft <= 3
                                    ? CupertinoColors.systemOrange
                                    : null,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              if (goal.notes != null && goal.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  goal.notes!,
                  style: const TextStyle(
                    color: CupertinoColors.secondaryLabel,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showProgressUpdateDialog(GoalModel goal) {
    final currentProgress = (goal.currentProgress * 100).round();
    var newProgress = currentProgress;

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Update Progress'),
          content: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.minus_circle),
                    onPressed: () {
                      setState(() {
                        if (newProgress > 0) newProgress -= 5;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  Text('$newProgress%', style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.plus_circle),
                    onPressed: () {
                      setState(() {
                        if (newProgress < 100) newProgress += 5;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoDialogAction(
              child: const Text('Update'),
              onPressed: () {
                Navigator.of(context).pop();
                context.read<GoalProvider>().updateGoalProgress(
                  goal.gid,
                  newProgress / 100,
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(GoalModel goal) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Delete Goal'),
          content: Text(
            'Are you sure you want to delete this ${goal.goalType} goal? This action cannot be undone.',
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                context.read<GoalProvider>().deleteGoal(goal.gid);
              },
            ),
          ],
        );
      },
    );
  }
}
