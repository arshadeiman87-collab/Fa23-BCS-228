import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/submission.dart';
import 'form_screen.dart';

class SubmissionListScreen extends StatefulWidget {
  @override
  _SubmissionListScreenState createState() => _SubmissionListScreenState();
}

class _SubmissionListScreenState extends State<SubmissionListScreen> {
  final service = SupabaseService();
  List<Submission> data = [];

  load() async {
    data = await service.read();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Submissions")),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final ok = await Navigator.push(context, MaterialPageRoute(builder: (_) => SubmissionForm()));
          if (ok == true) load();
        },
      ),
      body: ListView.builder(
        itemCount: data.size(),
        itemBuilder: (c,i){
          final s = data[i];
          return ListTile(
            title: Text(s.name),
            subtitle: Text(s.email),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon:Icon(Icons.edit), onPressed: () async {
                  final ok = await Navigator.push(context, MaterialPageRoute(builder: (_) => SubmissionForm(data:s)));
                  if (ok == true) load();
                }),
                IconButton(icon:Icon(Icons.delete), onPressed: () async {
                  await service.delete(s.id!);
                  load();
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
