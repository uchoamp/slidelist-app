import 'package:flutter/material.dart';
import 'package:slidelist_app/common/colors.dart';
import 'package:slidelist_app/models/item.dart';

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
    // _focusNode.addListener(() {
    //   var slidelist = SlideList.of(context);
    //   var newValue = _controller.text;
    //   if (!_focusNode.hasFocus) {
    //     if (newValue.replaceAll(RegExp(r'\s'), "").isEmpty) {
    //       slidelist.deleteItem(widget);
    //     } else if (newValue != widget.value) {
    //       slidelist.updateItem(widget, newValue);
    //     }
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // void updateConfirmed(DismissDirection _) {
  //   var slidelist = SlideList.of(context);
  //   slidelist.updateItemConfirmed(widget);
  //   slidelist.updateSlidelistState();
  // }

  void updateList(DismissDirection _) {}

  @override
  Widget build(BuildContext context) {
    _controller.value = _controller.value.copyWith(
        text: widget.item.value,
        selection: TextSelection(
            baseOffset: widget.item.value.length,
            extentOffset: widget.item.value.length));
    return Dismissible(
        onUpdate: (DismissUpdateDetails _) {},
        // onDismissed: updateConfirmed,
        resizeDuration: const Duration(milliseconds: 30),
        movementDuration: const Duration(milliseconds: 1),
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
                      child: TextField(
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
