class ExpenseCategoryModel {
  final String name;
  final int? recommendedPercentage;
  final bool isFixed;

  ExpenseCategoryModel({
    required this.name,
    this.recommendedPercentage,
    required this.isFixed,
  });

  factory ExpenseCategoryModel.fromJson(Map<String, dynamic> json) {
    return ExpenseCategoryModel(
      name: json['name'],
      recommendedPercentage: json['recommendedPercentage'],
      isFixed: json['isFixed'],
    );
  }
}
