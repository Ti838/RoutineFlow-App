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
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            title: Text(days[index],
                style: const TextStyle(fontWeight: FontWeight.bold)),
            children: [
              ListTile(
                leading: const Icon(Icons.school, color: Colors.blue),
                title: const Text('Data Structures'),
                subtitle: const Text('10:00 AM - 11:30 AM • Room 402'),
              ),
              ListTile(
                leading: const Icon(Icons.science, color: Colors.green),
                title: const Text('Physics Lab'),
                subtitle: const Text('1:00 PM - 3:00 PM • Lab 2'),
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
            '12 Days Left', Colors.red),
        _buildExamCard(
            'Quiz: Algorithms', 'Oct 05, 2026', '2 Days Left', Colors.orange),
      ],
    );
  }

  Widget _buildExamCard(
      String title, String date, String countdown, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(date),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Text(
            countdown,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
