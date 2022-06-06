import 'package:flutter/material.dart';
import 'package:slidelist_app/colors.dart';
import 'card.dart' as cd;
import 'slidelist.dart';

class Select extends StatefulWidget {
  const Select({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => Select_();
}

class Select_ extends State<Select> {
  final layerLink = LayerLink();
  bool isOpen = false;
  OverlayEntry? _overlayList;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void toggleDropdown() {
    FocusScope.of(context).unfocus();
    if (isOpen) {
      _overlayList?.remove();
      setState(() {
        isOpen = false;
      });
    } else {
      _overlayList = _createOverlayEntry();
      Overlay.of(context)!.insert(_overlayList!);
      setState(() {
        isOpen = true;
      });
    }
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    return OverlayEntry(builder: (context) {
      var slidelist = SlideList.of(context);
      var cards =
          slidelist.cards.where((e) => e != slidelist.activeCard).toList();
      return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: layerLink,
            offset: Offset(0, size.height + 2),
            showWhenUnlinked: false,
            child: Material(
                color: SlideListColors.select,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: ListView(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: [...cards, const cd.NewCard()])),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    var slidelist = SlideList.of(context);
    slidelist.selectState = this;
    cd.Card card = slidelist.activeCard!;
    return CompositedTransformTarget(
        link: layerLink,
        child: Material(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: SlideListColors.select,
          child: InkWell(
              onTap: toggleDropdown,
              onLongPress: card.currentState?.focusNode.requestFocus,
              child: Container(
                width: 260,
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 200,
                        child: AbsorbPointer(child: card),
                      ),
                      Icon(
                        isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                        size: 32,
                      )
                    ]),
              )),
        ));
  }
}
