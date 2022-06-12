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
  Widget build(BuildContext context) {
    return Consumer<SlideListModel>(
      builder: (context, slidelist, child) {
        return ListView(
          children: slidelist.currentItems,
        );
      },
    );
  }
}
