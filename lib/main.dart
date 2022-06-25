import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slidelist_app/data/database.dart';
import 'package:slidelist_app/widgets/appbar.dart';
import 'package:slidelist_app/widgets/itemlist.dart';
import 'package:slidelist_app/widgets/navbar.dart';
import 'common/colors.dart';
import 'models/slidelist.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var database = SlidelistDB();
  await database.initializeDatabase();
  var cards = await database.loadInitialData();

  var initialCardId = await database.getInitialCardId();
  var initialCard = cards.firstWhere((c) => c.id == initialCardId);
  var slidelist = SlideListModel(database, cards, initialCard);
  runApp(RootWidget(
    slidelist: slidelist,
  ));
}

class RootWidget extends StatelessWidget {
  final SlideListModel slidelist;
  const RootWidget({Key? key, required this.slidelist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          appBar: const SlideListAppBar(),
          body: RawGestureDetector(
              gestures: <Type, GestureRecognizerFactory>{
                AlwaysAcceptHorizontalDragGestureRecognizer:
                    GestureRecognizerFactoryWithHandlers<
                            AlwaysAcceptHorizontalDragGestureRecognizer>(
                        () => AlwaysAcceptHorizontalDragGestureRecognizer(),
                        (AlwaysAcceptHorizontalDragGestureRecognizer instance) {
                  instance.minFlingDistance = 50;
                  instance.onEnd = slidelist.setDragConfirmed;
                }),
              },
              child: Column(children: const [
                Navbar(),
                Expanded(
                  child: ItemList(),
                )
              ]))),
    );
  }
}

class AlwaysAcceptHorizontalDragGestureRecognizer
    extends HorizontalDragGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
