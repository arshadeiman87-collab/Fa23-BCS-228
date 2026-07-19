import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/submission.dart';

class SupabaseService {
  final client = Supabase.instance.client;

  Future<void> create(Submission s) async {
    await client.from('submissions').insert({
      'name': s.name,
      'email': s.email,
      'phone': s.phone,
      'address': s.address,
      'gender': s.gender,
    });
  }

  Future<List<Submission>> read() async {
    final res = await client.from('submissions').select();
    return res.map<Submission>((e) => Submission.fromMap(e)).toList();
  }

  Future<void> update(Submission s) async {
    await client.from('submissions').update({
      'name': s.name,
      'email': s.email,
      'phone': s.phone,
      'address': s.address,
      'gender': s.gender,
    }).eq('id', s.id);
  }

  Future<void> delete(int id) async {
    await client.from('submissions').delete().eq('id', id);
  }
}
