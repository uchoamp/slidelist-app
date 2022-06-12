import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slidelist_app/common/colors.dart';
import 'package:slidelist_app/models/slidelist.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Navbar();
}

class _Navbar extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 1,
          child: Consumer<SlideListModel>(
              builder: (context, slidelist, child) => ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 5.0),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(SlideListColors.danger),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ))),
                  onPressed: slidelist.activeCard.confirmed
                      ? slidelist.setNotConfirmed
                      : null,
                  child: const Text(
                    'Não confirmados',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.white),
                  )))),
      Expanded(
          flex: 1,
          child: Consumer<SlideListModel>(
            builder: (context, slidelist, child) => ElevatedButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 5.0),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(SlideListColors.okList),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ))),
                onPressed: slidelist.activeCard.confirmed ||
                        !slidelist.hasItemConfirmed
                    ? null
                    : slidelist.setConfirmed,
                child: const Text(
                  'Confirmados',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                )),
          )),
    ]);
  }
}
