import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:job_tracker/core/extensions/context_extensions.dart';
import 'package:job_tracker/core/extensions/date_extensions.dart';
import 'package:job_tracker/core/utils/validators.dart';
import 'package:job_tracker/core/widgets/app_button.dart';
import 'package:job_tracker/core/widgets/app_text_form_field.dart';
import 'package:job_tracker/core/widgets/responsive_scaffold.dart';
import 'package:job_tracker/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:job_tracker/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:job_tracker/features/reminder/presentation/bloc/reminder_bloc.dart';
import 'package:job_tracker/features/reminder/presentation/bloc/reminder_event.dart';
import '../../domain/entities/reminder_entity.dart';
import '../../domain/usecases/create_reminder_usecase.dart';
import '../../domain/usecases/update_reminder_usecase.dart';

class ReminderFormScreen extends StatefulWidget {
  final String? applicationId;
  final String? initialTitle;
  final ReminderEntity? reminder;

  const ReminderFormScreen({
    super.key,
    this.applicationId,
    this.initialTitle,
    this.reminder,
  });

  @override
  State<ReminderFormScreen> createState() => _ReminderFormScreenState();
}

class _ReminderFormScreenState extends State<ReminderFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late DateTime _remindAt;
  bool _isSubmitting = false;

  bool get isEditMode => widget.reminder != null;

  @override
  void initState() {
    super.initState();
    final item = widget.reminder;

    _titleController = TextEditingController(
      text: item?.title ?? widget.initialTitle ?? '',
    );
    _descriptionController =
        TextEditingController(text: item?.description ?? '');
    _remindAt = item?.remindAt ?? DateTime.now().add(const Duration(days: 3));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _remindAt,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_remindAt),
      );

      if (time != null && mounted) {
        setState(() {
          _remindAt = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _submitForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);

    if (isEditMode) {
      final updateUseCase = GetIt.I<UpdateReminderUseCase>();
      final result = await updateUseCase(
        UpdateReminderParams(
          id: widget.reminder!.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isNotEmpty
              ? _descriptionController.text.trim()
              : null,
          remindAt: _remindAt,
        ),
      );

      if (mounted) {
        setState(() => _isSubmitting = false);
        result.fold(
          (failure) => context.showSnackBar(failure.message, isError: true),
          (_) {
            context.read<ReminderBloc>().add(const LoadRemindersEvent(refresh: true));
            context.read<DashboardBloc>().add(const LoadDashboardDataEvent(refresh: true));
            context.showSnackBar('Reminder updated!');
            context.pop(true);
          },
        );
      }
    } else {
      final createUseCase = GetIt.I<CreateReminderUseCase>();
      final result = await createUseCase(
        CreateReminderParams(
          applicationId: widget.applicationId,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isNotEmpty
              ? _descriptionController.text.trim()
              : null,
          remindAt: _remindAt,
        ),
      );

      if (mounted) {
        setState(() => _isSubmitting = false);
        result.fold(
          (failure) => context.showSnackBar(failure.message, isError: true),
          (_) {
            context.read<ReminderBloc>().add(const LoadRemindersEvent(refresh: true));
            context.read<DashboardBloc>().add(const LoadDashboardDataEvent(refresh: true));
            context.showSnackBar('Reminder created!');
            context.pop(true);
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      maxWidth: 600,
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Reminder' : 'New Reminder'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextFormField(
                controller: _titleController,
                labelText: 'Reminder Title *',
                hintText: 'e.g. Follow up on status with recruiter',
                prefixIcon: const Icon(Icons.title_rounded, size: 20),
                validator: (val) =>
                    Validators.requiredField(val, 'Title is required'),
                enabled: !_isSubmitting,
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Due Date & Time *',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: _isSubmitting ? null : _selectDateTime,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        suffixIcon: Icon(Icons.alarm_rounded, size: 20),
                      ),
                      child: Text(
                        _remindAt.toDateTimeString(),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                controller: _descriptionController,
                labelText: 'Description / Notes',
                hintText: 'Additional details or context for this reminder...',
                maxLines: 3,
                enabled: !_isSubmitting,
              ),
              const SizedBox(height: 28),
              AppButton(
                text: isEditMode ? 'Update Reminder' : 'Create Reminder',
                isLoading: _isSubmitting,
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
