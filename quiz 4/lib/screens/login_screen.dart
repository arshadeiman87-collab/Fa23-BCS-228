import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtr = TextEditingController();
  final _passwordCtr = TextEditingController();
  bool _loading = false;

  String? _validate() {
    final email = _emailCtr.text.trim();
    final pwd = _passwordCtr.text;
    if (email.isEmpty || pwd.isEmpty) return 'Please enter email and password.';
    final emailRegex = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");
    if (!emailRegex.hasMatch(email)) return 'Please enter a valid email.';
    return null;
  }

  Future<void> _login() async {
    final err = _validate();
    if (err != null) return _showSnack(err);
    setState(() => _loading = true);
    try {
      final res = await SupabaseService.signIn(_emailCtr.text.trim(), _passwordCtr.text);
      if (res.error != null) {
        _showSnack(res.error!.message);
      } else if (res.session != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showSnack('Unknown login response.');
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
      appBar: AppBar(title: Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          CustomTextField(controller: _emailCtr, label: 'Email', keyboardType: TextInputType.emailAddress),
          SizedBox(height: 12),
          CustomTextField(controller: _passwordCtr, label: 'Password', obscure: true),
          SizedBox(height: 20),
          _loading ? CircularProgressIndicator() : SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _login, child: Text('Login'))),
          SizedBox(height: 12),
          TextButton(onPressed: () => Navigator.pushReplacementNamed(context, '/register'), child: Text('Don\'t have an account? Register'))
        ]),
      ),
    );
  }
}
