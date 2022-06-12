import 'package:flutter/material.dart';
import 'package:slidelist_app/models/card.dart';
import 'package:collection/collection.dart';
import 'package:slidelist_app/widgets/card.dart';
import 'package:slidelist_app/widgets/item.dart';

class SlideListModel extends ChangeNotifier {
  final List<CardModel> cards = [];
  final List<CardWidget> cardsWidget = [];

  CardModel? _activeCard;

  CardModel get activeCard {
    _activeCard ??= cards.first;
    return _activeCard!;
  }

  List<ItemWidget> get currentItems => activeCard.items
      .where((i) => i.confirmed == activeCard.confirmed)
      .map((i) => ItemWidget(i))
      .toList();

  void updateCardsWidget() {
    cardsWidget.clear();
    cardsWidget.addAll(
        cards.where((c) => c != activeCard).map((c) => CardWidget(c, null)));
  }

  void setDragConfirmed(DragStartDetails dragDetails) {
    if (activeCard.confirmed && dragDetails.globalPosition.direction > 1) {
      activeCard.confirmed = true;
      notifyListeners();
    } else if (!activeCard.confirmed &&
        dragDetails.globalPosition.direction <= 1) {
      activeCard.confirmed = false;
      notifyListeners();
    }
  }

  void setConfirmed() {
    activeCard.confirmed = true;
    notifyListeners();
  }

  void setNotConfirmed() {
    activeCard.confirmed = false;
    notifyListeners();
  }

  void setActiveCard(CardModel card) {
    _activeCard = card;
    notifyListeners();
  }

  void addCard(String name) {
    var card = cards.firstWhereOrNull((c) => c.name == name);
    if (card == null) {
      card = CardModel(name, false, []);
      cards.add(card);
    }
    _activeCard = card;
    notifyListeners();
  }

  void updateCard(String name, CardModel card) {
    var cardSameName =
        cards.firstWhereOrNull((c) => c.name == name && c != card);
    if (cardSameName != null) {
      if (cardSameName == activeCard || card == activeCard) _activeCard = card;
      cards.remove(cardSameName);
      for (var item in cardSameName.items) {
        if (!card.items.any((i) => i.value == item.value)) {
          card.items.add(item);
        }
      }
    }
    card.name = name;
    updateCardsWidget();
    notifyListeners();
  }

  void deleteCard(CardModel card) {
    cards.remove(card);
    if (card == activeCard) {
      if (cards.isEmpty) {
        cards.add(CardModel('Default', false, []));
      }
      _activeCard = cards.first;
    }
    updateCardsWidget();
    notifyListeners();
  }

  void resetItems() {
    for (var item in activeCard.items) {
      item.confirmed = false;
    }
  }
}
