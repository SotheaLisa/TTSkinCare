import 'dart:convert';

List<SkincareProduct> skincareProductFromJson(String str) =>
    List<SkincareProduct>.from(
      json.decode(str).map((x) => SkincareProduct.fromJson(x)),
    );

class ProductCategory {
  final String name;
  final String slug;

  ProductCategory({
    required this.name,
    required this.slug,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}

class SkincareProduct {
  final String id;
  final String title;
  final double price;
  final double discountPrice;
  final String description;
  final String brand;
  final String skinType;
  final ProductCategory category;
  final List<String> images;
  final double rating;
  final int stock;
  final bool isFeatured;

  SkincareProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.discountPrice,
    required this.description,
    required this.brand,
    required this.skinType,
    required this.category,
    required this.images,
    required this.rating,
    required this.stock,
    required this.isFeatured,
  });

  factory SkincareProduct.fromJson(Map<String, dynamic> json) {
    return SkincareProduct(
      id: json['id'].toString(),

      title: json['title'] ?? '',

      price: (json['price'] ?? 0).toDouble(),

      discountPrice: (json['discountPrice'] ?? 0).toDouble(),

      description: json['description'] ?? '',

      brand: json['brand'] ?? '',

      skinType: json['skinType'] ?? '',

      category: ProductCategory.fromJson(
        json['category'] ?? {},
      ),

      // FIXED IMAGE PARSING
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : [],

      rating: (json['rating'] ?? 0).toDouble(),

      stock: json['stock'] ?? 0,

      isFeatured: json['isFeatured'] ?? false,
    );
  }

  bool get hasDiscount => discountPrice < price;

  int get discountPercent {
    if (price <= 0) return 0;

    return (((price - discountPrice) / price) * 100).round();
  }
}