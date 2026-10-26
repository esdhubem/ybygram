class FoodItem {
  final String name;
  final int calories;
  final String portion;
  final String category;

  const FoodItem({
    required this.name,
    required this.calories,
    required this.portion,
    required this.category,
  });
}

class HealthHabitsState {
  double waterLiters; // Meta: ex. 2.0 L
  double sleepHours;  // Meta: ex. 8.0 h
  int studyMinutes;   // Meta: ex. 30 min
  int walkMinutes;    // Meta: ex. 30 min
  int caloriesBurned; // Calculado a partir de caminhada/exercícios
  int caloriesConsumed;
  int healthPoints;   // Pontos acumulados para cupons

  HealthHabitsState({
    this.waterLiters = 1.5,
    this.sleepHours = 7.5,
    this.studyMinutes = 25,
    this.walkMinutes = 30,
    this.caloriesBurned = 180,
    this.caloriesConsumed = 1650,
    this.healthPoints = 420,
  });

  // 1 minuto de caminhada moderada queima aprox 4 a 5 calorias
  void updateWalkMinutes(int minutes) {
    walkMinutes = minutes;
    caloriesBurned = minutes * 5;
    healthPoints += (minutes ~/ 10) * 5;
  }

  void addWaterGlass() {
    waterLiters += 0.25;
    healthPoints += 5;
  }

  void addFoodCalories(int cal) {
    caloriesConsumed += cal;
  }
}
