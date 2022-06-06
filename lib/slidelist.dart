import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:slidelist_app/select.dart';
import 'card.dart' as cd;

class SlideList extends InheritedWidget {
  late List<cd.Card> cards;
  cd.Card? activeCard;
  Select_? selectState;

  SlideList({required List<cd.Card> cards, Key? key, required Widget child})
      : super(child: child, key: key) {
    this.cards = cards;
    activeCard = cards.first;
  }

  static SlideList of(BuildContext context) {
    final SlideList? result =
        context.dependOnInheritedWidgetOfExactType<SlideList>();
    assert(result != null, "");
    return result!;
  }

  @override
  bool updateShouldNotify(SlideList oldWidget) {
    return true;
  }

  void deleteCard(cd.Card card) {
    cards.remove(card);
    activeCard = cards.firstOrNull ?? cd.Card(name: 'Default');
  }

  void insertCard(String name) {
    var card = cd.Card(name: name);
    cards.add(card);
    activeCard = card;
    selectState?.toggleDropdown();
  }

  void resetItems() {
    print("Reset items");
  }
}
