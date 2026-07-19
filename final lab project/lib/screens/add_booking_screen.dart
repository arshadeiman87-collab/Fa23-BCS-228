
import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class AddBookingScreen extends StatelessWidget {
  const AddBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController();
    final pickupCtrl = TextEditingController();
    final dropCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Add Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: pickupCtrl, decoration: const InputDecoration(labelText: 'Pickup')),
            TextField(controller: dropCtrl, decoration: const InputDecoration(labelText: 'Drop')),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () async {
                await DatabaseHelper.instance.insertBooking({
                  'name': nameCtrl.text,
                  'pickup': pickupCtrl.text,
                  'dropoff': dropCtrl.text,
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
