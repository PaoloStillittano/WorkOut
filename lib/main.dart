import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/workout_page.dart';
import 'controllers/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeController = ThemeController();
  await themeController.loadThemePreference();

  runApp(
    ChangeNotifierProvider(
      create: (_) => themeController,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, themeController, child) {
        return MaterialApp(
          title: 'Workout Timer',
          themeMode: themeController.themeMode,
          theme: ThemeData(
            fontFamily: 'BebasNeue',
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              secondary: Colors.blueAccent,
              surface: Colors.white,
            ),
            cardColor: Colors.white,
            scaffoldBackgroundColor: Colors.white,
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            fontFamily: 'BebasNeue',
            colorScheme: ColorScheme.dark(
              primary: Colors.blue,
              secondary: Colors.blueAccent,
              surface: Colors.grey[900]!,
            ),
            cardColor: Colors.grey[850],
            scaffoldBackgroundColor: Colors.grey[1200],
            useMaterial3: true,
            brightness: Brightness.dark,
          ),
          home: const WorkoutPage(),
        );
      },
    );
  }
}
