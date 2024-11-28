import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../components/item_player_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteCardsProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 26, 35, 126),
        titleTextStyle: const TextStyle(
          color: Color.fromARGB(255, 255, 152, 0),
          fontSize: 20,
        ),
        title: const Center(
          child: Text('Избранные карточки футболистов',
              style: TextStyle(fontFamily: 'Montserrat')),
        ),
      ),
      body: favoriteCardsProvider.items.isEmpty
          ? const Center(
              child: Text(
                'В избранном нет футболистов',
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 26, 35, 126)),
              ),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: favoriteCardsProvider.items.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key(favoriteCardsProvider.items[index].playerCardId.toString()),
                  onDismissed: (direction) {
                    String footballerName =
                        favoriteCardsProvider.items[index].footballerName;

                    favoriteCardsProvider.toggleFavorite(favoriteCardsProvider.items[index]);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Футболист $footballerName был удалён из избранного')),
                    );
                  },
                  child: ItemPlayerCard(
                    favoriteCardsProvider.items[index],
                  ),
                );
              },
            ),
    );
  }
}
