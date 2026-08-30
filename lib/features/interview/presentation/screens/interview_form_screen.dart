import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:job_tracker/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:job_tracker/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:job_tracker/features/interview/presentation/bloc/interview_bloc.dart';
import 'package:job_tracker/features/interview/presentation/bloc/interview_event.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/date_extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/responsive_scaffold.dart';
import '../../domain/entities/interview_entity.dart';
import '../../domain/usecases/create_interview_usecase.dart';
import '../../domain/usecases/update_interview_usecase.dart';

class InterviewFormScreen extends StatefulWidget {
  final String applicationId;
  final InterviewEntity? interview;

  const InterviewFormScreen({
    super.key,
    required this.applicationId,
    this.interview,
  });

  @override
  State<InterviewFormScreen> createState() => _InterviewFormScreenState();
}

class _InterviewFormScreenState extends State<InterviewFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _selectedType;
  late DateTime _scheduledAt;
  late final TextEditingController _durationController;
  late final TextEditingController _locationController;
  late final TextEditingController _meetingUrlController;
  late final TextEditingController _notesController;
  bool _isSubmitting = false;

  bool get isEditMode => widget.interview != null;

  @override
  void initState() {
    super.initState();
    final item = widget.interview;

    _selectedType = item?.type ?? 'SCREENING';
    _scheduledAt =
        item?.scheduledAt ?? DateTime.now().add(const Duration(days: 2));
    _durationController = TextEditingController(
      text: item?.durationMinutes != null ? item!.durationMinutes.toString() : '45',
    );
    _locationController = TextEditingController(text: item?.location ?? '');
    _meetingUrlController = TextEditingController(text: item?.meetingUrl ?? '');
    _notesController = TextEditingController(text: item?.notes ?? '');
  }

  @override
  void dispose() {
    _durationController.dispose();
    _locationController.dispose();
    _meetingUrlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledAt,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_scheduledAt),
      );

      if (time != null && mounted) {
        setState(() {
          _scheduledAt = DateTime(
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

    final duration = int.tryParse(_durationController.text.trim()) ?? 45;

    if (isEditMode) {
      final updateUseCase = GetIt.I<UpdateInterviewUseCase>();
      final result = await updateUseCase(
        UpdateInterviewParams(
          id: widget.interview!.id,
          type: _selectedType,
          scheduledAt: _scheduledAt,
          durationMinutes: duration,
          location: _locationController.text.trim().isNotEmpty
              ? _locationController.text.trim()
              : null,
          meetingUrl: _meetingUrlController.text.trim().isNotEmpty
              ? _meetingUrlController.text.trim()
              : null,
          notes: _notesController.text.trim().isNotEmpty
              ? _notesController.text.trim()
              : null,
        ),
      );

      if (mounted) {
        setState(() => _isSubmitting = false);
        result.fold(
          (failure) => context.showSnackBar(failure.message, isError: true),
          (_) {
            try {
              context.read<InterviewBloc>().add(LoadInterviewsForAppEvent(widget.applicationId));
            } catch (_) {}
            context.read<DashboardBloc>().add(const LoadDashboardDataEvent(refresh: true));
            context.showSnackBar('Interview round updated!');
            context.pop(true);
          },
        );
      }
    } else {
      final createUseCase = GetIt.I<CreateInterviewUseCase>();
      final result = await createUseCase(
        CreateInterviewParams(
          applicationId: widget.applicationId,
          type: _selectedType,
          scheduledAt: _scheduledAt,
          durationMinutes: duration,
          location: _locationController.text.trim().isNotEmpty
              ? _locationController.text.trim()
              : null,
          meetingUrl: _meetingUrlController.text.trim().isNotEmpty
              ? _meetingUrlController.text.trim()
              : null,
          notes: _notesController.text.trim().isNotEmpty
              ? _notesController.text.trim()
              : null,
        ),
      );

      if (mounted) {
        setState(() => _isSubmitting = false);
        result.fold(
          (failure) => context.showSnackBar(failure.message, isError: true),
          (_) {
            try {
              context.read<InterviewBloc>().add(LoadInterviewsForAppEvent(widget.applicationId));
            } catch (_) {}
            context.read<DashboardBloc>().add(const LoadDashboardDataEvent(refresh: true));
            context.showSnackBar('Interview scheduled successfully!');
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
        title: Text(isEditMode ? 'Edit Interview' : 'Schedule Interview'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Round Type
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Interview Type / Round *',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedType,
                    items: AppConstants.interviewTypes.map((t) {
                      return DropdownMenuItem(
                        value: t,
                        child: Text(t, style: const TextStyle(fontSize: 13)),
                      );
                    }).toList(),
                    onChanged: _isSubmitting
                        ? null
                        : (val) {
                            if (val != null) {
                              setState(() => _selectedType = val);
                            }
                          },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Scheduled Date & Time
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Scheduled Date & Time *',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: _isSubmitting ? null : _selectDateTime,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        suffixIcon: Icon(Icons.event_rounded, size: 20),
                      ),
                      child: Text(
                        _scheduledAt.toDateTimeString(),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                controller: _durationController,
                labelText: 'Duration (Minutes) *',
                hintText: '45',
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.timer_outlined, size: 20),
                validator: Validators.number,
                enabled: !_isSubmitting,
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                controller: _locationController,
                labelText: 'Location / Platform',
                hintText: 'e.g. Google Meet, Zoom, Onsite (NY HQ)',
                prefixIcon: const Icon(Icons.location_on_outlined, size: 20),
                enabled: !_isSubmitting,
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                controller: _meetingUrlController,
                labelText: 'Meeting URL',
                hintText: 'https://meet.google.com/xyz-abc-123',
                prefixIcon: const Icon(Icons.link_rounded, size: 20),
                validator: Validators.url,
                enabled: !_isSubmitting,
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                controller: _notesController,
                labelText: 'Preparation Notes & Questions',
                hintText: 'Review System Design, behavioral stories...',
                maxLines: 3,
                enabled: !_isSubmitting,
              ),
              const SizedBox(height: 28),
              AppButton(
                text: isEditMode ? 'Update Interview' : 'Schedule Interview',
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
