import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:job_tracker/features/application/presentation/bloc/application_bloc.dart';
import 'package:job_tracker/features/application/presentation/bloc/application_event.dart';
import 'package:job_tracker/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:job_tracker/features/dashboard/presentation/bloc/dashboard_event.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/date_extensions.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/responsive_scaffold.dart';
import '../../domain/entities/application_entity.dart';
import '../../domain/usecases/create_application_usecase.dart';
import '../../domain/usecases/update_application_usecase.dart';

class ApplicationFormScreen extends StatefulWidget {
  final ApplicationEntity? application;

  const ApplicationFormScreen({super.key, this.application});

  @override
  State<ApplicationFormScreen> createState() => _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _companyController;
  late final TextEditingController _positionController;
  late final TextEditingController _locationController;
  late final TextEditingController _jobUrlController;
  late final TextEditingController _salaryMinController;
  late final TextEditingController _salaryMaxController;
  late final TextEditingController _notesController;

  late String _selectedStatus;
  late String _selectedCurrency;
  DateTime? _appliedAt;
  bool _isSubmitting = false;

  bool get isEditMode => widget.application != null;

  @override
  void initState() {
    super.initState();
    final app = widget.application;

    _companyController = TextEditingController(text: app?.company ?? '');
    _positionController = TextEditingController(text: app?.position ?? '');
    _locationController = TextEditingController(text: app?.location ?? '');
    _jobUrlController = TextEditingController(text: app?.jobUrl ?? '');
    _salaryMinController = TextEditingController(
      text: app?.salaryMin != null ? app!.salaryMin.toString() : '',
    );
    _salaryMaxController = TextEditingController(
      text: app?.salaryMax != null ? app!.salaryMax.toString() : '',
    );
    _notesController = TextEditingController(text: app?.notes ?? '');

    _selectedStatus = app?.status ?? 'APPLIED';
    _selectedCurrency = app?.salaryCurrency ?? 'USD';
    _appliedAt = app?.appliedAt ?? DateTime.now();
  }

