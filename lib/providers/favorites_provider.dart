import 'package:flutter/material.dart';
import '../data/models/player_card.dart';

class FavoritesProvider with ChangeNotifier {
  final List<PlayerCard> _items = [];

  List<PlayerCard> get items => _items;

  void toggleFavorite(PlayerCard playerCard) {
    bool isFavoriteCard = playerCard.isFavorite;
    playerCard.isFavorite = !isFavoriteCard;

    if (isFavoriteCard) {
      _items
          .removeWhere((card) => card.playerCardId == playerCard.playerCardId);
    } else {
      _items.add(playerCard);
    }

    notifyListeners();
  }
}
