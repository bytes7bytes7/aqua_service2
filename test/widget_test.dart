import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'InheritedWidget Example',
      home: Scaffold(
        body: InheritedWidgetExample(),
      ),
    );
  }
}

class InheritedWidgetExample extends StatefulWidget {
  const InheritedWidgetExample({Key? key}) : super(key: key);

  @override
  _InheritedWidgetExampleState createState() => _InheritedWidgetExampleState();
}

class _InheritedWidgetExampleState extends State<InheritedWidgetExample> {
  final Random _random = Random();
  int _score = 10;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InfoInherited(
            score: _score,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.score),
                CurrentScore(),
              ],
            ),
          ),
          OutlinedButton(
            child: const Text('Change'),
            onPressed: () {
              setState(() {
                _score = _random.nextInt(100);
              });
            },
          ),
        ],
      ),
    );
  }
}

class InfoInherited extends InheritedWidget {
  const InfoInherited({
    Key? key,
    required this.score,
    required Widget child,
  }) : super(key: key, child: child);

  final int score;

  static InfoInherited of(BuildContext context) {
    final InfoInherited? result =
        context.dependOnInheritedWidgetOfExactType<InfoInherited>();
    assert(result != null, 'No InfoInherited found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant InfoInherited oldWidget) {
    return oldWidget.score != score;
  }
}

class CurrentScore extends StatelessWidget {
  const CurrentScore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InfoInherited info = InfoInherited.of(context);

    return Text(info.score.toString());
  }
}
