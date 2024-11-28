import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_card_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/cart_provider.dart';
import '../components/item_player_card.dart';
import '../pages/add_player_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PlayerCardProvider>(context, listen: false).loadCards();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteCardsProvider = Provider.of<FavoritesProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 26, 35, 126),
        titleTextStyle: const TextStyle(
          color: Color.fromARGB(255, 255, 152, 0),
          fontSize: 32,
        ),
        title: const Center(
          child: Text('Карточки футболистов',
              style: TextStyle(fontFamily: 'Montserrat')),
        ),
      ),
      body: Consumer<PlayerCardProvider>(
        builder: (ctx, playerCards, child) {
          if (playerCards.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (playerCards.error != null) {
            return Center(
              child: Text('Ошибка загрузки: ${playerCards.error}'),
            );
          }
          if (playerCards.items.isEmpty) {
            return const Center(
              child: Text('Нет карточек футболистов'),
            );
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: playerCards.items.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: ValueKey(playerCards.items[index].playerCardId),
                onDismissed: (direction) {
                  final currentCard = playerCards.items[index];

                  if (currentCard.isFavorite) {
                    favoriteCardsProvider.toggleFavorite(currentCard);
                  }

                  if (cartProvider.items
                      .any((item) => item.id == currentCard.playerCardId)) {
                    cartProvider.items.removeWhere(
                        (item) => item.id == currentCard.playerCardId);
                  }
                  playerCards.deletePlayerCard(currentCard);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Футболист ${currentCard.footballerName} был удалён',
                      ),
                    ),
                  );
                },
                child: ItemPlayerCard(playerCards.items[index]),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPlayerPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
