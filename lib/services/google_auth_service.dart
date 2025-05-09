import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:dio/dio.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    drive.DriveApi.driveFileScope,
  ],
);

final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

class GoogleAuthService {
  http.Client? _client;

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account == null) return null;

      final auth = await account.authentication;

      await _secureStorage.write(key: 'accessToken', value: auth.accessToken);
      await _secureStorage.write(key: 'idToken', value: auth.idToken);

      // print("Access Token: ${auth.accessToken}");

      _client = _authenticatedClientFromAccessToken(auth.accessToken!);

      return account;
    } catch (error) {
      // print("Sign in failed: $error");
      return null;
    }
  }

  http.Client _authenticatedClientFromAccessToken(String accessToken) {
    final credentials = AccessCredentials(
      AccessToken('Bearer', accessToken, DateTime.now().toUtc().add(Duration(hours: 1))),
      null,
      [drive.DriveApi.driveFileScope],
    );

    return authenticatedClient(http.Client(), credentials);
  }

  http.Client getAuthenticatedClient() {
    if (_client == null) {
      throw Exception("Client not initialized. Please sign in first.");
    }
    return _client!;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _secureStorage.deleteAll();
    _client = null;
  }

  Future<bool> isSignedIn() async {
    final accessToken = await _secureStorage.read(key: 'accessToken');
    return accessToken != null;
  }

  /// 🔥 NEW: Return a Dio client with bearer auth
  Future<Dio> getDioClient() async {
    final accessToken = await _secureStorage.read(key: 'accessToken');
    if (accessToken == null) {
      throw Exception('Access token not found. User might not be signed in.');
    }

    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $accessToken';
    return dio;
  }
}
