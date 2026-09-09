import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/models/activity_category.dart';
import '../../../../shared/models/priority.dart';
import '../../../../shared/models/recurrence_type.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../domain/models/activity.dart';
import '../providers/activity_provider.dart';

class CreateEditActivitySheet extends ConsumerStatefulWidget {
  final Activity? activityToEdit;
  final DateTime? defaultDate;

  const CreateEditActivitySheet({super.key, this.activityToEdit, this.defaultDate});

  static Future<void> show(BuildContext context, {Activity? activityToEdit, DateTime? defaultDate}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateEditActivitySheet(
        activityToEdit: activityToEdit,
        defaultDate: defaultDate,
      ),
    );
  }

  @override
  ConsumerState<CreateEditActivitySheet> createState() => _CreateEditActivitySheetState();
}

class _CreateEditActivitySheetState extends ConsumerState<CreateEditActivitySheet> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _locationController;
  late TextEditingController _notesController;

  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late ActivityCategory _category;
  late Priority _priority;
  late RecurrenceType _recurrence;
  late int _reminderMinutes;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final edit = widget.activityToEdit;
    _titleController = TextEditingController(text: edit?.title ?? '');
    _descController = TextEditingController(text: edit?.description ?? '');
    _locationController = TextEditingController(text: edit?.location ?? '');
    _notesController = TextEditingController(text: edit?.notes ?? '');

    _selectedDate = edit?.date ?? widget.defaultDate ?? DateTime.now();
    _startTime = edit != null ? _parseTime(edit.startTime) : const TimeOfDay(hour: 9, minute: 0);
    _endTime = edit != null ? _parseTime(edit.endTime) : const TimeOfDay(hour: 10, minute: 30);
    _category = edit?.category ?? ActivityCategory.study;
    _priority = edit?.priority ?? Priority.medium;
    _recurrence = edit?.recurrence ?? RecurrenceType.none;
    _reminderMinutes = edit?.reminderMinutes ?? 15;
  }

  TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 9,
      minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0,
    );
  }

  String _formatTime(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveActivity() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an activity title')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final startMinutes = _startTime.hour * 60 + _startTime.minute;
    final endMinutes = _endTime.hour * 60 + _endTime.minute;
    final duration = endMinutes > startMinutes ? endMinutes - startMinutes : 60;

    final activity = Activity(
      id: widget.activityToEdit?.id ?? const Uuid().v4(),
      userId: widget.activityToEdit?.userId ?? 'user_1',
      title: _titleController.text.trim(),
      description: _descController.text.trim().isNotEmpty ? _descController.text.trim() : null,
      date: _selectedDate,
      startTime: _formatTime(_startTime),
      endTime: _formatTime(_endTime),
      durationMinutes: duration,
      location: _locationController.text.trim().isNotEmpty ? _locationController.text.trim() : null,
      category: _category,
      priority: _priority,
      status: widget.activityToEdit?.status ?? ActivityStatus.pending,
      recurrence: _recurrence,
      reminderMinutes: _reminderMinutes,
      notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
      createdAt: widget.activityToEdit?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (widget.activityToEdit != null) {
      await ref.read(activityNotifierProvider.notifier).updateActivity(activity);
    } else {
      await ref.read(activityNotifierProvider.notifier).addActivity(activity);
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.activityToEdit != null ? 'Edit Activity' : 'Quick Add Activity',
                  style: AppTypography.heading3,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                CustomTextField(
                  controller: _titleController,
                  label: 'Activity Title',
                  hint: 'e.g., Study Data Structures & Algorithms',
                  prefixIcon: Icons.edit_note,
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime.now().subtract(const Duration(days: 365)),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null) setState(() => _selectedDate = picked);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).dividerColor),
                            borderRadius: AppRadius.radiusMd,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Date', style: AppTypography.small.copyWith(color: AppColors.textSecondaryLight)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
                                  const SizedBox(width: 6),
                                  Text('${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}', style: AppTypography.bodyMedium),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final picked = await showTimePicker(context: context, initialTime: _startTime);
                          if (picked != null) setState(() => _startTime = picked);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).dividerColor),
                            borderRadius: AppRadius.radiusMd,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Start Time', style: AppTypography.small.copyWith(color: AppColors.textSecondaryLight)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 16, color: AppColors.primary),
                                  const SizedBox(width: 6),
                                  Text(_formatTime(_startTime), style: AppTypography.bodyMedium),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final picked = await showTimePicker(context: context, initialTime: _endTime);
                          if (picked != null) setState(() => _endTime = picked);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).dividerColor),
                            borderRadius: AppRadius.radiusMd,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('End Time', style: AppTypography.small.copyWith(color: AppColors.textSecondaryLight)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.access_time_filled, size: 16, color: AppColors.primary),
                                  const SizedBox(width: 6),
                                  Text(_formatTime(_endTime), style: AppTypography.bodyMedium),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Category', style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ActivityCategory.values.map((cat) {
                    final selected = _category == cat;
                    return ChoiceChip(
                      label: Text(cat.label),
                      selected: selected,
                      selectedColor: AppColors.primaryContainer,
                      onSelected: (val) => setState(() => _category = cat),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Priority', style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: Priority.values.map((p) {
                    final selected = _priority == p;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(p.label),
                        selected: selected,
                        selectedColor: AppColors.primaryContainer,
                        onSelected: (val) => setState(() => _priority = p),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Recurrence', style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                DropdownButtonFormField<RecurrenceType>(
                  initialValue: _recurrence,
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.repeat)),
                  items: RecurrenceType.values.map((r) => DropdownMenuItem(value: r, child: Text(r.label))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _recurrence = val);
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                CustomTextField(
                  controller: _locationController,
                  label: 'Location (Optional)',
                  hint: 'e.g., Room 402 / Library',
                  prefixIcon: Icons.location_on_outlined,
                ),
                const SizedBox(height: AppSpacing.lg),
                CustomTextField(
                  controller: _descController,
                  label: 'Description & Notes (Optional)',
                  hint: 'Add reminders, objectives or reference links',
                  maxLines: 3,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: PrimaryButton(
              text: widget.activityToEdit != null ? 'Save Changes' : 'Create Activity',
              isLoading: _isLoading,
              onPressed: _saveActivity,
            ),
          ),
        ],
      ),
    );
  }
}
