import 'package:flutter/material.dart';
import 'package:slidelist_app/select.dart';
import 'package:slidelist_app/slidelist.dart';

import 'colors.dart';

class SlideListAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SlideListAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var slidelist = SlideList.of(context);
    return SafeArea(
        child: Container(
            decoration: BoxDecoration(
              color: SlideListColors.background,
            ),
            width: double.infinity,
            height: 90,
            child: Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                  const Select(),
                  Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: const Icon(Icons.restart_alt),
                      iconSize: 38,
                      splashRadius: 26,
                      color: SlideListColors.reset,
                      onPressed: slidelist.resetItems,
                    ),
                  )
                ]))));
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}
