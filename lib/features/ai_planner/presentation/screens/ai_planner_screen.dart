import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/services/ai_planner_service.dart';

class AiPlannerScreen extends ConsumerStatefulWidget {
  const AiPlannerScreen({super.key});

  @override
  ConsumerState<AiPlannerScreen> createState() => _AiPlannerScreenState();
}

class _AiPlannerScreenState extends ConsumerState<AiPlannerScreen> {
  bool _isAnalyzing = false;
  String _result = '';

  Future<void> _analyzeRoutine() async {
    setState(() => _isAnalyzing = true);

    try {
      final aiService = ref.read(aiPlannerServiceProvider);
      // Simulate picking an image and sending to Gemini
      final extractedData =
          await aiService.extractRoutineFromImage('dummy_path.jpg');

      setState(() => _result = extractedData);
    } finally {
      setState(() => _isAnalyzing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1EBFF), // Soft Lavender
      appBar: AppBar(
        title: const Text('AI Routine Scanner',
            style: TextStyle(fontWeight: FontWeight.w900)),
        backgroundColor: const Color(0xFFF1EBFF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(4, 4),
                  )
                ],
              ),
              child: const Icon(Icons.document_scanner,
                  size: 80, color: Colors.black),
            ),
            const SizedBox(height: 32),
            const Text(
              'Upload a photo of your class schedule, and Gemini AI will automatically parse and add it to your timeline.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _isAnalyzing ? null : _analyzeRoutine,
              icon: _isAnalyzing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.black))
                  : const Icon(Icons.camera_alt, color: Colors.black),
              label: Text(_isAnalyzing ? 'Analyzing...' : 'Scan Routine',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF94C1),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999)),
                side: const BorderSide(color: Colors.black, width: 3),
                elevation: 0,
              ).copyWith(
                  shadowColor: WidgetStateProperty.all(Colors.transparent)),
            ),
            const SizedBox(height: 32),
            if (_result.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF7DE2D1),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.black, width: 3),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(4, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Success!',
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            fontSize: 20)),
                    const SizedBox(height: 8),
                    Text(_result,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
