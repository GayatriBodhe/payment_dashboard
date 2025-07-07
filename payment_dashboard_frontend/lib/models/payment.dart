class Payment {
  final int id;
  final String amount;
  final String receiver;
  final String method;
  final String status;
  final DateTime createdAt;

  Payment({
    required this.id,
    required this.amount,
    required this.receiver,
    required this.method,
    required this.status,
    required this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      amount: json['amount'],
      receiver: json['receiver'],
      method: json['method'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
