
import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: passCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Register'),
              onPressed: () async {
                await DatabaseHelper.instance.registerUser({
                  'email': emailCtrl.text,
                  'password': passCtrl.text,
                });
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
