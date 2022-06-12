import 'package:flutter/material.dart';
import 'package:slidelist_app/common/colors.dart';
import 'package:slidelist_app/models/card.dart';
import 'package:slidelist_app/models/slidelist.dart';
import 'package:provider/provider.dart';

class CardWidget extends StatefulWidget {
  final CardModel card;
  final FocusNode? focusNode;

  const CardWidget(this.card, this.focusNode, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CardWidget();
}

class _CardWidget extends State<CardWidget> {
  final TextEditingController _controller = TextEditingController();
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        var slidelist = context.read<SlideListModel>();
        var newName = _controller.text;
        if (newName.replaceAll(RegExp(r'\s'), "").isEmpty) {
          slidelist.deleteCard(widget.card);
        } else if (newName != widget.card.name) {
          slidelist.updateCard(newName, widget.card);
        }
        FocusScope.of(context).unfocus();
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
    var slidelist = context.read<SlideListModel>();
    if (slidelist.activeCard == widget.card) return;
    slidelist.setActiveCard(widget.card);
  }

  void setFocusEdit() {
    setState(() {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    _controller.value = _controller.value.copyWith(
      text: widget.card.name,
      selection: TextSelection(
          baseOffset: widget.card.name.length,
          extentOffset: widget.card.name.length),
      composing: TextRange.empty,
    );

    return Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        width: double.infinity,
        child: InkWell(
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: _focusNode.hasFocus ? null : setCardActive,
          onLongPress: setFocusEdit,
          child: AbsorbPointer(
            absorbing: !_focusNode.hasFocus,
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
                        borderSide: BorderSide(color: Colors.white, width: 1)),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 6, horizontal: 2))),
          ),
        ));
  }
}

class NewCardWidget extends StatefulWidget {
  const NewCardWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewCardWidget();
}

class _NewCardWidget extends State<NewCardWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      var slidelist = context.read<SlideListModel>();
      var name = _controller.text;
      if (!focusNode.hasFocus) {
        if (name.replaceAll(RegExp(r'\s'), "").isNotEmpty) {
          slidelist.addCard(name);
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
