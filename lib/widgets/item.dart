import 'package:flutter/material.dart';
import 'package:slidelist_app/common/colors.dart';
import 'package:slidelist_app/models/item.dart';
import 'package:provider/provider.dart';
import 'package:slidelist_app/models/slidelist.dart';

class ItemWidget extends StatefulWidget {
  final ItemModel item;
  const ItemWidget(this.item, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemWidget();
}

class _ItemWidget extends State<ItemWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      var slidelist = context.read<SlideListModel>();
      var newValue = _controller.text;
      if (!_focusNode.hasFocus) {
        if (newValue.replaceAll(RegExp(r'\s'), "").isEmpty) {
          slidelist.deleteItem(widget.item);
        } else if (newValue != widget.item.value) {
          slidelist.updateItemValue(newValue, widget.item);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var slidelist = context.read<SlideListModel>();
    _controller.value = _controller.value.copyWith(
        text: widget.item.value,
        selection: TextSelection(
            baseOffset: widget.item.value.length,
            extentOffset: widget.item.value.length));
    return Dismissible(
        onDismissed: (DismissDirection _) {
          slidelist.toggleItemSide(widget.item);
        },
        resizeDuration: const Duration(milliseconds: 300),
        movementDuration: const Duration(milliseconds: 200),
        key: Key(widget.item.value),
        direction: widget.item.confirmed
            ? DismissDirection.endToStart
            : DismissDirection.startToEnd,
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: Material(
            color: SlideListColors.itemBackground,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: widget.item.confirmed
                        ? SlideListColors.ok
                        : SlideListColors.danger,
                    width: 1.5),
                borderRadius: BorderRadius.circular(6)),
            child: InkWell(
              focusColor: Colors.transparent,
              onTap: FocusScope.of(context).unfocus,
              customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              onLongPress: _focusNode.requestFocus,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16),
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: widget.item.confirmed
                        ? Icon(Icons.check_circle_rounded,
                            size: 28, color: SlideListColors.ok)
                        : Icon(Icons.error,
                            size: 28, color: SlideListColors.danger),
                  ),
                  Expanded(
                    child: AbsorbPointer(
                      absorbing: !_focusNode.hasFocus,
                      child: TextField(
                          scrollPadding:
                              const EdgeInsets.symmetric(vertical: 34),
                          cursorColor: Colors.white10,
                          focusNode: _focusNode,
                          controller: _controller,
                          style: const TextStyle(
                              fontSize: 18, decoration: TextDecoration.none),
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1)),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 2))),
                    ),
                  )
                ]),
              ),
            ),
          ),
        ));
  }
}

class NewItemWidget extends StatefulWidget {
  const NewItemWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewItemWidget();
}

class _NewItemWidget extends State<NewItemWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      var slidelist = context.read<SlideListModel>();
      var value = _controller.text;
      if (!_focusNode.hasFocus) {
        if (value.replaceAll(RegExp(r'\s'), "").isNotEmpty) {
          slidelist.addItem(value);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Material(
        color: SlideListColors.itemBackground,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: SlideListColors.newItem, width: 1.5),
            borderRadius: BorderRadius.circular(6)),
        child: InkWell(
          customBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          onTap: _focusNode.requestFocus,
          focusColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(
                bottom: 18.0, top: 18.0, right: 64, left: 16),
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child:
                    Icon(Icons.error, size: 28, color: SlideListColors.newItem),
              ),
              Expanded(
                child: AbsorbPointer(
                  absorbing: !_focusNode.hasFocus,
                  child: TextField(
                      scrollPadding: const EdgeInsets.symmetric(vertical: 36),
                      cursorColor: Colors.white10,
                      focusNode: _focusNode,
                      controller: _controller,
                      style: const TextStyle(
                          fontSize: 18, decoration: TextDecoration.none),
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                  color: SlideListColors.newItem, width: 2)),
                          isDense: true,
                          contentPadding: const EdgeInsets.only(
                              top: 4, bottom: 4, left: 2))),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
