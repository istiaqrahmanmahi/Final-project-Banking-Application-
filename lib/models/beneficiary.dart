

class Beneficiary {
  final String id;
  final String name;
  final String accountNumber;
  final String userId;
  final DateTime createdAt;

  Beneficiary({
    required this.id,
    required this.name,
    required this.accountNumber,
    required this.userId,
    required this.createdAt,
  });

  factory Beneficiary.fromMap(Map<String, dynamic> map) {
    return Beneficiary(
      id: map['id'] as String,
      name: map['name'] as String,
      accountNumber: map['account_number'] as String,
      userId: map['user_id'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap(String userId) {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'account_number': accountNumber,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
