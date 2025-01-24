import 'dart:convert';

class Expenses {
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  Expenses(
      {required this.id,
      required this.title,
      required this.amount,
      required this.date});

  factory Expenses.fromJson(Map<String, dynamic> json) {
    return Expenses(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
    );
  }

  factory Expenses.fromJsonString(String jsonString) {
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return Expenses(
      id: jsonMap['id'],
      title: jsonMap['title'],
      amount: jsonMap['amount'].toDouble(),
      date: DateTime.parse(jsonMap['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date,
    };
  }

  String toJsonString() {
    return '{"id": "$id", "title": "$title", "amount": $amount, "date": "${date.toIso8601String()}"}';
  }
}
