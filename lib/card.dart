import 'package:flutter/material.dart';
import 'package:slidelist_app/colors.dart';
import 'slidelist.dart';

class Card extends StatefulWidget {
  late String name;
  Card({Key? key, required String name}) : super(key: key) {
    this.name = name;
  }

  @override
  State<StatefulWidget> createState() => _Card();
}

class _Card extends State<Card> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      var slidelist = SlideList.of(context);
      var newName = _controller.text;
      if (!focusNode.hasFocus) {
        if (newName.replaceAll(RegExp(r'\s'), "").isEmpty) {
          slidelist.deleteCard(widget);
        } else if (newName != widget.name) {
          widget.name = newName;
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void setCardActive() {
    FocusScope.of(context).unfocus();
    var slidelist = SlideList.of(context);
    if (slidelist.activeCard == widget) return;
    slidelist.activeCard = widget;
    slidelist.selectState?.toggleDropdown();
  }

  @override
  Widget build(BuildContext context) {
    var slidelist = SlideList.of(context);
    _controller.value = _controller.value.copyWith(
      text: widget.name,
      selection: TextSelection(
          baseOffset: widget.name.length, extentOffset: widget.name.length),
      composing: TextRange.empty,
    );
    if (slidelist.activeCard == widget) {
      slidelist.setFocusActiveCard = () => focusNode.requestFocus();
    }
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        width: double.infinity,
        child: InkWell(
          highlightColor: Colors.transparent,
          onTap: slidelist.activeCard == widget
              ? slidelist.selectState?.toggleDropdown
              : setCardActive,
          onLongPress: focusNode.requestFocus,
          child: AbsorbPointer(
            child: TextField(
                cursorColor: Colors.white10,
                focusNode: focusNode,
                controller: _controller,
                style: const TextStyle(decoration: TextDecoration.none),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(color: Colors.white, width: 1)),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 2))),
          ),
        ));
  }
}

class NewCard extends StatefulWidget {
  const NewCard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewCard();
}

class _NewCard extends State<NewCard> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      var slidelist = SlideList.of(context);
      var name = _controller.text;
      if (!focusNode.hasFocus) {
        if (name.replaceAll(RegExp(r'\s'), "").isNotEmpty) {
          slidelist.insertCard(name);
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
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      width: double.infinity,
      child: InkWell(
        focusColor: Colors.transparent,
        child: TextField(
            cursorColor: Colors.white10,
            focusNode: focusNode,
            controller: _controller,
            style: const TextStyle(decoration: TextDecoration.none),
            decoration: InputDecoration(
                filled: true,
                border: const UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(color: Colors.white, width: 3)),
                focusedBorder: UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    borderSide:
                        BorderSide(color: SlideListColors.ok, width: 3)),
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 4))),
      ),
    );
  }
}
