import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/player_card_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/cart_provider.dart';
import 'components/navigation_bar.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => PlayerCardProvider()),
      ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ChangeNotifierProvider(create: (_) => CartProvider()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Карточки футболистов',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color.fromARGB(255, 255, 152, 0),
        fontFamily: 'Montserrat',
      ),
      home: const MainNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}
