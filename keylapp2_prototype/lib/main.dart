import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'application/providers.dart';
import 'presentation/screens/keyboard_comparison_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cache the SharedPreferences handle so the ComparisonSessionNotifier can
  // restore/persist synchronously during build.
  final prefs = await SharedPreferences.getInstance();
  cachePreferences(prefs);

  runApp(const ProviderScope(child: KeylappApp()));
}

class KeylappApp extends ConsumerWidget {
  const KeylappApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataState = ref.watch(dataLoadedProvider);

    return MaterialApp(
      title: 'Keylapp 2.0',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF12121E),
        colorScheme: const ColorScheme.dark(
          surface: Color(0xFF12121E),
          onSurface: Colors.white,
        ),
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home: dataState.when(
        loading: () => const _LoadingScreen(),
        error: (e, st) => _ErrorScreen(error: e.toString()),
        data: (_) => const KeyboardComparisonScreen(),
      ),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF12121E),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.blueAccent),
            SizedBox(height: 16),
            Text('Loading layouts…', style: TextStyle(color: Colors.white54)),
          ],
        ),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  final String error;
  const _ErrorScreen({required this.error});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12121E),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
              const SizedBox(height: 16),
              const Text('Could not load bundled data.',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 8),
              Text(error, style: const TextStyle(color: Colors.white38, fontSize: 12), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}