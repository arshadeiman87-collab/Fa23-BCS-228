class Submission {
  int? id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String gender;

  Submission({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.gender,
  });

  factory Submission.fromMap(Map<String, dynamic> map) => Submission(
        id: map['id'],
        name: map['name'],
        email: map['email'],
        phone: map['phone'],
        address: map['address'],
        gender: map['gender'],
      );
}
