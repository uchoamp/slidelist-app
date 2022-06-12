import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slidelist_app/models/card.dart';
import 'package:slidelist_app/widgets/appbar.dart';
import 'package:slidelist_app/widgets/itemlist.dart';
import 'package:slidelist_app/widgets/navbar.dart';
import 'common/colors.dart';
import 'models/slidelist.dart';

void main() => runApp(const RootWidget());

class RootWidget extends StatelessWidget {
  const RootWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var slidelist = SlideListModel();
    slidelist.cards.add(CardModel("Default", false, []));
    slidelist.cards.add(CardModel("Other", false, []));
    return ChangeNotifierProvider(
        create: (context) => slidelist,
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              fontFamily: 'Roboto',
              brightness: Brightness.dark,
              scaffoldBackgroundColor: SlideListColors.background),
          home: const SlideListApp(title: 'Flutter Demo Home Page'),
        ));
  }
}

class SlideListApp extends StatefulWidget {
  const SlideListApp({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SlideListApp> createState() => _SlideListAppState();
}

class _SlideListAppState extends State<SlideListApp> {
  @override
  Widget build(BuildContext context) {
    var slidelist = context.read<SlideListModel>();
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: const SlideListAppBar(),
            body: GestureDetector(
                onHorizontalDragStart: slidelist.setDragConfirmed,
                child: Column(children: const [
                  Navbar(),
                  Expanded(
                    child: ItemList(),
                  )
                ]))));
  }
}
