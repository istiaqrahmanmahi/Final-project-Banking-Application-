

class User {
  final String id;
  final String name;
  final String email;
  final String accountNumber;
  final String? avatar;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.accountNumber,
    this.avatar,
  });
}
