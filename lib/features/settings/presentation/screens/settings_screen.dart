import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:job_tracker/core/constants/api_endpoints.dart';
import 'package:job_tracker/core/extensions/context_extensions.dart';
import 'package:job_tracker/core/extensions/date_extensions.dart';
import 'package:job_tracker/core/widgets/confirmation_dialog.dart';
import 'package:job_tracker/core/widgets/responsive_scaffold.dart';
import 'package:job_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:job_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:job_tracker/features/auth/presentation/bloc/auth_state.dart';
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
                              backgroundColor: theme.colorScheme.primary
                                  .withValues(alpha: 0.15),
                              child: Text(
                                user.name.isNotEmpty
                                    ? user.name[0].toUpperCase()
                                    : 'U',
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
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Joined: ${user.createdAt.toMediumDate()}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.logout_rounded,
                                  color: Colors.red),
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
                                  context
                                      .read<AuthBloc>()
                                      .add(const AuthLogoutRequested());
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
                      _buildServerTile(
                        context,
                        title: 'Render Live (Recommended)',
                        subtitle: ApiEndpoints.renderUrl,
                        url: ApiEndpoints.renderUrl,
                        isSelected: state.currentServerUrl == ApiEndpoints.renderUrl,
                      ),
                      const Divider(height: 1),
                      _buildServerTile(
                        context,
                        title: 'Vercel Serverless',
                        subtitle: ApiEndpoints.vercelUrl,
                        url: ApiEndpoints.vercelUrl,
                        isSelected: state.currentServerUrl == ApiEndpoints.vercelUrl,
                      ),
                      const Divider(height: 1),
                      _buildServerTile(
                        context,
                        title: 'Localhost Daemon',
                        subtitle: ApiEndpoints.localUrl,
                        url: ApiEndpoints.localUrl,
                        isSelected: state.currentServerUrl == ApiEndpoints.localUrl,
                      ),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Custom Server URL',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _customUrlController,
                                    decoration: const InputDecoration(
                                      hintText: 'https://custom-server.com',
                                      prefixIcon:
                                          Icon(Icons.dns_rounded, size: 18),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 10),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    final url =
                                        _customUrlController.text.trim();
                                    if (url.isNotEmpty) {
                                      context
                                          .read<SettingsBloc>()
                                          .add(ServerUrlChangedEvent(url));
                                      context.showSnackBar(
                                          'Custom server URL saved');
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
                      _buildThemeTile(
                        context,
                        title: 'System Default',
                        icon: Icons.brightness_auto_rounded,
                        mode: ThemeMode.system,
                        isSelected: state.themeMode == ThemeMode.system,
                      ),
                      const Divider(height: 1),
                      _buildThemeTile(
                        context,
                        title: 'Light Mode',
                        icon: Icons.light_mode_rounded,
                        mode: ThemeMode.light,
                        isSelected: state.themeMode == ThemeMode.light,
                      ),
                      const Divider(height: 1),
                      _buildThemeTile(
                        context,
                        title: 'Dark Mode',
                        icon: Icons.dark_mode_rounded,
                        mode: ThemeMode.dark,
                        isSelected: state.themeMode == ThemeMode.dark,
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

  Widget _buildServerTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String url,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
      trailing: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface.withValues(alpha: 0.4),
      ),
      onTap: () {
        _customUrlController.text = url;
        context.read<SettingsBloc>().add(ServerUrlChangedEvent(url));
        context.showSnackBar('Switched to server: $title');
      },
    );
  }

  Widget _buildThemeTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required ThemeMode mode,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface.withValues(alpha: 0.4),
      ),
      onTap: () {
        context.read<SettingsBloc>().add(ThemeModeChangedEvent(mode));
      },
    );
  }
}
