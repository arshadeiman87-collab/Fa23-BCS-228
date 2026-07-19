import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/submission.dart';

class SubmissionForm extends StatefulWidget {
  final Submission? data;
  const SubmissionForm({this.data});

  @override
  _SubmissionFormState createState() => _SubmissionFormState();
}

class _SubmissionFormState extends State<SubmissionForm> {
  final _formKey = GlobalKey<FormState>();
  final service = SupabaseService();

  late TextEditingController name;
  late TextEditingController email;
  late TextEditingController phone;
  late TextEditingController address;
  String gender = "Male";

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.data?.name ?? "");
    email = TextEditingController(text: widget.data?.email ?? "");
    phone = TextEditingController(text: widget.data?.phone ?? "");
    address = TextEditingController(text: widget.data?.address ?? "");
    gender = widget.data?.gender ?? "Male";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.data == null ? "Add Submission" : "Edit Submission")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: name, decoration: InputDecoration(labelText: "Full Name"), validator: (v)=>v!.isEmpty?"Required":null),
              TextFormField(controller: email, decoration: InputDecoration(labelText: "Email"), validator: (v)=>v!.contains("@")?null:"Invalid Email"),
              TextFormField(controller: phone, decoration: InputDecoration(labelText: "Phone"), validator: (v)=>v!.length<8?"Invalid":null),
              TextFormField(controller: address, decoration: InputDecoration(labelText: "Address"), validator: (v)=>v!.isEmpty?"Required":null),

              DropdownButtonFormField(
                value: gender,
                items: ["Male","Female","Other"].map((e)=>DropdownMenuItem(value:e,child:Text(e))).toList(),
                onChanged: (v){ gender = v!; },
              ),

              SizedBox(height:20),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final s = Submission(
                        id: widget.data?.id,
                        name: name.text,
                        email: email.text,
                        phone: phone.text,
                        address: address.text,
                        gender: gender,
                      );

                      if (widget.data == null) {
                        await service.create(s);
                      } else {
                        await service.update(s);
                      }

                      Navigator.pop(context, true);
                    }
                  },
                  child: Text("Submit"))
            ],
          ),
        ),
      ),
    );
  }
}
