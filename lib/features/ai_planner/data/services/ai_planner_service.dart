import 'package:flutter_riverpod/flutter_riverpod.dart';

class AiPlannerService {
  Future<String> extractRoutineFromImage(String imagePath) async {
    // This is a placeholder for the actual Gemini API call
    // In production, you would use the google_generative_ai package
    // e.g., final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

    await Future.delayed(const Duration(seconds: 2)); // Simulate API delay

    return '''
    Detected Routine:
    - Monday 10:00 AM: Data Structures (Room 402)
    - Wednesday 1:00 PM: Physics Lab (Lab 2)
    ''';
  }
}

final aiPlannerServiceProvider = Provider<AiPlannerService>((ref) {
  return AiPlannerService();
});
