import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
void main()=>runApp(MyApp());
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // final wordPair=WordPair.random();
    return MaterialApp(
      title: 'Welcome',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome appbar'),
        ),
        body: Center(
          // child: Text(wordPair.asPascalCase),
          child: RandomWords(),
        ),
      ),
    );


  }

}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  @override
  Widget build(BuildContext context) {
    final wordPair=WordPair.random();
    return Text(wordPair.asPascalCase);
  }
}
