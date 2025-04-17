import 'package:drive_notes/providers/auth_state_provider.dart';
import 'package:drive_notes/screens/main_screen.dart';
import 'package:drive_notes/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:googleapis/drive/v3.dart' as drive;
// import 'package:drive_notes/services/drive_service.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drive Notes',
      home: authState.when(
        data: (user) {
          if (user == null) {
            return WelcomeScreen();
          } else {
            // final client =
            //     ref.read(authStateProvider.notifier).authService.getAuthenticatedClient();
            // final driveApi = drive.DriveApi(client);
            // final driveService = DriveService(driveApi);
            return MainScreen();
          }
        },
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => Scaffold(
          body: Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}
