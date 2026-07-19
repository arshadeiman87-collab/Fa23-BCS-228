
import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import 'add_booking_screen.dart';
import 'edit_booking_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> bookings = [];

  void loadData() async {
    bookings = await DatabaseHelper.instance.getBookings();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ride Bookings')),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (c, i) => Card(
          child: ListTile(
            title: Text(bookings[i]['name']),
            subtitle: Text('${bookings[i]['pickup']} → ${bookings[i]['dropoff']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditBookingScreen(booking: bookings[i]),
                      ),
                    );
                    loadData();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await DatabaseHelper.instance.deleteBooking(bookings[i]['id']);
                    loadData();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddBookingScreen()));
          loadData();
        },
      ),
    );
  }
}
