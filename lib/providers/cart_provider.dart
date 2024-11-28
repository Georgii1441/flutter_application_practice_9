import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../data/models/player_card.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(PlayerCard playerCard) {
    final bool isItemExists =
        _items.any((item) => item.id == playerCard.playerCardId);

    if (isItemExists) {
      _items
          .firstWhere((item) => item.id == playerCard.playerCardId)
          .quantity++;
    } else {
      _items.add(CartItem(
        id: playerCard.playerCardId,
        footballerName: playerCard.footballerName,
        photoUrl: playerCard.photoUrl,
        quantity: 1,
      ));
    }

    notifyListeners();
  }

  void increaseQuantity(CartItem cardItem) {
    _items.firstWhere((item) => item.id == cardItem.id).quantity++;

    notifyListeners();
  }

  void decreaseQuantity(CartItem cardItem) {
    final item = _items.firstWhere((item) => item.id == cardItem.id);
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.removeWhere((item) => item.id == cardItem.id);
    }

    notifyListeners();
  }

  void removeCartItem(CartItem cardItem) {
    _items.removeWhere((item) => item.id == cardItem.id);

    notifyListeners();
  }

  int get totalQuantity {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }
}
