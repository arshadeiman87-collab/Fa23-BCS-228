import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../widgets/custom_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailCtr = TextEditingController();
  final _passwordCtr = TextEditingController();
  final _confirmCtr = TextEditingController();
  bool _loading = false;

  String? _validate() {
    final email = _emailCtr.text.trim();
    final pwd = _passwordCtr.text;
    final conf = _confirmCtr.text;
    if (email.isEmpty || pwd.isEmpty || conf.isEmpty) return 'Please fill all fields.';
    final emailRegex = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");
    if (!emailRegex.hasMatch(email)) return 'Please enter a valid email.';
    if (pwd.length < 6) return 'Password must be at least 6 characters.';
    if (pwd != conf) return 'Passwords do not match.';
    return null;
  }

  Future<void> _register() async {
    final err = _validate();
    if (err != null) return _showSnack(err);
    setState(() => _loading = true);
    try {
      final res = await SupabaseService.signUp(_emailCtr.text.trim(), _passwordCtr.text);
      // Handle different response shapes for supabase_flutter versions
      if (res.user != null) {
        Navigator.pushReplacementNamed(context, '/email-confirmation');
      } else if (res.session != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else if (res.error != null) {
        _showSnack(res.error!.message);
      } else {
        Navigator.pushReplacementNamed(context, '/email-confirmation');
      }
    } catch (e) {
      _showSnack(e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showSnack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(controller: _emailCtr, label: 'Email', keyboardType: TextInputType.emailAddress),
            SizedBox(height: 12),
            CustomTextField(controller: _passwordCtr, label: 'Password', obscure: true),
            SizedBox(height: 12),
            CustomTextField(controller: _confirmCtr, label: 'Confirm Password', obscure: true),
            SizedBox(height: 20),
            _loading ? CircularProgressIndicator() : SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: _register, child: Text('Create Account')),
            ),
            SizedBox(height: 12),
            TextButton(onPressed: () => Navigator.pushReplacementNamed(context, '/login'), child: Text('Already have an account? Login'))
          ],
        ),
      ),
    );
  }
}
