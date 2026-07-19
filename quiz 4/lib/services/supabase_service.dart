import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final _client = Supabase.instance.client;

  static Future<GotrueSessionResponse> signUp(String email, String password) async {
    // For newer supabase_flutter versions, signUp returns GotrueSessionResponse
    return await _client.auth.signUp(email: email, password: password);
  }

  static Future<GotrueSessionResponse> signIn(String email, String password) async {
    return await _client.auth.signInWithPassword(email: email, password: password);
  }

  static User? currentUser() => _client.auth.currentUser;

  static Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
