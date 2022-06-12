import 'package:slidelist_app/models/item.dart';

class CardModel {
  late String name;
  late List<ItemModel> items;
  late bool confirmed;

  CardModel(this.name, this.confirmed, this.items);
}
