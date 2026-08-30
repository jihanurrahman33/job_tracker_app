import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/date_extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/responsive_scaffold.dart';
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
    final rem = widget.reminder;

    _titleController = TextEditingController(
      text: rem?.title ?? widget.initialTitle ?? '',
    );
    _descriptionController = TextEditingController(text: rem?.description ?? '');
    _remindAt = rem?.remindAt ?? DateTime.now().add(const Duration(days: 2));
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
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_remindAt),
      );

      if (time != null) {
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
                validator: (val) => Validators.requiredField(val, 'Title is required'),
                enabled: !_isSubmitting,
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Remind At *',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: _isSubmitting ? null : _selectDateTime,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        suffixIcon: Icon(Icons.access_time_rounded, size: 20),
                      ),
                      child: Text(
                        _remindAt.toDateTimeString(),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                controller: _descriptionController,
                labelText: 'Notes / Description',
                hintText: 'Add context, email drafted, or specific questions to ask...',
                maxLines: 4,
                enabled: !_isSubmitting,
              ),
              const SizedBox(height: 28),
              AppButton(
                text: isEditMode ? 'Save Changes' : 'Create Reminder',
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