  @override
  void dispose() {
    _companyController.dispose();
    _positionController.dispose();
    _locationController.dispose();
    _jobUrlController.dispose();
    _salaryMinController.dispose();
    _salaryMaxController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectAppliedDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _appliedAt ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() => _appliedAt = picked);
    }
  }

  Future<void> _submitForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);

    final minSalary = int.tryParse(_salaryMinController.text.trim());
    final maxSalary = int.tryParse(_salaryMaxController.text.trim());

    if (isEditMode) {
      final updateUseCase = GetIt.I<UpdateApplicationUseCase>();
      final result = await updateUseCase(
        UpdateApplicationParams(
          id: widget.application!.id,
          company: _companyController.text.trim(),
          position: _positionController.text.trim(),
          location: _locationController.text.trim().isNotEmpty
              ? _locationController.text.trim()
              : null,
          jobUrl: _jobUrlController.text.trim().isNotEmpty
              ? _jobUrlController.text.trim()
              : null,
          salaryMin: minSalary,
          salaryMax: maxSalary,
          salaryCurrency: _selectedCurrency,
          status: _selectedStatus,
          appliedAt: _appliedAt,
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
            context
                .read<ApplicationBloc>()
                .add(const LoadApplicationsEvent(refresh: true));
            context
                .read<DashboardBloc>()
                .add(const LoadDashboardDataEvent(refresh: true));
            context.showSnackBar('Application updated successfully!');
            context.pop(true);
          },
        );
      }
    } else {
      final createUseCase = GetIt.I<CreateApplicationUseCase>();
      final result = await createUseCase(
        CreateApplicationParams(
          company: _companyController.text.trim(),
          position: _positionController.text.trim(),
          location: _locationController.text.trim().isNotEmpty
              ? _locationController.text.trim()
              : null,
          jobUrl: _jobUrlController.text.trim().isNotEmpty
              ? _jobUrlController.text.trim()
              : null,
          salaryMin: minSalary,
          salaryMax: maxSalary,
          salaryCurrency: _selectedCurrency,
          status: _selectedStatus,
          appliedAt: _appliedAt,
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
            context
                .read<ApplicationBloc>()
                .add(const LoadApplicationsEvent(refresh: true));
            context
                .read<DashboardBloc>()
                .add(const LoadDashboardDataEvent(refresh: true));
            context.showSnackBar('Application created successfully!');
            context.pop(true);
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      maxWidth: 700,
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Application' : 'New Application'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextFormField(
                controller: _companyController,
                labelText: 'Company Name *',
                hintText: 'e.g. Google, Stripe, Linear',
                prefixIcon: const Icon(Icons.business_outlined, size: 20),
                validator: (val) =>
                    Validators.requiredField(val, 'Company is required'),
                enabled: !_isSubmitting,
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                controller: _positionController,
                labelText: 'Job Title / Position *',
                hintText: 'e.g. Senior Mobile Engineer',
                prefixIcon: const Icon(Icons.badge_outlined, size: 20),
                validator: (val) =>
                    Validators.requiredField(val, 'Position is required'),
                enabled: !_isSubmitting,
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                controller: _locationController,
                labelText: 'Location',
                hintText: 'e.g. Remote, San Francisco, CA',
                prefixIcon: const Icon(Icons.location_on_outlined, size: 20),
                enabled: !_isSubmitting,
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                controller: _jobUrlController,
                labelText: 'Job Posting URL',
                hintText: 'https://company.com/careers/job-123',
                prefixIcon: const Icon(Icons.link_rounded, size: 20),
                validator: Validators.url,
                enabled: !_isSubmitting,
              ),
              const SizedBox(height: 16),
              // Status & Applied Date
              LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 420;

                  final statusWidget = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pipeline Status *',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: _selectedStatus,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                        items: AppConstants.applicationStatuses.map((s) {
                          return DropdownMenuItem(
                            value: s,
                            child: Text(
                              s.toTitleCaseFromSnake(),
                              style: const TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: _isSubmitting
                            ? null
                            : (val) {
                                if (val != null)
                                  setState(() => _selectedStatus = val);
                              },
                      ),
                    ],
                  );

                  final dateWidget = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date Applied',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: _isSubmitting ? null : _selectAppliedDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            suffixIcon: Icon(Icons.calendar_month, size: 18),
                          ),
                          child: Text(
                            _appliedAt != null
                                ? _appliedAt!.toShortDate()
                                : 'Select date',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  );

                  if (isCompact) {
                    return Column(
                      children: [
                        statusWidget,
                        const SizedBox(height: 16),
                        dateWidget,
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(child: statusWidget),
                      const SizedBox(width: 12),
                      Expanded(child: dateWidget),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              // Salary Range & Currency
              LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 450;

                  final salaryInputs = Row(
                    children: [
                      Expanded(
                        child: AppTextFormField(
                          controller: _salaryMinController,
                          labelText: 'Min Salary',
                          hintText: '120000',
                          keyboardType: TextInputType.number,
                          validator: Validators.number,
                          enabled: !_isSubmitting,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppTextFormField(
                          controller: _salaryMaxController,
                          labelText: 'Max Salary',
                          hintText: '160000',
                          keyboardType: TextInputType.number,
                          validator: Validators.number,
                          enabled: !_isSubmitting,
                        ),
                      ),
                    ],
                  );

                  final currencyDropdown = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Currency',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: _selectedCurrency,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                        ),
                        items: AppConstants.supportedCurrencies.map((c) {
                          return DropdownMenuItem(
                            value: c,
                            child:
                                Text(c, style: const TextStyle(fontSize: 13)),
                          );
                        }).toList(),
                        onChanged: _isSubmitting
                            ? null
                            : (val) {
                                if (val != null)
                                  setState(() => _selectedCurrency = val);
                              },
                      ),
                    ],
                  );

                  if (isCompact) {
                    return Column(
                      children: [
                        salaryInputs,
                        const SizedBox(height: 12),
                        currencyDropdown,
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(flex: 3, child: salaryInputs),
                      const SizedBox(width: 10),
                      SizedBox(width: 95, child: currencyDropdown),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                controller: _notesController,
                labelText: 'Notes / Recruiter Info',
                hintText:
                    'Referral info, recruiter contact email, prep notes...',
                maxLines: 3,
                enabled: !_isSubmitting,
              ),
              const SizedBox(height: 28),
              AppButton(
                text: isEditMode ? 'Save Changes' : 'Create Application',
                isLoading: _isSubmitting,
                onPressed: _submitForm,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
