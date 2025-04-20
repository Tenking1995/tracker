class ExpenseModel {
  final String id;
  final String title;
  final String category;
  final String amount;
  final DateTime date;
  final String? note;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  factory ExpenseModel.fromJson(Map<dynamic, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      note: json['note'],
    );
  }
}
