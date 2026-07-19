import 'package:flutter/material.dart';

class EmailConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Confirm your email')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('A confirmation email has been sent to your address.\nPlease check your inbox and click the confirmation link.'),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () => Navigator.pushReplacementNamed(context, '/login'), child: Text('Back to Login'))
          ],
        ),
      ),
    );
  }
}
