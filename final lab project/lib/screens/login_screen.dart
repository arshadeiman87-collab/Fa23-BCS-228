
import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: passCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Login'),
              onPressed: () async {
                final user = await DatabaseHelper.instance.loginUser(emailCtrl.text, passCtrl.text);
                if (user != null) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                }
              },
            ),
            TextButton(
              child: const Text('Register'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen()));
              },
            )
          ],
        ),
      ),
    );
  }
}
