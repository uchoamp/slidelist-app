import 'package:flutter/material.dart';
import 'package:slidelist_app/appbar.dart';
import 'colors.dart';
import 'slidelist.dart';
import 'card.dart' as cd;

void main() => runApp(const RootWidget());

class RootWidget extends StatelessWidget {
  const RootWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideList(
        cards: [
          cd.Card(name: 'Teste 1'),
          cd.Card(name: 'Teste 2'),
          cd.Card(
            name: 'Teste 3',
          )
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: const Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: SlideListAppBar(),
        body: Center(child: Text('Hello World!')),
      ),
    );
  }
}
