import 'package:flutter/material.dart';
import 'card_model.dart';
import 'dart:math';

class GameState extends ChangeNotifier {
  List<CardModel> cards = [];
  int? firstCardIndex;
  int? secondCardIndex;
  bool isProcessing = false;

  GameState() {
    resetGame();
  }

  void resetGame() {
    cards = [];
    isProcessing = false;
    firstCardIndex = null;
    secondCardIndex = null;

    List<String> animalImages = [
      'assets/cow.png',
      'assets/pig.png',
      'assets/chicken.png',
      'assets/sheep.png',
    ];

    // Duplicate images for pairs
    animalImages = [...animalImages, ...animalImages];
    animalImages.shuffle(Random());

    for (var image in animalImages) {
      cards.add(CardModel(image: image));
    }

    notifyListeners();
  }

  void flipCard(int index) {
    if (isProcessing || cards[index].isFaceUp) return;

    cards[index].isFaceUp = true;
    notifyListeners();

    if (firstCardIndex == null) {
      firstCardIndex = index;
    } else {
      secondCardIndex = index;
      isProcessing = true;

      // Check for match
      if (cards[firstCardIndex!].image == cards[secondCardIndex!].image) {
        firstCardIndex = null;
        secondCardIndex = null;
        isProcessing = false;

        // Check if all cards are matched
        if (allCardsMatched()) {
          // Show win dialog
          Future.delayed(Duration(milliseconds: 100), () {
            _showWinDialog();
          });
        }
      } else {
        Future.delayed(Duration(seconds: 1), () {
          cards[firstCardIndex!].isFaceUp = false;
          cards[secondCardIndex!].isFaceUp = false;
          firstCardIndex = null;
          secondCardIndex = null;
          isProcessing = false;
          notifyListeners();
        });
      }
    }
  }

  bool allCardsMatched() {
    return cards.every((card) => card.isFaceUp);
  }

  void _showWinDialog() {
    // This method is for showing the win dialog.
    // You can access the context using the provider and show the dialog.
    final context = navigatorKey.currentContext;
    if (context != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('You Win!'),
          content: Text('Congratulations! You matched all the cards!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame(); // Reset the game after winning
              },
              child: Text('Play Again'),
            ),
          ],
        ),
      );
    }
  }
}

// Add a global key for navigation to show dialogs
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
