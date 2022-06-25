class ItemModel {
  late int id;
  late int cardId;
  late String value;
  late bool confirmed;

  ItemModel(this.id, this.cardId, this.value, this.confirmed);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "id": id,
      "card_id": cardId,
      "value": value,
      "confirmed": confirmed ? 1 : 0
    };

    return map;
  }

  ItemModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    cardId = map["card_id"];
    value = map["value"];
    confirmed = map["confirmed"] != 0;
  }
}
