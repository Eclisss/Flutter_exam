import 'dart:convert';
import 'package:http/http.dart' as http;
import 'person.dart';

class ApiService {
  static const String baseUrl = 'https://fakerapi.it/api/v1/persons';

  static Future<List<Person>> fetchPersons(int quantity) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?_quantity=$quantity'));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        List<dynamic> personList = data['data'];

        return personList.map((json) => Person.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load persons: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching persons: $e');
      return [];
    }
  }
}
