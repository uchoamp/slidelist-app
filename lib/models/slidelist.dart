import 'package:flutter/material.dart';
import 'package:slidelist_app/data/database.dart';
import 'package:slidelist_app/models/card.dart';
import 'package:collection/collection.dart';
import 'package:slidelist_app/models/item.dart';
import 'package:slidelist_app/widgets/card.dart';
import 'package:slidelist_app/widgets/item.dart';

class SlideListModel extends ChangeNotifier {
  late SlidelistDB database;
  final List<CardModel> cards;
  final List<CardWidget> cardsWidget = [];
  CardModel get activeCard {
    _activeCard ??= cards.first;
    return _activeCard!;
  }

  CardModel? _activeCard;
  bool get hasItemConfirmed => activeCard.items.any((i) => i.confirmed);

  SlideListModel(this.database, this.cards, this._activeCard) : super() {
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
    database.setInitialCard(card);
    notifyListeners();
  }

  void addCard(String name) {
    var card = cards.firstWhereOrNull((c) => c.name == name);
    if (card == null) {
      card = CardModel(database.nextCardId, name, false, []);
      database.nextCardId++;
      cards.add(card);
      database.insertCard(card);
    }
    database.setInitialCard(card);
    _activeCard = card;
    notifyListeners();
  }

  void updateCard(String name, CardModel card) {
    var cardSameName =
        cards.firstWhereOrNull((c) => c.name == name && c != card);
    if (cardSameName != null) {
      if (cardSameName == activeCard || card == activeCard) _activeCard = card;
      cards.remove(cardSameName);
      database.deleteCard(cardSameName);
      for (var item in cardSameName.items) {
        if (!card.items.any((i) => i.value == item.value)) {
          item.cardId = card.id;
          card.items.add(item);
        } else {
          database.deleteItem(item);
        }
      }
    }
    card.name = name;
    database.updateCard(card);
    database.setInitialCard(card);
    database.updateItemsCard(card.items, card.id);
    notifyListeners();
  }

  void deleteCard(CardModel card) {
    cards.remove(card);
    database.deleteCard(card);
    database.deleteCardItems(card);
    if (cards.isEmpty) {
      addCard("Default");
    } else {
      if (card == activeCard) {
        _activeCard = cards.first;
      }
      notifyListeners();
    }
  }

  void resetItems() {
    for (var item in activeCard.items) {
      item.confirmed = false;
    }
    activeCard.confirmed = false;
    database.resetCardItems(activeCard);
    database.updateCard(activeCard);
    notifyListeners();
  }

  void setDragConfirmed(DragEndDetails details) {
    if (activeCard.confirmed && details.velocity.pixelsPerSecond.dx > 0) {
      setConfirmed();
    } else if (!activeCard.confirmed &&
        details.velocity.pixelsPerSecond.dx < 0 &&
        hasItemConfirmed) {
      setNotConfirmed();
    }
  }

  void setConfirmed() {
    activeCard.confirmed = true;
    database.updateCard(activeCard);
    notifyListeners();
  }

  void setNotConfirmed() {
    activeCard.confirmed = false;
    database.updateCard(activeCard);
    notifyListeners();
  }

  void updateItemValue(String value, ItemModel item) {
    if (!activeCard.items.any((i) => i.value == value && i != item)) {
      item.value = value;
      database.updateItem(item);
    }
  }

  void deleteItem(ItemModel item) {
    activeCard.items.remove(item);
    database.deleteItem(item);
    notifyListeners();
  }

  void toggleItemSide(ItemModel item) {
    item.confirmed = !item.confirmed;
    database.updateItem(item);
    notifyListeners();
  }

  void addItem(String value) {
    var item = activeCard.items.firstWhereOrNull((i) => i.value == value);
    if (item != null) {
      item.confirmed = false;
      notifyListeners();
      return;
    }
    item = ItemModel(database.nextItemId, activeCard.id, value, false);
    database.nextItemId++;
    activeCard.items.add(item);
    database.insertItem(item);
    notifyListeners();
  }

  void notifyOnDimissed() {
    notifyListeners();
  }
}
