import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UniversityScreen extends ConsumerWidget {
  const UniversityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
          ),
          title: const Text('Academic Suite'),
          backgroundColor: colors.surface,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Timetable'),
              Tab(text: 'Exams'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _TimetableView(),
            _ExamsView(),
          ],
        ),
      ),
    );
  }
}

class _TimetableView extends StatelessWidget {
  const _TimetableView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
        final colors = [
          const Color(0xFFFFB3D4),
          const Color(0xFFD4C2FF),
          const Color(0xFFE4F9F6),
          const Color(0xFFFFF7E0),
          const Color(0xFFFFD3A8),
        ];

        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: colors[index % colors.length],
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.black, width: 3),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                offset: Offset(4, 4),
                spreadRadius: 0,
                blurRadius: 0,
              )
            ],
          ),
          child: ExpansionTile(
            shape: const Border(),
            collapsedShape: const Border(),
            title: Text(days[index],
                style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: Colors.black)),
            children: [
              Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: ListTile(
                  leading:
                      const Icon(Icons.school, color: Colors.black, size: 32),
                  title: const Text('Data Structures',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  subtitle: const Text('10:00 AM - 11:30 AM • Room 402',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.black54)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ExamsView extends StatelessWidget {
  const _ExamsView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildExamCard('Midterm: Data Structures', 'Oct 15, 2026',
            '12 Days Left', const Color(0xFFFF6B6B)),
        _buildExamCard('Quiz: Algorithms', 'Oct 05, 2026', '2 Days Left',
            const Color(0xFFFFD464)),
      ],
    );
  }

  Widget _buildExamCard(
      String title, String date, String countdown, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(4, 4),
            spreadRadius: 0,
            blurRadius: 0,
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: Colors.black)),
        subtitle: Text(date,
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.black54)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Text(
            countdown,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
