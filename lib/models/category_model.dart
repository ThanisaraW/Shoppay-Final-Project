class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final String? imageUrl;
  final int productCount;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    this.imageUrl,
    required this.productCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      imageUrl: json['imageUrl'] as String?,
      productCount: json['productCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'imageUrl': imageUrl,
      'productCount': productCount,
    };
  }
}