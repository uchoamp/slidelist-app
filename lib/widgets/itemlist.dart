import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slidelist_app/models/slidelist.dart';

class ItemList extends StatefulWidget {
  const ItemList({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ItemList();
}

class _ItemList extends State<ItemList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SlideListModel>(
      builder: (context, slidelist, child) {
        return ListView(
          key: UniqueKey(), // Dimissible not works correctly without this
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          children: slidelist.currentItems,
        );
      },
    );
  }
}
