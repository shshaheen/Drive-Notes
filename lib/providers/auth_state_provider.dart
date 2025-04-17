import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/google_auth_service.dart';
import 'google_auth_provider.dart';

class AuthState extends AsyncNotifier<GoogleSignInAccount?> {
  late final GoogleAuthService _authService;

  @override
  FutureOr<GoogleSignInAccount?> build() async {
    _authService = ref.read(googleAuthServiceProvider);
    final isLoggedIn = await _authService.isSignedIn();
    if (!isLoggedIn) return null;

    // Attempt silent sign-in to restore session
    final account = await _authService.signInWithGoogle();
    return account;
  }

  Future<void> signIn() async {
    state = const AsyncLoading();
    final account = await _authService.signInWithGoogle();
    state = AsyncData(account);
  }

  Future<void> signOut() async {
    await _authService.signOut();
    state = const AsyncData(null);
  }

  GoogleAuthService get authService => _authService;
}

final authStateProvider =
    AsyncNotifierProvider<AuthState, GoogleSignInAccount?>(() => AuthState());
