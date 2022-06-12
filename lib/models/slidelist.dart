import 'package:flutter/material.dart';
import 'package:slidelist_app/models/card.dart';
import 'package:collection/collection.dart';
import 'package:slidelist_app/models/item.dart';
import 'package:slidelist_app/widgets/card.dart';
import 'package:slidelist_app/widgets/item.dart';

class SlideListModel extends ChangeNotifier {
  final List<CardModel> cards = [];
  final List<CardWidget> cardsWidget = [];
  CardModel get activeCard {
    _activeCard ??= cards.first;
    return _activeCard!;
  }

  CardModel? _activeCard;
  bool get hasItemConfirmed => activeCard.items.any((i) => i.confirmed);

  SlideListModel() : super() {
    addListener(() {
      if (!hasItemConfirmed && activeCard.confirmed) {
        setNotConfirmed();
      }
    });
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
    activeCard.confirmed = false;
    notifyListeners();
  }

  void setDragConfirmed(DragEndDetails details) {
    if (activeCard.confirmed && details.velocity.pixelsPerSecond.dx > 0) {
      activeCard.confirmed = false;
      notifyListeners();
    } else if (!activeCard.confirmed &&
        details.velocity.pixelsPerSecond.dx < 0 &&
        hasItemConfirmed) {
      activeCard.confirmed = true;
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

  void updateItemValue(String value, ItemModel item) {
    if (!activeCard.items.any((i) => i.value == value && i != item)) {
      item.value = value;
    }
  }

  void deleteItem(ItemModel item) {
    activeCard.items.remove(item);
    notifyListeners();
  }

  void toggleItemSide(ItemModel item) {
    item.confirmed = !item.confirmed;
    notifyListeners();
  }

  void addItem(String value) {
    var item = activeCard.items.firstWhereOrNull((i) => i.value == value);
    if (item != null) {
      item.confirmed = false;
      notifyListeners();
      return;
    }
    activeCard.items.add(ItemModel(value, false));
    notifyListeners();
  }

  void notifyOnDimissed() {
    notifyListeners();
  }
}
