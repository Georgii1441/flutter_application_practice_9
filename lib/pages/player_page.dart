import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_card_provider.dart';
import '../data/models/player_card.dart';

class PlayerPage extends StatelessWidget {
  final int playerCardId;

  const PlayerPage(this.playerCardId, {super.key});

  @override
  Widget build(BuildContext context) {
    final playerCardsProvider = Provider.of<PlayerCardProvider>(context);
    final playerCard = playerCardsProvider.items
        .firstWhere((card) => card.playerCardId == playerCardId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 26, 35, 126),
        title: Text(playerCard.footballerName),
        titleTextStyle: const TextStyle(
          color: Color.fromARGB(255, 255, 152, 0),
          fontSize: 32,
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.edit, color: Color.fromARGB(255, 255, 152, 0)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  final idController = TextEditingController(
                    text: playerCard.playerCardId.toString(),
                  );
                  final nameController = TextEditingController(
                    text: playerCard.footballerName,
                  );
                  final descriptionController = TextEditingController(
                    text: playerCard.description,
                  );
                  final photoUrlController = TextEditingController(
                    text: playerCard.photoUrl,
                  );

                  return AlertDialog(
                    title: const Text("Редактировать данные"),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: "Имя футболиста",
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: descriptionController,
                            decoration: const InputDecoration(
                              labelText: "Описание",
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: photoUrlController,
                            decoration: const InputDecoration(
                              labelText: "URL фото",
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Отмена"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          playerCardsProvider.updatePlayerCard(
                            PlayerCard(
                              playerCardId: int.parse(idController.text),
                              footballerName: nameController.text,
                              description: descriptionController.text,
                              photoUrl: photoUrlController.text,
                            ),
                          );
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Данные футболиста обновлены'),
                            ),
                          );
                        },
                        child: const Text("Сохранить"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              final footballerName = playerCard.footballerName;

              playerCardsProvider.deletePlayerCard(playerCard);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Футболист $footballerName был удалён',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 255, 152, 0),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                playerCard.photoUrl,
                height: 300,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                playerCard.footballerName,
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 33, 33, 33)),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              playerCard.description,
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 26, 35, 126),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
