class FoodSearchParams {
  const FoodSearchParams({required this.query});

  final String query;

  Map<String, dynamic> toMap() {
    return {'query': query};
  }
}
