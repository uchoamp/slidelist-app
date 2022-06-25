import "dart:async";

import 'package:path/path.dart';
import 'package:slidelist_app/data/tables.dart';
import 'package:slidelist_app/models/card.dart';
import 'package:slidelist_app/models/item.dart';
import 'package:sqflite/sqflite.dart';

class SlidelistDB {
  static const String databaseName = "slidelist_database.db";
  late Database db;
  late int nextCardId = 1;
  late int nextItemId = 1;

  Future initializeDatabase() async {
    db = await openDatabase(join(await getDatabasesPath(), databaseName),
        onCreate: (db, version) async {
      await db.execute(Tables.cards);
      await db.execute(Tables.initialState);
      await db.execute(Tables.items);
      await db.execute(
          "INSERT INTO [cards] (id, name, confirmed) VALUES(1, 'Default', 0)");
      await db.execute("INSERT INTO [initial_state] (card_id) VALUES(1)");
    }, version: 1);

    final List<Map<String, dynamic>> resultCardLastId =
        await db.query('cards', columns: ["id"], limit: 1, orderBy: "id DESC");
    final List<Map<String, dynamic>> resultItemLastId =
        await db.query('items', columns: ["id"], limit: 1, orderBy: "id DESC");

    if (resultCardLastId.isNotEmpty) {
      nextCardId = resultCardLastId.first["id"] + 1;
    }
    if (resultItemLastId.isNotEmpty) {
      nextItemId = resultItemLastId.first["id"] + 1;
    }
  }

  Future<List<CardModel>> loadInitialData() async {
    final List<Map<String, dynamic>> cardsResult = await db.query('cards');
    final List<Map<String, dynamic>> itemsResult = await db.query('items');

    final List<ItemModel> items =
        itemsResult.map((mapItem) => ItemModel.fromMap(mapItem)).toList();
    final List<CardModel> cards = cardsResult
        .map((mapCard) => CardModel.fromMap(mapCard,
            items.where((item) => item.cardId == mapCard["id"]).toList()))
        .toList();

    return cards;
  }

  Future<int> getInitialCardId() async {
    final List<Map<String, dynamic>> result = await db.query('initial_state');

    return result.first["card_id"];
  }

  Future insertCard(CardModel card) async {
    await db.insert("cards", card.toMap());
  }

  Future updateCard(CardModel card) async {
    await db
        .update("cards", card.toMap(), where: "id = ?", whereArgs: [card.id]);
  }

  Future deleteCard(CardModel card) async {
    await db.delete("cards", where: "id = ?", whereArgs: [card.id]);
  }

  Future deleteCardItems(CardModel card) async {
    await db.delete("items", where: "card_id = ?", whereArgs: [card.id]);
  }

  Future resetCardItems(CardModel card) async {
    await db.update("items", <String, Object?>{"confirmed": 0},
        where: "card_id = ?", whereArgs: [card.id]);
  }

  Future setInitialCard(CardModel card) async {
    await db.update("initial_state", <String, Object?>{"card_id": card.id});
  }

  Future insertItem(ItemModel item) async {
    await db.insert("items", item.toMap());
  }

  Future updateItem(ItemModel item) async {
    await db
        .update("items", item.toMap(), where: "id = ?", whereArgs: [item.id]);
  }

  Future deleteItem(ItemModel item) async {
    await db.delete("items", where: "id = ?", whereArgs: [item.id]);
  }

  Future updateItemsCard(List<ItemModel> items, int cardId) async {
    await db.update("items", <String, Object?>{"card_id": cardId},
        where: "card_id IN (${List.filled(items.length, "?").join(",")})",
        whereArgs: items.map((item) => item.id).toList());
  }
}
