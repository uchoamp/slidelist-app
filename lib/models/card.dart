import 'package:slidelist_app/models/item.dart';

class CardModel {
  late int id;
  late String name;
  late List<ItemModel> items;
  late bool confirmed;

  CardModel(this.id, this.name, this.confirmed, this.items);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "id": id,
      "name": name,
      "confirmed": confirmed ? 1 : 0
    };

    return map;
  }

  CardModel.fromMap(Map<String, dynamic> map, this.items) {
    id = map["id"];
    name = map["name"];
    confirmed = map["confirmed"] != 0;
  }
}
