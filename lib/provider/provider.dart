import 'package:flutter/material.dart';
import '../api_service.dart';
import '../person.dart';

class PersonProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Person> _persons = [];
  bool _isLoading = false;
  int _fetchAttempts = 0;
  bool _hasMoreData = true;

  List<Person> get persons => _persons;
  bool get isLoading => _isLoading;
  int get fetchAttempts => _fetchAttempts;
  bool get hasMoreData => _hasMoreData;

  Future<void> fetchPersons(int quantity) async {
    if (!_hasMoreData || _isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      List<Person> newPersons = await ApiService.fetchPersons(quantity);
      if (newPersons.isNotEmpty) {
        _persons.addAll(newPersons);
        _fetchAttempts++;
      } else {
        _hasMoreData = false;
      }
    } catch (e) {
      print('Error fetching persons: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void refreshPersons() {
    _persons.clear();
    _fetchAttempts = 0;
    _hasMoreData = true;
    fetchPersons(10);
  }

  void setNoMoreData() {
    _hasMoreData = false;
    notifyListeners();
  }
}
