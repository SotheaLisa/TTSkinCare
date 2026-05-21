import 'package:flutter/foundation.dart';

import 'product_model.dart';
import 'skincare_api_client.dart';

class SkincareRepository {
  Future<List<SkincareProduct>> fetchAll() async {
    final jsonString = await skincareJsonData();

    return compute(skincareProductFromJson, jsonString);
  }

  Future<List<SkincareProduct>> fetchByCategory(
      String categoryName) async {
    final all = await fetchAll();

    if (categoryName.toLowerCase() == 'all') {
      return all;
    }

    return all.where((p) {
      return p.category.name.toLowerCase() ==
          categoryName.toLowerCase();
    }).toList();
  }

  Future<List<SkincareProduct>> search(String query) async {
    if (query.trim().isEmpty) return [];

    final all = await fetchAll();

    final q = query.toLowerCase();

    return all.where((p) {
      return p.title.toLowerCase().contains(q) ||
          p.brand.toLowerCase().contains(q) ||
          p.category.name.toLowerCase().contains(q) ||
          p.skinType.toLowerCase().contains(q);
    }).toList();
  }

  Future<List<SkincareProduct>> fetchFeatured() async {
    final all = await fetchAll();

    return all.where((p) => p.isFeatured).toList();
  }

  List<String> getCategories(List<SkincareProduct> products) {
    final cats = products
        .map((p) => p.category.name)
        .toSet()
        .toList();

    cats.sort();

    return ['All', ...cats];
  }
}