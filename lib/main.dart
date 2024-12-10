import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:japanese_word_tokenizer/japanese_word_tokenizer.dart';
import 'package:kana_kit/kana_kit.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ひょうじゅん語 => なごやべん',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'ひょうじゅん語 => なごやべん'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final HashMap<String, String> _conversionMap = HashMap.of({
    // Grammar
    r'(?:くだ|下)さい' : 'ちょう',
    r'ない' : 'せん',
    r'ている' : 'とる',
    // Verbs
    r'(?:追|お)う' : 'ぼう',
    // Nouns
    r'チョキ' : 'ぴい',
    r'(?:蛙|かえる)' : 'びき',
    r'(?:湿疹|しっしん)' : 'ぼろ',
    // r'(?:蚊|か)' : r'かんす',
    r'(?:眉|まゆ)' : r'まいけ',
    // i-adjectives
    r'(?:痒|かゆ)い' : 'かええ',
  });
  final KanaKit _kanaKit = const KanaKit();
  String _output = '';

  void _convertText(String input) {
    String out = '';

    for (String token in tokenize(input)) {
      out += _convertToken(token);
    }

    setState(() {
      _output = out;
    });
  }

  String _convertToken(String token) {
    for (String key in _conversionMap.keys) {
      int match = token.indexOf(RegExp(key));
      print(match);
      if (match != -1) {
        return token.replaceRange(match, min(match + key.length, token.length), _conversionMap[key]!);
      }
    }
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your text here...',
                  ),
                  onSubmitted: _convertText,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                          border: Border.all(color: Theme.of(context).colorScheme.primary)
                      ),
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            _output
                        ),
                      )
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
