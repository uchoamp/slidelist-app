import 'package:flutter/material.dart';
import 'package:slidelist_app/common/colors.dart';
import 'package:provider/provider.dart';
import 'package:slidelist_app/models/card.dart';
import 'package:slidelist_app/models/slidelist.dart';
import 'package:slidelist_app/widgets/card.dart';

class Select extends StatefulWidget {
  const Select({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _Select();
}

class _Select extends State<Select> {
  final layerLink = LayerLink();
  OverlayEntry? _overlayList;
  final FocusNode activeCardFocusNode = FocusNode();
  bool isOpen = false;
  bool absorbe = true;
  late CardModel currentCard;

  @override
  void initState() {
    super.initState();

    var slidelist = context.read<SlideListModel>();
    currentCard = slidelist.activeCard;
    slidelist.addListener(() {
      if (currentCard != slidelist.activeCard) {
        if (isOpen) {
          _overlayList?.remove();
          setState(() {
            isOpen = false;
          });
        }
        currentCard = slidelist.activeCard;
      }
    });

    activeCardFocusNode.addListener(() {
      if (activeCardFocusNode.hasFocus) {
        setState(() {
          absorbe = false;
        });
      } else {
        setState(() {
          absorbe = true;
        });
      }
    });
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
    var slidelist = context.read<SlideListModel>();
    slidelist.updateCardsWidget();
    return OverlayEntry(builder: (context) {
      return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: layerLink,
            offset: Offset(0, size.height + 2),
            showWhenUnlinked: false,
            child: Material(
                color: SlideListColors.select,
                borderRadius: BorderRadius.circular(5),
                child: Consumer<SlideListModel>(
                    builder: (context, slidelist, child) {
                  var cards = slidelist.cardsWidget;
                  return ListView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 2),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: [...cards, const NewCard()]);
                })),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SlideListModel>(
      builder: (context, slidelist, child) {
        var activeCardWidget =
            CardWidget(slidelist.activeCard, activeCardFocusNode);
        return CompositedTransformTarget(
            link: layerLink,
            child: Material(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: SlideListColors.select,
              child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: toggleDropdown,
                  onLongPress: activeCardFocusNode.requestFocus,
                  child: Container(
                    width: 260,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200,
                            child: AbsorbPointer(
                              child: activeCardWidget,
                              absorbing: absorbe,
                            ),
                          ),
                          Icon(
                            isOpen
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            size: 32,
                          )
                        ]),
                  )),
            ));
      },
    );
  }
}
