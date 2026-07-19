import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = SupabaseService.currentUser();
  }

  Future<void> _signOut() async {
    await SupabaseService.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home'), actions: [IconButton(icon: Icon(Icons.logout), onPressed: _signOut)]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _user == null
            ? Center(child: Text('No user found.'))
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Email: ${_user!.email ?? "(none)"}'),
                SizedBox(height: 8),
                Text('User ID: ${_user!.id}'),
                SizedBox(height: 8),
                Text('Confirmed at: ${_user!.confirmedAt ?? "Not confirmed"}'),
              ]),
      ),
    );
  }
}
