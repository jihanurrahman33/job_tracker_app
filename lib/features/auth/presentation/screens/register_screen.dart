import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:job_tracker/core/constants/api_endpoints.dart';
import 'package:job_tracker/core/extensions/context_extensions.dart';
import 'package:job_tracker/core/utils/validators.dart';
import 'package:job_tracker/core/widgets/app_button.dart';
import 'package:job_tracker/core/widgets/app_text_form_field.dart';
import 'package:job_tracker/core/widgets/responsive_scaffold.dart';
import 'package:job_tracker/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:job_tracker/features/settings/presentation/bloc/settings_event.dart';
import 'package:job_tracker/features/settings/presentation/bloc/settings_state.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_header_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthRegisterRequested(
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  void _showServerSwitcher() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select API Server',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      title: const Text('Render Live'),
                      subtitle: const Text(ApiEndpoints.renderUrl, style: TextStyle(fontSize: 12)),
                      trailing: state.currentServerUrl == ApiEndpoints.renderUrl
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () {
                        context.read<SettingsBloc>().add(const ServerUrlChangedEvent(ApiEndpoints.renderUrl));
                        Navigator.pop(modalContext);
                        context.showSnackBar('Switched to Render server');
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('Vercel Serverless'),
                      subtitle: const Text(ApiEndpoints.vercelUrl, style: TextStyle(fontSize: 12)),
                      trailing: state.currentServerUrl == ApiEndpoints.vercelUrl
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () {
                        context.read<SettingsBloc>().add(const ServerUrlChangedEvent(ApiEndpoints.vercelUrl));
                        Navigator.pop(modalContext);
                        context.showSnackBar('Switched to Vercel server');
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('Localhost (8080)'),
                      subtitle: const Text(ApiEndpoints.localUrl, style: TextStyle(fontSize: 12)),
                      trailing: state.currentServerUrl == ApiEndpoints.localUrl
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () {
                        context.read<SettingsBloc>().add(const ServerUrlChangedEvent(ApiEndpoints.localUrl));
                        Navigator.pop(modalContext);
                        context.showSnackBar('Switched to Localhost');
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return ResponsiveScaffold(
      maxWidth: 480,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            context.go('/dashboard');
          } else if (state.status == AuthStatus.failure &&
              state.errorMessage != null) {
            context.showSnackBar(state.errorMessage!, isError: true);
          }
        },
        builder: (context, state) {
          final isLoading = state.status == AuthStatus.authenticating;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: BlocBuilder<SettingsBloc, SettingsState>(
                        builder: (context, settingsState) {
                          final isRender = settingsState.currentServerUrl == ApiEndpoints.renderUrl;
                          final isVercel = settingsState.currentServerUrl == ApiEndpoints.vercelUrl;
                          final label = isRender ? 'Render' : (isVercel ? 'Vercel' : 'Local');

                          return ActionChip(
                            avatar: const Icon(Icons.dns_rounded, size: 14),
                            label: Text('Server: $label', style: const TextStyle(fontSize: 11)),
                            backgroundColor: theme.colorScheme.surface,
                            onPressed: _showServerSwitcher,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    const AuthHeaderWidget(
                      title: 'Create Account',
                      subtitle:
                          'Track your job hunt efficiently and stay organized',
                    ),
                    const SizedBox(height: 28),
                    AppTextFormField(
                      controller: _nameController,
                      labelText: 'Full Name',
                      hintText: 'John Doe',
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.person_outline, size: 20),
                      validator: (val) =>
                          Validators.requiredField(val, 'Name is required'),
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 16),
                    AppTextFormField(
                      controller: _emailController,
                      labelText: 'Email Address',
                      hintText: 'john.doe@example.com',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.email_outlined, size: 20),
                      validator: Validators.email,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 16),
                    AppTextFormField(
                      controller: _passwordController,
                      labelText: 'Password',
                      hintText: '•••••••• (min 6 chars)',
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      validator: Validators.password,
                      onFieldSubmitted: (_) => _onRegister(),
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      text: 'Create Account',
                      onPressed: _onRegister,
                      isLoading: isLoading,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.65),
                          ),
                        ),
                        GestureDetector(
                          onTap: isLoading ? null : () => context.go('/login'),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
