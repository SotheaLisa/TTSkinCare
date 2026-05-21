// cart_logic.dart
import 'package:flutter/material.dart';
import 'product_model.dart';

class CartItem {
  final SkincareProduct product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartLogic extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalCount => _items.fold(0, (sum, i) => sum + i.quantity);

  double get totalPrice =>
      _items.fold(0.0, (sum, i) => sum + i.product.discountPrice * i.quantity);

  void addItem(SkincareProduct product) {
    final idx = _items.indexWhere((i) => i.product.id == product.id);
    if (idx >= 0) {
      _items[idx].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((i) => i.product.id == productId);
    notifyListeners();
  }

  void decrementItem(String productId) {
    final idx = _items.indexWhere((i) => i.product.id == productId);
    if (idx >= 0) {
      if (_items[idx].quantity > 1) {
        _items[idx].quantity--;
      } else {
        _items.removeAt(idx);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  bool contains(String productId) =>
      _items.any((i) => i.product.id == productId);
}