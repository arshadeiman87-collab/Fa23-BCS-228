
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const RideBookingApp());
}

class RideBookingApp extends StatelessWidget {
  const RideBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
