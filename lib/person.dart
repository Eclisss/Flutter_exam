class Person {
  final String firstname;
  final String lastname;
  final String email;
  final String image;

  Person({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.image,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      image: json['image'] ?? 'https://via.placeholder.com/150',
    );
  }
}
