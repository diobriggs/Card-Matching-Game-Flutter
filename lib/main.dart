import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state_of_game.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameState(),
      child: MaterialApp(
        title: 'Animal Matching Game',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        navigatorKey: navigatorKey, // Set the navigator key
        home: GameScreen(),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Animal Matching Game'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // Change based on your layout preference
        ),
        itemCount: gameState.cards.length,
        itemBuilder: (context, index) {
          final card = gameState.cards[index];
          return GestureDetector(
            onTap: () => gameState.flipCard(index),
            child: Card(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(card.isFaceUp ? card.image : 'assets/cards/back.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          gameState.resetGame();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
