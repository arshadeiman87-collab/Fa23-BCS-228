
import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class EditBookingScreen extends StatelessWidget {
  final Map<String, dynamic> booking;
  const EditBookingScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController(text: booking['name']);
    final pickupCtrl = TextEditingController(text: booking['pickup']);
    final dropCtrl = TextEditingController(text: booking['dropoff']);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: pickupCtrl, decoration: const InputDecoration(labelText: 'Pickup')),
            TextField(controller: dropCtrl, decoration: const InputDecoration(labelText: 'Drop')),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Update'),
              onPressed: () async {
                await DatabaseHelper.instance.updateBooking({
                  'id': booking['id'],
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
