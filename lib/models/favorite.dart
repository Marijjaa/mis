class Favorite {
  final String id;
  final String mealId;
  final String mealName;
  final String mealThumb;
  final DateTime addedAt;

  Favorite({
    required this.id,
    required this.mealId,
    required this.mealName,
    required this.mealThumb,
    required this.addedAt,
  });

  factory Favorite.fromFirestore(Map<String, dynamic> data, String id) {
    return Favorite(
      id: id,
      mealId: data['mealId'] ?? '',
      mealName: data['mealName'] ?? '',
      mealThumb: data['mealThumb'] ?? '',
      addedAt: DateTime.parse(data['addedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'mealId': mealId,
      'mealName': mealName,
      'mealThumb': mealThumb,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}