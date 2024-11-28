import 'package:dio/dio.dart';
import '../models/player_card.dart';

class ApiService {
  final Dio _dio = Dio();

  final String _baseUrl = 'http://localhost:8080';

  // final String _baseUrl = 'http://192.168.1.159:8080';

  Future<List<PlayerCard>> getCards() async {
    try {
      final response = await _dio.get('$_baseUrl/cards');
      if (response.statusCode == 200) {
        List<PlayerCard> cards = (response.data as List)
            .map((cards) => PlayerCard.fromJson(cards))
            .toList();
        return cards;
      } else {
        throw Exception('Failed to load cards');
      }
    } catch (e) {
      throw Exception('Error fetching cards: $e');
    }
  }

  Future<void> updateCard(PlayerCard playerCard) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/cards/update/${playerCard.playerCardId}',
        data: {
          'playerCardId': playerCard.playerCardId,
          'footballerName': playerCard.footballerName,
          'description': playerCard.description,
          'photoUrl': playerCard.photoUrl,
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Ошибка при обновлении данных футболиста: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка при отправке запроса: $e');
    }
  }
}
