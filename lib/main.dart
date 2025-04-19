import 'package:drive_notes/models/note_file.dart';
import 'package:drive_notes/providers/auth_state_provider.dart';
import 'package:drive_notes/screens/create_note_screen.dart';
import 'package:drive_notes/screens/edit_note_screen.dart';
import 'package:drive_notes/screens/main_screen.dart';
import 'package:drive_notes/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Step 1: Initialize Hive
  await Hive.initFlutter();

  // ✅ Step 2: Register adapter
  Hive.registerAdapter(NoteFileAdapter());

  // ✅ Step 3: Open Hive box
  await Hive.openBox<NoteFile>('notesBox');

  runApp(const ProviderScope(child: MyApp()));
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'root',
      redirect: (context, state) => null,
      builder: (context, state) => const _AuthGate(),
    ),
    GoRoute(
      path: '/create',
      name: 'createNote',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const CreateNoteScreen(),
        transitionsBuilder: (context, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
      path: '/edit',
      name: 'editNote',
      pageBuilder: (context, state) {
        final noteFile = state.extra as NoteFile;
        return CustomTransitionPage(
          child: EditNoteScreen(noteFile: noteFile),
          transitionsBuilder: (context, animation, _, child) =>
              FadeTransition(opacity: animation, child: child),
        );
      },
    ),
  ],
);

var kLightColorScheme = ColorScheme.fromSeed(seedColor: Colors.blueAccent);
var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color(0xFF64B5F6),
);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: kLightColorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: kLightColorScheme.primary,
          foregroundColor: kLightColorScheme.onPrimary,
        ),
        cardTheme: CardTheme(
          color: kLightColorScheme.secondaryContainer,
          shadowColor: kLightColorScheme.primary,
          elevation: 5,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kLightColorScheme.primary,
            foregroundColor: kLightColorScheme.onPrimary,
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: kDarkColorScheme.inversePrimary,
          foregroundColor: kDarkColorScheme.onPrimary,
        ),
        cardTheme: CardTheme(
          color: kDarkColorScheme.secondaryContainer,
          shadowColor: kLightColorScheme.primary,
          elevation: 5,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primary,
            foregroundColor: kDarkColorScheme.onPrimary,
          ),
        ),
      ),
      title: 'Drive Notes',
    );
  }
}

class _AuthGate extends ConsumerWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) return const WelcomeScreen();
        return const MainScreen();
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
    );
  }
}
