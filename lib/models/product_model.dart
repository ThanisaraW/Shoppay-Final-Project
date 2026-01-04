class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final int? discountPercent;
  final List<String> images;
  final String shopName;
  final String shopId;
  final bool isShopeeOfficial;
  final double rating;
  final int reviewCount;
  final int soldCount;
  final String categoryId;
  final List<String> tags;
  final bool isFreeShipping;
  final int stock;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    this.discountPercent,
    required this.images,
    required this.shopName,
    required this.shopId,
    this.isShopeeOfficial = false,
    required this.rating,
    required this.reviewCount,
    required this.soldCount,
    required this.categoryId,
    this.tags = const [],
    this.isFreeShipping = false,
    required this.stock,
    required this.createdAt,
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: json['originalPrice'] != null ? (json['originalPrice'] as num).toDouble() : null,
      discountPercent: json['discountPercent'] as int?,
      images: List<String>.from(json['images'] as List),
      shopName: json['shopName'] as String,
      shopId: json['shopId'] as String,
      isShopeeOfficial: json['isShopeeOfficial'] as bool? ?? false,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      soldCount: json['soldCount'] as int,
      categoryId: json['categoryId'] as String,
      tags: List<String>.from(json['tags'] as List? ?? []),
      isFreeShipping: json['isFreeShipping'] as bool? ?? false,
      stock: json['stock'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'discountPercent': discountPercent,
      'images': images,
      'shopName': shopName,
      'shopId': shopId,
      'isShopeeOfficial': isShopeeOfficial,
      'rating': rating,
      'reviewCount': reviewCount,
      'soldCount': soldCount,
      'categoryId': categoryId,
      'tags': tags,
      'isFreeShipping': isFreeShipping,
      'stock': stock,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}