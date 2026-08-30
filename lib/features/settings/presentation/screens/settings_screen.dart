import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/date_extensions.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/responsive_scaffold.dart';
import '../../auth/presentation/bloc/auth_bloc.dart';
import '../../auth/presentation/bloc/auth_event.dart';
import '../../auth/presentation/bloc/auth_state.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _customUrlController;

  @override
  void initState() {
    super.initState();
    final currentUrl = context.read<SettingsBloc>().state.currentServerUrl;
    _customUrlController = TextEditingController(text: currentUrl);
  }

  @override
  void dispose() {
    _customUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return ResponsiveScaffold(
      maxWidth: 700,
      appBar: AppBar(
        title: const Text('Settings & Configuration'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state.user == null) return const SizedBox.shrink();
                final user = state.user!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Profile',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                              child: Text(
                                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    user.email,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Joined: ${user.createdAt.toMediumDate()}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.logout_rounded, color: Colors.red),
                              tooltip: 'Log out',
                              onPressed: () async {
                                final confirmed = await ConfirmationDialog.show(
                                  context,
                                  title: 'Log Out',
                                  content: 'Are you sure you want to sign out?',
                                  confirmText: 'Sign Out',
                                  isDestructive: true,
                                );
                                if (confirmed == true && context.mounted) {
                                  context.read<AuthBloc>().add(const AuthLogoutRequested());
                                  context.go('/login');
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              },
            ),

            Text(
              'Backend API Server',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose the deployment environment to connect to:',
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(height: 12),
            BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                return Card(
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        title: const Text('Render Live (Recommended)'),
                        subtitle: const Text(ApiEndpoints.renderUrl, style: TextStyle(fontSize: 11)),
                        value: ApiEndpoints.renderUrl,
                        groupValue: state.currentServerUrl,
                        onChanged: (val) {
                          if (val != null) {
                            _customUrlController.text = val;
                            context.read<SettingsBloc>().add(ServerUrlChangedEvent(val));
                            context.showSnackBar('Switched to Render server');
                          }
                        },
                      ),
                      const Divider(height: 1),
                      RadioListTile<String>(
                        title: const Text('Vercel Serverless'),
                        subtitle: const Text(ApiEndpoints.vercelUrl, style: TextStyle(fontSize: 11)),
                        value: ApiEndpoints.vercelUrl,
                        groupValue: state.currentServerUrl,
                        onChanged: (val) {
                          if (val != null) {
                            _customUrlController.text = val;
                            context.read<SettingsBloc>().add(ServerUrlChangedEvent(val));
                            context.showSnackBar('Switched to Vercel server');
                          }
                        },
                      ),
                      const Divider(height: 1),
                      RadioListTile<String>(
                        title: const Text('Localhost Daemon'),
                        subtitle: const Text(ApiEndpoints.localUrl, style: TextStyle(fontSize: 11)),
                        value: ApiEndpoints.localUrl,
                        groupValue: state.currentServerUrl,
                        onChanged: (val) {
                          if (val != null) {
                            _customUrlController.text = val;
                            context.read<SettingsBloc>().add(ServerUrlChangedEvent(val));
                            context.showSnackBar('Switched to Localhost server');
                          }
                        },
                      ),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Custom Server URL',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _customUrlController,
                                    decoration: const InputDecoration(
                                      hintText: 'https://custom-server.com',
                                      prefixIcon: Icon(Icons.dns_rounded, size: 18),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    final url = _customUrlController.text.trim();
                                    if (url.isNotEmpty) {
                                      context.read<SettingsBloc>().add(ServerUrlChangedEvent(url));
                                      context.showSnackBar('Custom server URL saved');
                                    }
                                  },
                                  child: const Text('Save'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            Text(
              'Appearance',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                return Card(
                  child: Column(
                    children: [
                      RadioListTile<ThemeMode>(
                        title: const Text('System Default'),
                        secondary: const Icon(Icons.brightness_auto_rounded),
                        value: ThemeMode.system,
                        groupValue: state.themeMode,
                        onChanged: (mode) {
                          if (mode != null) {
                            context.read<SettingsBloc>().add(ThemeModeChangedEvent(mode));
                          }
                        },
                      ),
                      const Divider(height: 1),
                      RadioListTile<ThemeMode>(
                        title: const Text('Light Mode'),
                        secondary: const Icon(Icons.light_mode_rounded),
                        value: ThemeMode.light,
                        groupValue: state.themeMode,
                        onChanged: (mode) {
                          if (mode != null) {
                            context.read<SettingsBloc>().add(ThemeModeChangedEvent(mode));
                          }
                        },
                      ),
                      const Divider(height: 1),
                      RadioListTile<ThemeMode>(
                        title: const Text('Dark Mode'),
                        secondary: const Icon(Icons.dark_mode_rounded),
                        value: ThemeMode.dark,
                        groupValue: state.themeMode,
                        onChanged: (mode) {
                          if (mode != null) {
                            context.read<SettingsBloc>().add(ThemeModeChangedEvent(mode));
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            Center(
              child: Column(
                children: [
                  Text(
                    'Job Tracker App v1.0.0',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Clean Architecture & Material 3 Design',
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
