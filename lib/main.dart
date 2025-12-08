import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'features/workout/views/workout_page.dart';
import 'core/theme/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/viewmodels/settings_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Blocca l'orientamento solo in verticale
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  final themeProvider = ThemeProvider();
  await themeProvider.loadThemePreference();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Workout Timer',
          themeMode: themeProvider.themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const WorkoutPage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}