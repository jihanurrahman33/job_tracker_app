import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/app/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/application/presentation/bloc/application_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/reminder/presentation/bloc/reminder_bloc.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/settings/presentation/bloc/settings_event.dart';
import 'features/settings/presentation/bloc/settings_state.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(const JobTrackerApp());
}

class JobTrackerApp extends StatelessWidget {
  const JobTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsBloc>(
          create: (_) => di.sl<SettingsBloc>()..add(const LoadSettingsEvent()),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>(),
        ),
        BlocProvider<ApplicationBloc>(
          create: (_) => di.sl<ApplicationBloc>(),
        ),
        BlocProvider<ReminderBloc>(
          create: (_) => di.sl<ReminderBloc>(),
        ),
        BlocProvider<DashboardBloc>(
          create: (_) => di.sl<DashboardBloc>(),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          return MaterialApp.router(
            title: 'Job Tracker',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsState.themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
