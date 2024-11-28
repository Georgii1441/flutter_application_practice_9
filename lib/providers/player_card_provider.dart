import 'package:flutter/material.dart';
import '../data/services/api_service.dart';
import '../data/models/player_card.dart';

class PlayerCardProvider with ChangeNotifier {
  final List<PlayerCard> _items = [];
  bool _isLoading = false;
  String? _error;

  ApiService apiService = ApiService();

  List<PlayerCard> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCards() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (_items.isNotEmpty) return;

      List<PlayerCard> cards = await apiService.getCards();
      _items.addAll(cards);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePlayerCard(PlayerCard playerCard) async {
    _isLoading = true;
    _error = null;

    final index = _items
        .indexWhere((card) => card.playerCardId == playerCard.playerCardId);

    if (index != -1) {
      _items[index] = playerCard;
    }

    notifyListeners();

    try {
      await apiService.updateCard(playerCard);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addNewPlayerCard(PlayerCard playerCard) {
    int currentPlayerId = _items[_items.length - 1].playerCardId;
    playerCard.playerCardId = currentPlayerId++;
    _items.add(playerCard);

    notifyListeners();
  }

  void deletePlayerCard(PlayerCard playerCard) {
    _items.removeWhere((card) => card.playerCardId == playerCard.playerCardId);

    notifyListeners();
  }
}
