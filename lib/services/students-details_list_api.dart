// import 'dart:convert';
// import 'package:http/http.dart' as http;


// Future<List<Student>> fetchStudents() async {
//   final apiUrl = Uri.parse('http://192.168.1.7/api/students'); // Replace with your API endpoint

//   try {
//     final response = await http.get(apiUrl);

//     if (response.statusCode == 200) {
//       final List<dynamic> studentData = json.decode(response.body);
//       return studentData.map((data) => Student.fromJson(data)).toList();
//     } else {
//       throw Exception('Failed to fetch students');
//     }
//   } catch (e) {
//     throw Exception('Error: $e');
//   }
// }



class Student {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final int status;
  final int roleId;
  final String createdAt;
  final String updatedAt;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.status,
    required this.roleId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      status: json['status'],
      roleId: json['role_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
